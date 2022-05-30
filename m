Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 366CE5381EA
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241124AbiE3OVX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241030AbiE3ORH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:17:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD0211047B;
        Mon, 30 May 2022 06:44:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A3EDB80AE8;
        Mon, 30 May 2022 13:44:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 243F9C385B8;
        Mon, 30 May 2022 13:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918251;
        bh=BUrobp50XpHRgeWbcvPtI16jIKSjBaUWOdFH+Q30HRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o45chMRPTBn7fHvzTld7kvjGZdJXbpVwvFzDolMoTOAySIcZNd4mz0Hp0JeCjBjlq
         YH8DyN6cMhNjtER9etr3OBxgZOvIM4AvRP7viE9XV0aFc887DnpWflIIg/CnAptiRn
         9lDp3+O0YZX9mmeScKGL/qdUIYXS4zyunQ8cWDX9hcymGNUGmhD0z/+kw/uQicP7f+
         ymV2Nfhei496d0BR3lidYX7BtbJw2VC/Oi5WWoRhxuW8qSirXxac7cTef+ob6ExTzk
         ncncdBYZtRa+KKLuKe7dIUhrkHwH8eNFxYXLEwwJmoYeIkfhP6ykH/1pDYEvrI6o8Y
         9HyMQj/29GCsA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liu Zixian <liuzixian4@huawei.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>, airlied@linux.ie,
        daniel@ffwll.ch, dri-devel@lists.freedesktop.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.10 02/76] drm/virtio: fix NULL pointer dereference in virtio_gpu_conn_get_modes
Date:   Mon, 30 May 2022 09:42:52 -0400
Message-Id: <20220530134406.1934928-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530134406.1934928-1-sashal@kernel.org>
References: <20220530134406.1934928-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index f84b7e61311b..9b2b99e85342 100644
--- a/drivers/gpu/drm/virtio/virtgpu_display.c
+++ b/drivers/gpu/drm/virtio/virtgpu_display.c
@@ -177,6 +177,8 @@ static int virtio_gpu_conn_get_modes(struct drm_connector *connector)
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

