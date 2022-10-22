Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA5360876D
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232389AbiJVIBS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232836AbiJVIAD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:00:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC2A132EA8;
        Sat, 22 Oct 2022 00:50:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6034460AFD;
        Sat, 22 Oct 2022 07:47:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796A2C433C1;
        Sat, 22 Oct 2022 07:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424865;
        bh=jycY7O9BpnycH4RJKvzEcVNXUyY74AUmcG++4cJQdgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pXntIxjvbdioxMs6WOhT8s35+Fu3fAVSWJJ0ur7kKP1ERqw1yNXh4JGKAwK2X3cvj
         BuV8x1/vLT2ofceHzMFDmXtsKhOlYREqxakClinbgHwDEFF+pi5DbDnc70RZPVtcQj
         7oTUoWn/pOndSJ5YpYsXDE/Vqkjd0WkX4aBp/bW4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Javier Martinez Canillas <javierm@redhat.com>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 306/717] drm/msm: Make .remove and .shutdown HW shutdown consistent
Date:   Sat, 22 Oct 2022 09:23:05 +0200
Message-Id: <20221022072506.812743481@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Javier Martinez Canillas <javierm@redhat.com>

[ Upstream commit 0a58d2ae572adaec8d046f8d35b40c2c32ac7468 ]

Drivers' .remove and .shutdown callbacks are executed on different code
paths. The former is called when a device is removed from the bus, while
the latter is called at system shutdown time to quiesce the device.

This means that some overlap exists between the two, because both have to
take care of properly shutting down the hardware. But currently the logic
used in these two callbacks isn't consistent in msm drivers, which could
lead to kernel panic.

For example, on .remove the component is deleted and its .unbind callback
leads to the hardware being shutdown but only if the DRM device has been
marked as registered.

That check doesn't exist in the .shutdown logic and this can lead to the
driver calling drm_atomic_helper_shutdown() for a DRM device that hasn't
been properly initialized.

A situation like this can happen if drivers for expected sub-devices fail
to probe, since the .bind callback will never be executed. If that is the
case, drm_atomic_helper_shutdown() will attempt to take mutexes that are
only initialized if drm_mode_config_init() is called during a device bind.

