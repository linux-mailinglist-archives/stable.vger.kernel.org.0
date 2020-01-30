Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9A014E149
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730522AbgA3SnD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:43:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:51540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730520AbgA3SnC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:43:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AD66205F4;
        Thu, 30 Jan 2020 18:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409781;
        bh=6GzoNV0zyINcGNLAPy2ZdbfQ+iqqU24+bbg51LWIlX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D+uHYnkHPkeV08Hz9QqBXbq0zcdgyIVQAaMTluS48QOjESxxHfKEltjUhsStJJ5ei
         LS3N2JhiQ7Lcr6RuBg4HENR4lUt5vzJVAzXbUaH/ZMOduGDSLAtonLEameJ5NguwG8
         QmzA3/o15D93wlIq1qzE+aBSMlvicPmJ9fxmtgXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Pavel Shilovsky <pshilov@microsoft.com>
Subject: [PATCH 5.4 030/110] cifs: Fix memory allocation in __smb2_handle_cancelled_cmd()
Date:   Thu, 30 Jan 2020 19:38:06 +0100
Message-Id: <20200130183618.971449955@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
References: <20200130183613.810054545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paulo Alcantara (SUSE) <pc@cjr.nz>

commit 0a5a98863c9debc02387b3d23c46d187756f5e2b upstream.

__smb2_handle_cancelled_cmd() is called under a spin lock held in
cifs_mid_q_entry_release(), so make its memory allocation GFP_ATOMIC.

This issue was observed when running xfstests generic/028:

[ 1722.589204] CIFS VFS: \\192.168.30.26 Cancelling wait for mid 72064 cmd: 5
[ 1722.590687] CIFS VFS: \\192.168.30.26 Cancelling wait for mid 72065 cmd: 17
[ 1722.593529] CIFS VFS: \\192.168.30.26 Cancelling wait for mid 72066 cmd: 6
[ 1723.039014] BUG: sleeping function called from invalid context at mm/slab.h:565
[ 1723.040710] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 30877, name: cifsd
[ 1723.045098] CPU: 3 PID: 30877 Comm: cifsd Not tainted 5.5.0-rc4+ #313
[ 1723.046256] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.0-59-gc9ba527-rebuilt.opensuse.org 04/01/2014
[ 1723.048221] Call Trace:
[ 1723.048689]  dump_stack+0x97/0xe0
[ 1723.049268]  ___might_sleep.cold+0xd1/0xe1
[ 1723.050069]  kmem_cache_alloc_trace+0x204/0x2b0
[ 1723.051051]  __smb2_handle_cancelled_cmd+0x40/0x140 [cifs]
[ 1723.052137]  smb2_handle_cancelled_mid+0xf6/0x120 [cifs]
[ 1723.053247]  cifs_mid_q_entry_release+0x44d/0x630 [cifs]
[ 1723.054351]  ? cifs_reconnect+0x26a/0x1620 [cifs]
[ 1723.055325]  cifs_demultiplex_thread+0xad4/0x14a0 [cifs]
[ 1723.056458]  ? cifs_handle_standard+0x2c0/0x2c0 [cifs]
[ 1723.057365]  ? kvm_sched_clock_read+0x14/0x30
[ 1723.058197]  ? sched_clock+0x5/0x10
[ 1723.058838]  ? sched_clock_cpu+0x18/0x110
[ 1723.059629]  ? lockdep_hardirqs_on+0x17d/0x250
[ 1723.060456]  kthread+0x1ab/0x200
[ 1723.061149]  ? cifs_handle_standard+0x2c0/0x2c0 [cifs]
[ 1723.062078]  ? kthread_create_on_node+0xd0/0xd0
[ 1723.062897]  ret_from_fork+0x3a/0x50

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Fixes: 9150c3adbf24 ("CIFS: Close open handle after interrupted close")
Cc: Stable <stable@vger.kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smb2misc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -750,7 +750,7 @@ __smb2_handle_cancelled_close(struct cif
 {
 	struct close_cancelled_open *cancelled;
 
-	cancelled = kzalloc(sizeof(*cancelled), GFP_KERNEL);
+	cancelled = kzalloc(sizeof(*cancelled), GFP_ATOMIC);
 	if (!cancelled)
 		return -ENOMEM;
 


