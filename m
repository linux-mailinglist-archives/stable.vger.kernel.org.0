Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B88B91CAAE6
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728261AbgEHMhv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:37:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:52450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728250AbgEHMhu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:37:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4249921473;
        Fri,  8 May 2020 12:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941469;
        bh=b/NVMex+r1wrdyyS3w2GxRLIg/DRVLYYypKPX6ZMnAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LFRmWwAsF8DaJpG3AmFrPQ/5YcsPuT0zvvT3gufp3zHqDm4mAKwZA+Cpp+KlINHVd
         eIHeT/aNzsAwu/G/CJaDPGU/a1hMMag93yCb2/BMeY4OOY2R5pZcVx8ckzu3kUwzVY
         Xy3dQGEfgMh7AaqoXlsRsQAyZfiGfOoMPlY/xzuY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suman Anna <s-anna@ti.com>,
        Paul Walmsley <paul@pwsan.com>
Subject: [PATCH 4.4 044/312] ARM: OMAP2+: hwmod: fix _idle() hwmod state sanity check sequence
Date:   Fri,  8 May 2020 14:30:35 +0200
Message-Id: <20200508123127.656289452@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suman Anna <s-anna@ti.com>

commit c20c8f750d9f8f8617f07ee2352d3ff560e66bc2 upstream.

The omap_hwmod _enable() function can return success without setting
the hwmod state to _HWMOD_STATE_ENABLED for IPs with reset lines when
all of the reset lines are asserted. The omap_hwmod _idle() function
also performs a similar check, but after checking for the hwmod state
first. This triggers the WARN when pm_runtime_get and pm_runtime_put
are invoked on IPs with all reset lines asserted. Reverse the checks
for hwmod state and reset lines status to fix this.

Issue found during a unbind operation on a device with reset lines
still asserted, example backtrace below

 ------------[ cut here ]------------
 WARNING: CPU: 1 PID: 879 at arch/arm/mach-omap2/omap_hwmod.c:2207 _idle+0x1e4/0x240()
 omap_hwmod: mmu_dsp: idle state can only be entered from enabled state
 Modules linked in:
 CPU: 1 PID: 879 Comm: sh Not tainted 4.4.0-00008-ga989d951331a #3
 Hardware name: Generic OMAP5 (Flattened Device Tree)
 [<c0018e60>] (unwind_backtrace) from [<c0014dc4>] (show_stack+0x10/0x14)
 [<c0014dc4>] (show_stack) from [<c037ac28>] (dump_stack+0x90/0xc0)
 [<c037ac28>] (dump_stack) from [<c003f420>] (warn_slowpath_common+0x78/0xb4)
 [<c003f420>] (warn_slowpath_common) from [<c003f48c>] (warn_slowpath_fmt+0x30/0x40)
 [<c003f48c>] (warn_slowpath_fmt) from [<c0028c20>] (_idle+0x1e4/0x240)
 [<c0028c20>] (_idle) from [<c0029080>] (omap_hwmod_idle+0x28/0x48)
 [<c0029080>] (omap_hwmod_idle) from [<c002a5a4>] (omap_device_idle+0x3c/0x90)
 [<c002a5a4>] (omap_device_idle) from [<c0427a90>] (__rpm_callback+0x2c/0x60)
 [<c0427a90>] (__rpm_callback) from [<c0427ae4>] (rpm_callback+0x20/0x80)
 [<c0427ae4>] (rpm_callback) from [<c0427f84>] (rpm_suspend+0x138/0x74c)
 [<c0427f84>] (rpm_suspend) from [<c0428b78>] (__pm_runtime_idle+0x78/0xa8)
 [<c0428b78>] (__pm_runtime_idle) from [<c041f514>] (__device_release_driver+0x64/0x100)
 [<c041f514>] (__device_release_driver) from [<c041f5d0>] (device_release_driver+0x20/0x2c)
 [<c041f5d0>] (device_release_driver) from [<c041d85c>] (unbind_store+0x78/0xf8)
 [<c041d85c>] (unbind_store) from [<c0206df8>] (kernfs_fop_write+0xc0/0x1c4)
 [<c0206df8>] (kernfs_fop_write) from [<c018a120>] (__vfs_write+0x20/0xdc)
 [<c018a120>] (__vfs_write) from [<c018a9cc>] (vfs_write+0x90/0x164)
 [<c018a9cc>] (vfs_write) from [<c018b1f0>] (SyS_write+0x44/0x9c)
 [<c018b1f0>] (SyS_write) from [<c0010420>] (ret_fast_syscall+0x0/0x1c)
 ---[ end trace a4182013c75a9f50 ]---

While at this, fix the sequence in _shutdown() as well, though there
is no easy reproducible scenario.

Fixes: 747834ab8347 ("ARM: OMAP2+: hwmod: revise hardreset behavior")
Signed-off-by: Suman Anna <s-anna@ti.com>
Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-omap2/omap_hwmod.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -2207,15 +2207,15 @@ static int _idle(struct omap_hwmod *oh)
 
 	pr_debug("omap_hwmod: %s: idling\n", oh->name);
 
+	if (_are_all_hardreset_lines_asserted(oh))
+		return 0;
+
 	if (oh->_state != _HWMOD_STATE_ENABLED) {
 		WARN(1, "omap_hwmod: %s: idle state can only be entered from enabled state\n",
 			oh->name);
 		return -EINVAL;
 	}
 
-	if (_are_all_hardreset_lines_asserted(oh))
-		return 0;
-
 	if (oh->class->sysc)
 		_idle_sysc(oh);
 	_del_initiator_dep(oh, mpu_oh);
@@ -2262,6 +2262,9 @@ static int _shutdown(struct omap_hwmod *
 	int ret, i;
 	u8 prev_state;
 
+	if (_are_all_hardreset_lines_asserted(oh))
+		return 0;
+
 	if (oh->_state != _HWMOD_STATE_IDLE &&
 	    oh->_state != _HWMOD_STATE_ENABLED) {
 		WARN(1, "omap_hwmod: %s: disabled state can only be entered from idle, or enabled state\n",
@@ -2269,9 +2272,6 @@ static int _shutdown(struct omap_hwmod *
 		return -EINVAL;
 	}
 
-	if (_are_all_hardreset_lines_asserted(oh))
-		return 0;
-
 	pr_debug("omap_hwmod: %s: disabling\n", oh->name);
 
 	if (oh->class->pre_shutdown) {


