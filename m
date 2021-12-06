Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00DD8469B39
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348949AbhLFPNu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:13:50 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43996 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348558AbhLFPLt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:11:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5372BB8111D;
        Mon,  6 Dec 2021 15:08:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73022C341C5;
        Mon,  6 Dec 2021 15:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803295;
        bh=4GGXR8wK70ZravjoS71SnY+VtXZZ4oVVlOBySCYEqao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tmvW9KZ5iL2fH2ngcvIrQX2JcQDw4NAh+oHQ6riacNf7kE5YYMgMpnyXLO0H29TUB
         MJhcVm9AUZUWPAv+FKE9VRwoydPLeFveixqMAmQ3HRKi9iKmPbFiqWGxI43WxNQdY9
         cNWW0sm7Zby69B+8BtSQKhJufxA8HumAhDNKY53Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 4.14 097/106] parisc: Fix KBUILD_IMAGE for self-extracting kernel
Date:   Mon,  6 Dec 2021 15:56:45 +0100
Message-Id: <20211206145558.899150085@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145555.386095297@linuxfoundation.org>
References: <20211206145555.386095297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit 1d7c29b77725d05faff6754d2f5e7c147aedcf93 upstream.

Default KBUILD_IMAGE to $(boot)/bzImage if a self-extracting
(CONFIG_PARISC_SELF_EXTRACT=y) kernel is to be built.
This fixes the bindeb-pkg make target.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org> # v4.14+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/Makefile |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/parisc/Makefile
+++ b/arch/parisc/Makefile
@@ -17,7 +17,12 @@
 # Mike Shaver, Helge Deller and Martin K. Petersen
 #
 
+ifdef CONFIG_PARISC_SELF_EXTRACT
+boot := arch/parisc/boot
+KBUILD_IMAGE := $(boot)/bzImage
+else
 KBUILD_IMAGE := vmlinuz
+endif
 
 KBUILD_DEFCONFIG := default_defconfig
 


