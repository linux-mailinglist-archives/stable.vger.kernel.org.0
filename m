Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73F4A594561
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346768AbiHOWMf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349541AbiHOWLb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:11:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D34011B4F3;
        Mon, 15 Aug 2022 12:38:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1CFD60FB9;
        Mon, 15 Aug 2022 19:38:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFA23C433C1;
        Mon, 15 Aug 2022 19:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592322;
        bh=lVE6si0vEtraGgGv0n6yqWBROaRF84v5MFZZ0BLmqaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QBBvZXY18a7RN8p3AdGYto241JUo21aZ89m6SwCH+P1blzWte/Kp1zU/dANYBEX4a
         Ww3mKDiD6xxgBxB7EsZur/R3j/TOUvFl9fPr2xj1vckqt2Cdya6a6TqycDlj7batWG
         TXNiY6t3sYZLaznaFK5DAP2w/bv+DzRjV4usc9Ko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.19 0093/1157] drm/tegra: Fix vmapping of prime buffers
Date:   Mon, 15 Aug 2022 19:50:49 +0200
Message-Id: <20220815180443.314575317@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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


