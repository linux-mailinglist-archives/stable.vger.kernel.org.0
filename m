Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7526B4291
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbjCJOEl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:04:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231640AbjCJOEW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:04:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A33136FA
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:04:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2229561771
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:04:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B71C433D2;
        Fri, 10 Mar 2023 14:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457051;
        bh=BeFhbC8F914UtRXtE/cB3q/D5yaQtaMipFrNhFw3DAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HsYTyl+hPeDo6GajPASwGCq8+e1C6+Bx4Jb/n7rMCBcNdz98/sFB0kotx8M8sM48q
         kaUaBIqdsU+aYTqbah+IhHHE9JsA5yQO5FWblZZdoZlhcrO/CLm5leFVh+Ilh9CzST
         c9jZVXbQD3REjIZjaxKWrhi8EHw2VvZbLkgBIFyc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andrzej Hajda <andrzej.hajda@intel.com>,
        iczero <iczero@hellomouse.net>,
        Jani Nikula <jani.nikula@intel.com>,
        Imre Deak <imre.deak@intel.com>
Subject: [PATCH 6.2 208/211] drm/i915: Fix system suspend without fbdev being initialized
Date:   Fri, 10 Mar 2023 14:39:48 +0100
Message-Id: <20230310133725.267932666@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Imre Deak <imre.deak@intel.com>

commit 8038510b1fe443ffbc0e356db5f47cbb8678a594 upstream.

If fbdev is not initialized for some reason - in practice on platforms
without display - suspending fbdev should be skipped during system
suspend, fix this up. While at it add an assert that suspending fbdev
only happens with the display present.

This fixes the following:

[   91.227923] PM: suspend entry (s2idle)
[   91.254598] Filesystems sync: 0.025 seconds
[   91.270518] Freezing user space processes
[   91.272266] Freezing user space processes completed (elapsed 0.001 seconds)
[   91.272686] OOM killer disabled.
[   91.272872] Freezing remaining freezable tasks
[   91.274295] Freezing remaining freezable tasks completed (elapsed 0.001 seconds)
[   91.659622] BUG: kernel NULL pointer dereference, address: 00000000000001c8
[   91.659981] #PF: supervisor write access in kernel mode
[   91.660252] #PF: error_code(0x0002) - not-present page
[   91.660511] PGD 0 P4D 0
[   91.660647] Oops: 0002 [#1] PREEMPT SMP NOPTI
[   91.660875] CPU: 4 PID: 917 Comm: bash Not tainted 6.2.0-rc7+ #54
[   91.661185] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS edk2-20221117gitfff6d81270b5-9.fc37 unknown
[   91.661680] RIP: 0010:mutex_lock+0x19/0x30
[   91.661914] Code: 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44 00 00 53 48 89 fb e8 62 d3 ff ff 31 c0 65 48 8b 14 25 00 15 03 00 <f0> 48 0f b1 13 75 06 5b c3 cc cc cc cc 48 89 df 5b eb b4 0f 1f 40
[   91.662840] RSP: 0018:ffffa1e8011ffc08 EFLAGS: 00010246
[   91.663087] RAX: 0000000000000000 RBX: 00000000000001c8 RCX: 0000000000000000
[   91.663440] RDX: ffff8be455eb0000 RSI: 0000000000000001 RDI: 00000000000001c8
[   91.663802] RBP: ffff8be459440000 R08: ffff8be459441f08 R09: ffffffff8e1432c0
[   91.664167] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
[   91.664532] R13: 00000000000001c8 R14: 0000000000000000 R15: ffff8be442f4fb20
[   91.664905] FS:  00007f28ffc16740(0000) GS:ffff8be4bb900000(0000) knlGS:0000000000000000
[   91.665334] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   91.665626] CR2: 00000000000001c8 CR3: 0000000114926006 CR4: 0000000000770ee0
[   91.665988] PKRU: 55555554
[   91.666131] Call Trace:
[   91.666265]  <TASK>
[   91.666381]  intel_fbdev_set_suspend+0x97/0x1b0 [i915]
[   91.666738]  i915_drm_suspend+0xb9/0x100 [i915]
[   91.667029]  pci_pm_suspend+0x78/0x170
[   91.667234]  ? __pfx_pci_pm_suspend+0x10/0x10
[   91.667461]  dpm_run_callback+0x47/0x150
[   91.667673]  __device_suspend+0x10a/0x4e0
[   91.667880]  dpm_suspend+0x134/0x270
[   91.668069]  dpm_suspend_start+0x79/0x80
[   91.668272]  suspend_devices_and_enter+0x11b/0x890
[   91.668526]  pm_suspend.cold+0x270/0x2fc
[   91.668737]  state_store+0x46/0x90
[   91.668916]  kernfs_fop_write_iter+0x11b/0x200
[   91.669153]  vfs_write+0x1e1/0x3a0
[   91.669336]  ksys_write+0x53/0xd0
[   91.669510]  do_syscall_64+0x58/0xc0
[   91.669699]  ? syscall_exit_to_user_mode_prepare+0x18e/0x1c0
[   91.669980]  ? syscall_exit_to_user_mode_prepare+0x18e/0x1c0
[   91.670278]  ? syscall_exit_to_user_mode+0x17/0x40
[   91.670524]  ? do_syscall_64+0x67/0xc0
[   91.670717]  ? __irq_exit_rcu+0x3d/0x140
[   91.670931]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
[   91.671202] RIP: 0033:0x7f28ffd14284

v2: CC stable. (Jani)

Fixes: f8cc091e0530 ("drm/i915/fbdev: suspend HPD before fbdev unregistration")
Reported-and-tested-by: iczero <iczero@hellomouse.net>
Cc: Andrzej Hajda <andrzej.hajda@intel.com>
Cc: iczero <iczero@hellomouse.net>
Cc: <stable@vger.kernel.org> # v6.1+
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230208114300.3123934-2-imre.deak@intel.com
(cherry picked from commit 9542d708409a41449e99c9a464deb5e062c4bee2)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_fbdev.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_fbdev.c
+++ b/drivers/gpu/drm/i915/display/intel_fbdev.c
@@ -638,7 +638,13 @@ void intel_fbdev_set_suspend(struct drm_
 	struct intel_fbdev *ifbdev = dev_priv->display.fbdev.fbdev;
 	struct fb_info *info;
 
-	if (!ifbdev || !ifbdev->vma)
+	if (!ifbdev)
+		return;
+
+	if (drm_WARN_ON(&dev_priv->drm, !HAS_DISPLAY(dev_priv)))
+		return;
+
+	if (!ifbdev->vma)
 		goto set_suspend;
 
 	info = ifbdev->helper.info;


