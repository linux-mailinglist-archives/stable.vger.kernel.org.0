Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73685591A67
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 14:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239430AbiHMMxO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 08:53:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239347AbiHMMxJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 08:53:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B7715706
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 05:53:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDD9760D32
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 12:53:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 089D9C433D6;
        Sat, 13 Aug 2022 12:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660395187;
        bh=M/i6fdMqVGPYKft2PfGBxDbYQcBIBIuNtnbLthCKxSc=;
        h=Subject:To:Cc:From:Date:From;
        b=wW3lPvMd0C8QL2Kn1w590fUchp3gX56a33WMa3VgyLl+qLuRX/86VTUwh1deHfxe8
         YMGaGW1CBfKWvaLr71F1wf6ci3m/YCgRiHSKld2bEgHyprF/sXlw3XTP2vlBhe29DE
         1m/seYG+1gOFohVSlvsGddEhHly0dECmvAO5XFog=
Subject: FAILED: patch "[PATCH] drm/tegra: Fix vmapping of prime buffers" failed to apply to 5.15-stable tree
To:     dmitry.osipenko@collabora.com, treding@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Aug 2022 14:53:05 +0200
Message-ID: <1660395185160231@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c7860cbee9989882d2908682526a5ef617523cfe Mon Sep 17 00:00:00 2001
From: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Date: Wed, 29 Jun 2022 01:42:39 +0300
Subject: [PATCH] drm/tegra: Fix vmapping of prime buffers

The code assumes that Tegra GEM is permanently vmapped, which is not
true for the scattered buffers. After converting Tegra video decoder
driver to V4L API, we're now getting a BUG_ON from dma-buf core on playing
video using libvdpau-tegra on T30+ because tegra_gem_prime_vmap() sets
vaddr to NULL. Older pre-V4L video decoder driver wasn't vmapping dma-bufs.
Fix it by actually vmapping the exported GEMs.

Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>

diff --git a/drivers/gpu/drm/tegra/gem.c b/drivers/gpu/drm/tegra/gem.c
index 7c7dd84e6db8..81991090adcc 100644
--- a/drivers/gpu/drm/tegra/gem.c
+++ b/drivers/gpu/drm/tegra/gem.c
@@ -704,14 +704,23 @@ static int tegra_gem_prime_vmap(struct dma_buf *buf, struct iosys_map *map)
 {
 	struct drm_gem_object *gem = buf->priv;
 	struct tegra_bo *bo = to_tegra_bo(gem);
+	void *vaddr;
 
-	iosys_map_set_vaddr(map, bo->vaddr);
+	vaddr = tegra_bo_mmap(&bo->base);
+	if (IS_ERR(vaddr))
+		return PTR_ERR(vaddr);
+
+	iosys_map_set_vaddr(map, vaddr);
 
 	return 0;
 }
 
 static void tegra_gem_prime_vunmap(struct dma_buf *buf, struct iosys_map *map)
 {
+	struct drm_gem_object *gem = buf->priv;
+	struct tegra_bo *bo = to_tegra_bo(gem);
+
+	tegra_bo_munmap(&bo->base, map->vaddr);
 }
 
 static const struct dma_buf_ops tegra_gem_prime_dmabuf_ops = {

