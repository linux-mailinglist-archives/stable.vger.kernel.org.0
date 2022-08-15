Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D85C9593C2A
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346296AbiHOUN2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346804AbiHOUMU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:12:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F315C86889;
        Mon, 15 Aug 2022 11:58:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33950B81082;
        Mon, 15 Aug 2022 18:58:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80488C433D7;
        Mon, 15 Aug 2022 18:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589899;
        bh=lVE6si0vEtraGgGv0n6yqWBROaRF84v5MFZZ0BLmqaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yVPUzozC9ET22ebSsaF++vGN8bAGiVA0lkjwhpHshWeq5ZlK7UainGlNQEg8aKaLc
         1xBD/PVnIg6C2FIWXMWK7BGcuDqvIY+k+tfUpnGqahPBwF1oineuwk1ZRAf5MynjPw
         fRXXN7JnYOXEtwRHjbVwPwllklDsN4ZBYKkVyUlA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.18 0084/1095] drm/tegra: Fix vmapping of prime buffers
Date:   Mon, 15 Aug 2022 19:51:23 +0200
Message-Id: <20220815180433.003947828@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <dmitry.osipenko@collabora.com>

commit c7860cbee9989882d2908682526a5ef617523cfe upstream.

The code assumes that Tegra GEM is permanently vmapped, which is not
true for the scattered buffers. After converting Tegra video decoder
driver to V4L API, we're now getting a BUG_ON from dma-buf core on playing
video using libvdpau-tegra on T30+ because tegra_gem_prime_vmap() sets
vaddr to NULL. Older pre-V4L video decoder driver wasn't vmapping dma-bufs.
Fix it by actually vmapping the exported GEMs.

Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/tegra/gem.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/tegra/gem.c
+++ b/drivers/gpu/drm/tegra/gem.c
@@ -704,14 +704,23 @@ static int tegra_gem_prime_vmap(struct d
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