This bug was attempted to be fixed in commit 623f279c7781 ("drm/msm: fix
shutdown hook in case GPU components failed to bind"), but unfortunately
it still happens in some cases as the one mentioned above, i.e:

  systemd-shutdown[1]: Powering off.
  kvm: exiting hardware virtualization
  platform wifi-firmware.0: Removing from iommu group 12
  platform video-firmware.0: Removing from iommu group 10
  ------------[ cut here ]------------
  WARNING: CPU: 6 PID: 1 at drivers/gpu/drm/drm_modeset_lock.c:317 drm_modeset_lock_all_ctx+0x3c4/0x3d0
  ...
  Hardware name: Google CoachZ (rev3+) (DT)
  pstate: a0400009 (NzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
  pc : drm_modeset_lock_all_ctx+0x3c4/0x3d0
  lr : drm_modeset_lock_all_ctx+0x48/0x3d0
  sp : ffff80000805bb80
  x29: ffff80000805bb80 x28: ffff327c00128000 x27: 0000000000000000
  x26: 0000000000000000 x25: 0000000000000001 x24: ffffc95d820ec030
  x23: ffff327c00bbd090 x22: ffffc95d8215eca0 x21: ffff327c039c5800
  x20: ffff327c039c5988 x19: ffff80000805bbe8 x18: 0000000000000034
  x17: 000000040044ffff x16: ffffc95d80cac920 x15: 0000000000000000
  x14: 0000000000000315 x13: 0000000000000315 x12: 0000000000000000
  x11: 0000000000000000 x10: 0000000000000000 x9 : 0000000000000000
  x8 : ffff80000805bc28 x7 : 0000000000000000 x6 : 0000000000000000
  x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000000
  x2 : ffff327c00128000 x1 : 0000000000000000 x0 : ffff327c039c59b0
  Call trace:
   drm_modeset_lock_all_ctx+0x3c4/0x3d0
   drm_atomic_helper_shutdown+0x70/0x134
   msm_drv_shutdown+0x30/0x40
   platform_shutdown+0x28/0x40
   device_shutdown+0x148/0x350
   kernel_power_off+0x38/0x80
   __do_sys_reboot+0x288/0x2c0
   __arm64_sys_reboot+0x28/0x34
   invoke_syscall+0x48/0x114
   el0_svc_common.constprop.0+0x44/0xec
   do_el0_svc+0x2c/0xc0
   el0_svc+0x2c/0x84
   el0t_64_sync_handler+0x11c/0x150
   el0t_64_sync+0x18c/0x190
  ---[ end trace 0000000000000000 ]---
  Unable to handle kernel NULL pointer dereference at virtual address 0000000000000018
  Mem abort info:
    ESR = 0x0000000096000004
    EC = 0x25: DABT (current EL), IL = 32 bits
    SET = 0, FnV = 0
    EA = 0, S1PTW = 0
    FSC = 0x04: level 0 translation fault
  Data abort info:
    ISV = 0, ISS = 0x00000004
    CM = 0, WnR = 0
  user pgtable: 4k pages, 48-bit VAs, pgdp=000000010eab1000
  [0000000000000018] pgd=0000000000000000, p4d=0000000000000000
  Internal error: Oops: 96000004 [#1] PREEMPT SMP
  ...
  Hardware name: Google CoachZ (rev3+) (DT)
  pstate: a0400009 (NzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
  pc : ww_mutex_lock+0x28/0x32c
  lr : drm_modeset_lock_all_ctx+0x1b0/0x3d0
  sp : ffff80000805bb50
  x29: ffff80000805bb50 x28: ffff327c00128000 x27: 0000000000000000
  x26: 0000000000000000 x25: 0000000000000001 x24: 0000000000000018
  x23: ffff80000805bc10 x22: ffff327c039c5ad8 x21: ffff327c039c5800
  x20: ffff80000805bbe8 x19: 0000000000000018 x18: 0000000000000034
  x17: 000000040044ffff x16: ffffc95d80cac920 x15: 0000000000000000
  x14: 0000000000000315 x13: 0000000000000315 x12: 0000000000000000
  x11: 0000000000000000 x10: 0000000000000000 x9 : 0000000000000000
  x8 : ffff80000805bc28 x7 : 0000000000000000 x6 : 0000000000000000
  x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000000
  x2 : ffff327c00128000 x1 : 0000000000000000 x0 : 0000000000000018
  Call trace:
   ww_mutex_lock+0x28/0x32c
   drm_modeset_lock_all_ctx+0x1b0/0x3d0
   drm_atomic_helper_shutdown+0x70/0x134
   msm_drv_shutdown+0x30/0x40
   platform_shutdown+0x28/0x40
   device_shutdown+0x148/0x350
   kernel_power_off+0x38/0x80
   __do_sys_reboot+0x288/0x2c0
   __arm64_sys_reboot+0x28/0x34
   invoke_syscall+0x48/0x114
   el0_svc_common.constprop.0+0x44/0xec
   do_el0_svc+0x2c/0xc0
   el0_svc+0x2c/0x84
   el0t_64_sync_handler+0x11c/0x150
   el0t_64_sync+0x18c/0x190
  Code: aa0103f4 d503201f d2800001 aa0103e3 (c8e37c02)
  ---[ end trace 0000000000000000 ]---
  Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
  Kernel Offset: 0x495d77c00000 from 0xffff800008000000
  PHYS_OFFSET: 0xffffcd8500000000
  CPU features: 0x800,00c2a015,19801c82
  Memory Limit: none
  ---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b ]---

Fixes: 9d5cbf5fe46e ("drm/msm: add shutdown support for display platform_driver")
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220816134612.916527-1-javierm@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_drv.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
index 7c0314d6566a..c5f931b2574c 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -1169,10 +1169,15 @@ void msm_drv_shutdown(struct platform_device *pdev)
 	struct msm_drm_private *priv = platform_get_drvdata(pdev);
 	struct drm_device *drm = priv ? priv->dev : NULL;
 
-	if (!priv || !priv->kms)
-		return;
-
-	drm_atomic_helper_shutdown(drm);
+	/*
+	 * Shutdown the hw if we're far enough along where things might be on.
+	 * If we run this too early, we'll end up panicking in any variety of
+	 * places. Since we don't register the drm device until late in
+	 * msm_drm_init, drm_dev->registered is used as an indicator that the
+	 * shutdown will be successful.
+	 */
+	if (drm && drm->registered)
+		drm_atomic_helper_shutdown(drm);
 }
 
 static struct platform_driver msm_platform_driver = {
-- 
2.35.1



