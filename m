Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A29166B486A
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233811AbjCJPCS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:02:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233816AbjCJPB6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:01:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32F77125DAF
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:55:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A7BDB82315
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:54:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A18C4339C;
        Fri, 10 Mar 2023 14:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460083;
        bh=DOpQC7Qu2e9pXMu/pJYXETCu6KinuyOYhy8yznwvwTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wO+4hSl4CMWlajT2CQ0YIIkM+YC5ZOM76fQomwb7aZUlBuj983vOXGtHpucUt7UID
         9NseOKKnjjt/krMoLGIJrzOwrZll1g+bUtfza2NTx3SF3p9Hsfo1WAsFi3RiaszJmi
         v7nxrTaANF/XS338YTs9UYc0kJnejEXncPVtijXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, ruanjinjie <ruanjinjie@huawei.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 188/529] drm/mediatek: mtk_drm_crtc: Add checks for devm_kcalloc
Date:   Fri, 10 Mar 2023 14:35:31 +0100
Message-Id: <20230310133813.683866380@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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

From: ruanjinjie <ruanjinjie@huawei.com>

[ Upstream commit 5bf1e3bd7da625ccf9a22c8cb7d65271e6e47f4c ]

As the devm_kcalloc may return NULL, the return value needs to be checked
to avoid NULL poineter dereference.

Fixes: 31c5558dae05 ("drm/mediatek: Refactor plane init")
Signed-off-by: ruanjinjie <ruanjinjie@huawei.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patchwork.kernel.org/project/linux-mediatek/patch/20221205095115.2905090-1-ruanjinjie@huawei.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
index dfd5ed15a7f4a..e83b1c406b96a 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
@@ -803,6 +803,8 @@ int mtk_drm_crtc_create(struct drm_device *drm_dev,
 
 	mtk_crtc->planes = devm_kcalloc(dev, num_comp_planes,
 					sizeof(struct drm_plane), GFP_KERNEL);
+	if (!mtk_crtc->planes)
+		return -ENOMEM;
 
 	for (i = 0; i < mtk_crtc->ddp_comp_nr; i++) {
 		ret = mtk_drm_crtc_init_comp_planes(drm_dev, mtk_crtc, i,
-- 
2.39.2



