Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF60E5408A7
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349371AbiFGSC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350262AbiFGSAv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:00:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 577621929B;
        Tue,  7 Jun 2022 10:42:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 155C46159B;
        Tue,  7 Jun 2022 17:42:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13480C385A5;
        Tue,  7 Jun 2022 17:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623772;
        bh=RJbgNwALSTmalG7CgWu4bWgSiJ9N0y2sew5DPuI6QgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MHki6AhzOL50ft82i9+ZJmkXF22g6Eg/3LpQ/ywlPg2oh4lZ09pp+HO5m7QXnRd36
         Te2YZCq/GSNE+ZW0cc2htfRxUfHYyaslnn4xEyyjdLgGFUNM7bg9eDEZOlR4vSKMif
         MpSF88B0AJ6qZvVOKFwpJaqKX9YcbyUuWPu7WOSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Zixian <liuzixian4@huawei.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 045/667] drm/virtio: fix NULL pointer dereference in virtio_gpu_conn_get_modes
Date:   Tue,  7 Jun 2022 18:55:10 +0200
Message-Id: <20220607164936.155017028@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Zixian <liuzixian4@huawei.com>

[ Upstream commit 194d250cdc4a40ccbd179afd522a9e9846957402 ]

drm_cvt_mode may return NULL and we should check it.

This bug is found by syzkaller:

FAULT_INJECTION stacktrace:
[  168.567394] FAULT_INJECTION: forcing a failure.
name failslab, interval 1, probability 0, space 0, times 1
[  168.567403] CPU: 1 PID: 6425 Comm: syz Kdump: loaded Not tainted 4.19.90-vhulk2201.1.0.h1035.kasan.eulerosv2r10.aarch64 #1
[  168.567406] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
[  168.567408] Call trace:
[  168.567414]  dump_backtrace+0x0/0x310
[  168.567418]  show_stack+0x28/0x38
[  168.567423]  dump_stack+0xec/0x15c
[  168.567427]  should_fail+0x3ac/0x3d0
[  168.567437]  __should_failslab+0xb8/0x120
[  168.567441]  should_failslab+0x28/0xc0
[  168.567445]  kmem_cache_alloc_trace+0x50/0x640
[  168.567454]  drm_mode_create+0x40/0x90
[  168.567458]  drm_cvt_mode+0x48/0xc78
[  168.567477]  virtio_gpu_conn_get_modes+0xa8/0x140 [virtio_gpu]
[  168.567485]  drm_helper_probe_single_connector_modes+0x3a4/0xd80
[  168.567492]  drm_mode_getconnector+0x2e0/0xa70
[  168.567496]  drm_ioctl_kernel+0x11c/0x1d8
[  168.567514]  drm_ioctl+0x558/0x6d0
[  168.567522]  do_vfs_ioctl+0x160/0xf30
[  168.567525]  ksys_ioctl+0x98/0xd8
[  168.567530]  __arm64_sys_ioctl+0x50/0xc8
[  168.567536]  el0_svc_common+0xc8/0x320
[  168.567540]  el0_svc_handler+0xf8/0x160
[  168.567544]  el0_svc+0x10/0x218

KASAN stacktrace:
[  168.567561] BUG: KASAN: null-ptr-deref in virtio_gpu_conn_get_modes+0xb4/0x140 [virtio_gpu]
[  168.567565] Read of size 4 at addr 0000000000000054 by task syz/6425
[  168.567566]
[  168.567571] CPU: 1 PID: 6425 Comm: syz Kdump: loaded Not tainted 4.19.90-vhulk2201.1.0.h1035.kasan.eulerosv2r10.aarch64 #1
[  168.567573] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
[  168.567575] Call trace:
[  168.567578]  dump_backtrace+0x0/0x310
[  168.567582]  show_stack+0x28/0x38
[  168.567586]  dump_stack+0xec/0x15c
[  168.567591]  kasan_report+0x244/0x2f0
[  168.567594]  __asan_load4+0x58/0xb0
[  168.567607]  virtio_gpu_conn_get_modes+0xb4/0x140 [virtio_gpu]
[  168.567612]  drm_helper_probe_single_connector_modes+0x3a4/0xd80
[  168.567617]  drm_mode_getconnector+0x2e0/0xa70
[  168.567621]  drm_ioctl_kernel+0x11c/0x1d8
[  168.567624]  drm_ioctl+0x558/0x6d0
[  168.567628]  do_vfs_ioctl+0x160/0xf30
[  168.567632]  ksys_ioctl+0x98/0xd8
[  168.567636]  __arm64_sys_ioctl+0x50/0xc8
[  168.567641]  el0_svc_common+0xc8/0x320
[  168.567645]  el0_svc_handler+0xf8/0x160
[  168.567649]  el0_svc+0x10/0x218

Signed-off-by: Liu Zixian <liuzixian4@huawei.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20220322091730.1653-1-liuzixian4@huawei.com
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_display.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/virtio/virtgpu_display.c b/drivers/gpu/drm/virtio/virtgpu_display.c
index a6caebd4a0dd..ef1f19083cd3 100644
--- a/drivers/gpu/drm/virtio/virtgpu_display.c
+++ b/drivers/gpu/drm/virtio/virtgpu_display.c
@@ -179,6 +179,8 @@ static int virtio_gpu_conn_get_modes(struct drm_connector *connector)
 		DRM_DEBUG("add mode: %dx%d\n", width, height);
 		mode = drm_cvt_mode(connector->dev, width, height, 60,
 				    false, false, false);
+		if (!mode)
+			return count;
 		mode->type |= DRM_MODE_TYPE_PREFERRED;
 		drm_mode_probed_add(connector, mode);
 		count++;
-- 
2.35.1



