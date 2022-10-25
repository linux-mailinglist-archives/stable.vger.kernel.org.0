Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 373E060CA92
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 13:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbiJYLFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 07:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232110AbiJYLFF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 07:05:05 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 860F46291D;
        Tue, 25 Oct 2022 04:04:58 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 24F8521FD2;
        Tue, 25 Oct 2022 11:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1666695897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=v7Dhmrb/2E/3dQl24qwseDpSKGsgigxikBde7959V1k=;
        b=GupbIv/m5U9mY653h+ViudEDBXbGAOwHUpH4zaABVUbmQeWdMcBYwwobbF2Y+m1+h641sC
        zGEQ1cEQSmOCIi/viFq8j4IoKSuL4vMpSsJN58JYblVt5XSX5RpGDl6e3jbZGqsq0yBykf
        1WYMd4NnC1kRnuu9TWnzQrgzZw1NbBU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1666695897;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=v7Dhmrb/2E/3dQl24qwseDpSKGsgigxikBde7959V1k=;
        b=ze6TAe8VEtfIx9DiCX4ac6rqWFO3UXGR8RQCDCiybY4sXYtxqCbSeggtlkrVI2zqqyBBHA
        9IaLa/2/sdVeDaAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A073D134CA;
        Tue, 25 Oct 2022 11:04:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ROhQJtjCV2MkbQAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Tue, 25 Oct 2022 11:04:56 +0000
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     javierm@redhat.com, deller@gmx.de, sashal@kernel.org,
        gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>,
        Andreas Thalhammer <andreas.thalhammer-linux@gmx.net>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Zack Rusin <zackr@vmware.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Daniel Vetter <daniel@ffwll.ch>,
        Sam Ravnborg <sam@ravnborg.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Changcheng Deng <deng.changcheng@zte.com.cn>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org
Subject: [PATCH] video/aperture: Call sysfb_disable() before removing PCI devices
Date:   Tue, 25 Oct 2022 13:04:53 +0200
Message-Id: <20221025110453.9404-1-tzimmermann@suse.de>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Call sysfb_disable() from aperture_remove_conflicting_pci_devices()
before removing PCI devices. Without, simpledrm can still bind to
simple-framebuffer devices after the hardware driver has taken over
the hardware. Both drivers interfere with each other and results are
undefined.

Reported modesetting errors are shown below.

---- snap ----
rcu: INFO: rcu_sched detected expedited stalls on CPUs/tasks: { 13-.... } 7 jiffies s: 165 root: 0x2000/.
rcu: blocking rcu_node structures (internal RCU debug):
Task dump for CPU 13:
task:X               state:R  running task     stack:    0 pid: 4242 ppid:  4228 flags:0x00000008
Call Trace:
 <TASK>
 ? commit_tail+0xd7/0x130
 ? drm_atomic_helper_commit+0x126/0x150
 ? drm_atomic_commit+0xa4/0xe0
 ? drm_plane_get_damage_clips.cold+0x1c/0x1c
 ? drm_atomic_helper_dirtyfb+0x19e/0x280
 ? drm_mode_dirtyfb_ioctl+0x10f/0x1e0
 ? drm_mode_getfb2_ioctl+0x2d0/0x2d0
 ? drm_ioctl_kernel+0xc4/0x150
 ? drm_ioctl+0x246/0x3f0
 ? drm_mode_getfb2_ioctl+0x2d0/0x2d0
 ? __x64_sys_ioctl+0x91/0xd0
 ? do_syscall_64+0x60/0xd0
 ? entry_SYSCALL_64_after_hwframe+0x4b/0xb5
 </TASK>
...
rcu: INFO: rcu_sched detected expedited stalls on CPUs/tasks: { 13-.... } 30 jiffies s: 169 root: 0x2000/.
rcu: blocking rcu_node structures (internal RCU debug):
Task dump for CPU 13:
task:X               state:R  running task     stack:    0 pid: 4242 ppid:  4228 flags:0x0000400e
Call Trace:
 <TASK>
 ? memcpy_toio+0x76/0xc0
 ? memcpy_toio+0x1b/0xc0
 ? drm_fb_memcpy_toio+0x76/0xb0
 ? drm_fb_blit_toio+0x75/0x2b0
 ? simpledrm_simple_display_pipe_update+0x132/0x150
 ? drm_atomic_helper_commit_planes+0xb6/0x230
 ? drm_atomic_helper_commit_tail+0x44/0x80
 ? commit_tail+0xd7/0x130
 ? drm_atomic_helper_commit+0x126/0x150
 ? drm_atomic_commit+0xa4/0xe0
 ? drm_plane_get_damage_clips.cold+0x1c/0x1c
 ? drm_atomic_helper_dirtyfb+0x19e/0x280
 ? drm_mode_dirtyfb_ioctl+0x10f/0x1e0
 ? drm_mode_getfb2_ioctl+0x2d0/0x2d0
 ? drm_ioctl_kernel+0xc4/0x150
 ? drm_ioctl+0x246/0x3f0
 ? drm_mode_getfb2_ioctl+0x2d0/0x2d0
 ? __x64_sys_ioctl+0x91/0xd0
 ? do_syscall_64+0x60/0xd0
 ? entry_SYSCALL_64_after_hwframe+0x4b/0xb5
 </TASK>

The problem was added by commit 5e0137612430 ("video/aperture: Disable
and unregister sysfb devices via aperture helpers") to v6.0.3 and does
not exist in the mainline branch.

Reported-by: Andreas Thalhammer <andreas.thalhammer-linux@gmx.net>
Reported-by: Thorsten Leemhuis <regressions@leemhuis.info>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Tested-by: Andreas Thalhammer <andreas.thalhammer-linux@gmx.net>
Fixes: cfecfc98a78d ("video/aperture: Disable and unregister sysfb devices via aperture helpers")
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: Zack Rusin <zackr@vmware.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
Cc: Changcheng Deng <deng.changcheng@zte.com.cn>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: dri-devel@lists.freedesktop.org
Cc: Sasha Levin <sashal@kernel.org>
Cc: linux-fbdev@vger.kernel.org
Cc: <stable@vger.kernel.org> # v6.0.3+
Link: https://lore.kernel.org/dri-devel/d6afe54b-f8d7-beb2-3609-186e566cbfac@gmx.net/T/#t
---
 drivers/video/aperture.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/video/aperture.c b/drivers/video/aperture.c
index d245826a9324d..cc6427a091bc7 100644
--- a/drivers/video/aperture.c
+++ b/drivers/video/aperture.c
@@ -338,6 +338,17 @@ int aperture_remove_conflicting_pci_devices(struct pci_dev *pdev, const char *na
 	resource_size_t base, size;
 	int bar, ret;
 
+	/*
+	 * If a driver asked to unregister a platform device registered by
+	 * sysfb, then can be assumed that this is a driver for a display
+	 * that is set up by the system firmware and has a generic driver.
+	 *
+	 * Drivers for devices that don't have a generic driver will never
+	 * ask for this, so let's assume that a real driver for the display
+	 * was already probed and prevent sysfb to register devices later.
+	 */
+	sysfb_disable();
+
 	/*
 	 * WARNING: Apparently we must kick fbdev drivers before vgacon,
 	 * otherwise the vga fbdev driver falls over.
-- 
2.38.0

