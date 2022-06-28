Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3999C55DE6B
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243633AbiF1CVy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243630AbiF1CVD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:21:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 755272494A;
        Mon, 27 Jun 2022 19:20:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33916B81C00;
        Tue, 28 Jun 2022 02:20:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C254C341CB;
        Tue, 28 Jun 2022 02:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382843;
        bh=wbO/Xa2eXLxW28phcXHoMQTFFXAWO8MmaRfdv3KfyN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=id7FlDi0hYrosjq5Iv04cJLmY1vTl5YuSGFaFiTpoohKtsi6UtMoprXKD8G9q80y1
         1X2RHImAW408zP4T87sCJY6Ox+9s+zix/wNDMvB05udYMqqJKDXDg+G0eDbFhOK1kM
         wmCW6vCCpUy16NF2fqcWxPQRxxYtiFmHPQ8NZpxpQmnbQs9rAaE2HGzGTOW+zQ7xDW
         4AmzIsoIIXd2HFVB83MJMRkDaDDGNJEqwwKfrW6jPg5QjRU9ofeqf6I0VNKY4HNOZ7
         fN5gBUPHOLmOie3wxVGe7gnvhqbRaxfL/KG9BJ7o1m72I0yBvH8VuF4EFYuArReoCA
         OYq/pZZp8M15g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>, mripard@kernel.org,
        wens@csie.org, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev
Subject: [PATCH AUTOSEL 5.18 47/53] drm/sun4i: Add DMA mask and segment size
Date:   Mon, 27 Jun 2022 22:18:33 -0400
Message-Id: <20220628021839.594423-47-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628021839.594423-1-sashal@kernel.org>
References: <20220628021839.594423-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jernej Skrabec <jernej.skrabec@gmail.com>

[ Upstream commit f5aa16807aa4f99293044944590dde81364f434f ]

Kernel occasionally complains that there is mismatch in segment size
when trying to render HW decoded videos and rendering them directly with
sun4i DRM driver. Following message can be observed on H6 SoC:

[  184.298308] ------------[ cut here ]------------
[  184.298326] DMA-API: sun4i-drm display-engine: mapping sg segment longer than device claims to support [len=6144000] [max=65536]
[  184.298364] WARNING: CPU: 1 PID: 382 at kernel/dma/debug.c:1162 debug_dma_map_sg+0x2b0/0x350
[  184.322997] CPU: 1 PID: 382 Comm: ffmpeg Not tainted 5.19.0-rc1+ #1331
[  184.329533] Hardware name: Tanix TX6 (DT)
[  184.333544] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[  184.340512] pc : debug_dma_map_sg+0x2b0/0x350
[  184.344882] lr : debug_dma_map_sg+0x2b0/0x350
[  184.349250] sp : ffff800009f33a50
[  184.352567] x29: ffff800009f33a50 x28: 0000000000010000 x27: ffff000001b86c00
[  184.359725] x26: ffffffffffffffff x25: ffff000005d8cc80 x24: 0000000000000000
[  184.366879] x23: ffff80000939ab18 x22: 0000000000000001 x21: 0000000000000001
[  184.374031] x20: 0000000000000000 x19: ffff0000018a7410 x18: ffffffffffffffff
[  184.381186] x17: 0000000000000000 x16: 0000000000000000 x15: ffffffffffffffff
[  184.388338] x14: 0000000000000001 x13: ffff800009534e86 x12: 6f70707573206f74
[  184.395493] x11: 20736d69616c6320 x10: 000000000000000a x9 : 0000000000010000
[  184.402647] x8 : ffff8000093b6d40 x7 : ffff800009f33850 x6 : 000000000000000c
[  184.409800] x5 : ffff0000bf997940 x4 : 0000000000000000 x3 : 0000000000000027
[  184.416953] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff000003960e80
[  184.424106] Call trace:
[  184.426556]  debug_dma_map_sg+0x2b0/0x350
[  184.430580]  __dma_map_sg_attrs+0xa0/0x110
[  184.434687]  dma_map_sgtable+0x28/0x4c
[  184.438447]  vb2_dc_dmabuf_ops_map+0x60/0xcc
[  184.442729]  __map_dma_buf+0x2c/0xd4
[  184.446321]  dma_buf_map_attachment+0xa0/0x130
[  184.450777]  drm_gem_prime_import_dev+0x7c/0x18c
[  184.455410]  drm_gem_prime_fd_to_handle+0x1b8/0x214
[  184.460300]  drm_prime_fd_to_handle_ioctl+0x2c/0x40
[  184.465190]  drm_ioctl_kernel+0xc4/0x174
[  184.469123]  drm_ioctl+0x204/0x420
[  184.472534]  __arm64_sys_ioctl+0xac/0xf0
[  184.476474]  invoke_syscall+0x48/0x114
[  184.480240]  el0_svc_common.constprop.0+0x44/0xec
[  184.484956]  do_el0_svc+0x2c/0xc0
[  184.488283]  el0_svc+0x2c/0x84
[  184.491354]  el0t_64_sync_handler+0x11c/0x150
[  184.495723]  el0t_64_sync+0x18c/0x190
[  184.499397] ---[ end trace 0000000000000000 ]---

Fix that by setting DMA mask and segment size.

Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Reviewed-by: Samuel Holland <samuel@sholland.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20220620181333.650301-1-jernej.skrabec@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun4i_drv.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/sun4i/sun4i_drv.c b/drivers/gpu/drm/sun4i/sun4i_drv.c
index 6a9ba8a77c77..7ee1e53eb919 100644
--- a/drivers/gpu/drm/sun4i/sun4i_drv.c
+++ b/drivers/gpu/drm/sun4i/sun4i_drv.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/component.h>
+#include <linux/dma-mapping.h>
 #include <linux/kfifo.h>
 #include <linux/module.h>
 #include <linux/of_graph.h>
@@ -367,6 +368,13 @@ static int sun4i_drv_probe(struct platform_device *pdev)
 
 	INIT_KFIFO(list.fifo);
 
+	/*
+	 * DE2 and DE3 cores actually supports 40-bit addresses, but
+	 * driver does not.
+	 */
+	dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
+	dma_set_max_seg_size(&pdev->dev, UINT_MAX);
+
 	for (i = 0;; i++) {
 		struct device_node *pipeline = of_parse_phandle(np,
 								"allwinner,pipelines",
-- 
2.35.1

