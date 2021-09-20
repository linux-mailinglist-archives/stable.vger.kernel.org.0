Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA8A4411C70
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241982AbhITRJ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:09:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:58540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346448AbhITRHV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:07:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A04F26152A;
        Mon, 20 Sep 2021 16:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156933;
        bh=b2Yz9hJ8Ltk+iFz0e7Y4nCi4Jo/QPiQLfxKUoibpUo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ihj0xdPSgzr6j1YEeQjI2ZlFaNraEPZyo7NWgAlYbYKoftFQNtejnWMCibE/UhFUB
         9I8bcfAtdIQMYttcqH9NMfgLJTur7O24cYzevluJW1XPUIPbx+7vav20/DkvdENcuQ
         fl/JhWyp0uz/rT52mTY9o/UPLf9i8sTB1Hsa7Azo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 4.9 153/175] xen: reset legacy rtc flag for PV domU
Date:   Mon, 20 Sep 2021 18:43:22 +0200
Message-Id: <20210920163923.076285003@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit f68aa100d815b5b4467fd1c3abbe3b99d65fd028 upstream.

A Xen PV guest doesn't have a legacy RTC device, so reset the legacy
RTC flag. Otherwise the following WARN splat will occur at boot:

[    1.333404] WARNING: CPU: 1 PID: 1 at /home/gross/linux/head/drivers/rtc/rtc-mc146818-lib.c:25 mc146818_get_time+0x1be/0x210
[    1.333404] Modules linked in:
[    1.333404] CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W         5.14.0-rc7-default+ #282
[    1.333404] RIP: e030:mc146818_get_time+0x1be/0x210
[    1.333404] Code: c0 64 01 c5 83 fd 45 89 6b 14 7f 06 83 c5 64 89 6b 14 41 83 ec 01 b8 02 00 00 00 44 89 63 10 5b 5d 41 5c 41 5d 41 5e 41 5f c3 <0f> 0b 48 c7 c7 30 0e ef 82 4c 89 e6 e8 71 2a 24 00 48 c7 c0 ff ff
[    1.333404] RSP: e02b:ffffc90040093df8 EFLAGS: 00010002
[    1.333404] RAX: 00000000000000ff RBX: ffffc90040093e34 RCX: 0000000000000000
[    1.333404] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 000000000000000d
[    1.333404] RBP: ffffffff82ef0e30 R08: ffff888005013e60 R09: 0000000000000000
[    1.333404] R10: ffffffff82373e9b R11: 0000000000033080 R12: 0000000000000200
[    1.333404] R13: 0000000000000000 R14: 0000000000000002 R15: ffffffff82cdc6d4
[    1.333404] FS:  0000000000000000(0000) GS:ffff88807d440000(0000) knlGS:0000000000000000
[    1.333404] CS:  10000e030 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.333404] CR2: 0000000000000000 CR3: 000000000260a000 CR4: 0000000000050660
[    1.333404] Call Trace:
[    1.333404]  ? wakeup_sources_sysfs_init+0x30/0x30
[    1.333404]  ? rdinit_setup+0x2b/0x2b
[    1.333404]  early_resume_init+0x23/0xa4
[    1.333404]  ? cn_proc_init+0x36/0x36
[    1.333404]  do_one_initcall+0x3e/0x200
[    1.333404]  kernel_init_freeable+0x232/0x28e
[    1.333404]  ? rest_init+0xd0/0xd0
[    1.333404]  kernel_init+0x16/0x120
[    1.333404]  ret_from_fork+0x1f/0x30

Cc: <stable@vger.kernel.org>
Fixes: 8d152e7a5c7537 ("x86/rtc: Replace paravirt rtc check with platform legacy quirk")
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Link: https://lore.kernel.org/r/20210903084937.19392-3-jgross@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/xen/enlighten.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1576,6 +1576,11 @@ static int xen_cpuhp_setup(void)
 	return rc >= 0 ? 0 : rc;
 }
 
+static void __init xen_domu_set_legacy_features(void)
+{
+	x86_platform.legacy.rtc = 0;
+}
+
 /* First C function to be called on Xen boot */
 asmlinkage __visible void __init xen_start_kernel(void)
 {
@@ -1741,6 +1746,8 @@ asmlinkage __visible void __init xen_sta
 		add_preferred_console("hvc", 0, NULL);
 		if (pci_xen)
 			x86_init.pci.arch_init = pci_xen_init;
+		x86_platform.set_legacy_features =
+				xen_domu_set_legacy_features;
 	} else {
 		const struct dom0_vga_console_info *info =
 			(void *)((char *)xen_start_info +


