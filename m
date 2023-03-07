Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E126A6AEA58
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231727AbjCGRc5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:32:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231623AbjCGRch (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:32:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B6E373017
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:28:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A2E9B819A3
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:28:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC65C433EF;
        Tue,  7 Mar 2023 17:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210090;
        bh=fGnlC+/ZbJvDWK6umCHmbFyxO5HSN+xNb6T5ayMUs7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zhn8eWTqUsJ5aI6TbH8N98s09Zg6l4okerFAAwkmnNFnBffgvvPvpSiyoWYqHRUKr
         62lrKaZYvHLVcaxqSraJGVoHiF2SNZXn9011cOsb6MSNKj2M72RSzJnqeDlV1yxdQX
         +T8OIvvf/lodD5Z6JSdDELrHrp+ljnVFKgN+AK6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" 
        <nfraprado@collabora.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0398/1001] drm/mediatek: Clean dangling pointer on bind error path
Date:   Tue,  7 Mar 2023 17:52:50 +0100
Message-Id: <20230307170038.602217270@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAD_ENC_HEADER,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit 36aa8c61af55675ed967900fbe5deb32d776f051 ]

mtk_drm_bind() can fail, in which case drm_dev_put() is called,
destroying the drm_device object. However a pointer to it was still
being held in the private object, and that pointer would be passed along
to DRM in mtk_drm_sys_prepare() if a suspend were triggered at that
point, resulting in a panic. Clean the pointer when destroying the
object in the error path to prevent this from happening.

Fixes: 119f5173628a ("drm/mediatek: Add DRM Driver for Mediatek SoC MT8173.")
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patchwork.kernel.org/project/linux-mediatek/patch/20221122143949.3493104-1-nfraprado@collabora.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_drv.c b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
index cd5b18ef79512..d3e57dd79f5f5 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_drv.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
@@ -520,6 +520,7 @@ static int mtk_drm_bind(struct device *dev)
 err_deinit:
 	mtk_drm_kms_deinit(drm);
 err_free:
+	private->drm = NULL;
 	drm_dev_put(drm);
 	return ret;
 }
-- 
2.39.2



