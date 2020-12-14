Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51DF62D9EF1
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 19:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408318AbgLNSZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 13:25:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:47736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502324AbgLNRiO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:38:14 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Libo Chen <libo.chen@oracle.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.9 080/105] ktest.pl: Fix incorrect reboot for grub2bls
Date:   Mon, 14 Dec 2020 18:28:54 +0100
Message-Id: <20201214172559.122072827@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Libo Chen <libo.chen@oracle.com>

commit 271e0c9dce1b02a825b3cc1a7aa1fab7c381d44b upstream.

This issue was first noticed when I was testing different kernels on
Oracle Linux 8 which as Fedora 30+ adopts BLS as default. Even though a
kernel entry was added successfully and the index of that kernel entry was
retrieved correctly, ktest still wouldn't reboot the system into
user-specified kernel.

The bug was spotted in subroutine reboot_to where the if-statement never
checks for REBOOT_TYPE "grub2bls", therefore the desired entry will not be
set for the next boot.

Add a check for "grub2bls" so that $grub_reboot $grub_number can
be run before a reboot if REBOOT_TYPE is "grub2bls" then we can boot to
the correct kernel.

Link: https://lkml.kernel.org/r/20201121021243.1532477-1-libo.chen@oracle.com

Cc: stable@vger.kernel.org
Fixes: ac2466456eaa ("ktest: introduce grub2bls REBOOT_TYPE option")
Signed-off-by: Libo Chen <libo.chen@oracle.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/testing/ktest/ktest.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -2040,7 +2040,7 @@ sub reboot_to {
 
     if ($reboot_type eq "grub") {
 	run_ssh "'(echo \"savedefault --default=$grub_number --once\" | grub --batch)'";
-    } elsif ($reboot_type eq "grub2") {
+    } elsif (($reboot_type eq "grub2") or ($reboot_type eq "grub2bls")) {
 	run_ssh "$grub_reboot $grub_number";
     } elsif ($reboot_type eq "syslinux") {
 	run_ssh "$syslinux --once \\\"$syslinux_label\\\" $syslinux_path";


