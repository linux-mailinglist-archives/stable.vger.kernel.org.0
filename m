Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C422C657DAC
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234011AbiL1Ppq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:45:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233594AbiL1Ppo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:45:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59AF21BA
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:45:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E95726154D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:45:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0367BC433EF;
        Wed, 28 Dec 2022 15:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242341;
        bh=wlpB7vzVpR/Jkll+kT2TQvJwvocQjmwKWaqr3cK5FXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G/4Akcnavhl4HFheDyvM7jHE3wneg4sHKWvJUcgtRv/hwEDyuYhc1vIXvp99XwrGj
         zJVEnNqZivsgqBO1BuyV6hVcVsLVeNlNnL7pm4NVeI1M8CbtEzZpgcaiR9QanR+wO2
         L5lnvmryn1ww8zC9zae0hgYuaxqn0KqAXuDnuMeI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yunfei Dong <yunfei.dong@mediatek.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0399/1073] media: mediatek: vcodec: Setting lat buf to lat_list when lat decode error
Date:   Wed, 28 Dec 2022 15:33:07 +0100
Message-Id: <20221228144338.855943672@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunfei Dong <yunfei.dong@mediatek.com>

[ Upstream commit 12ac20d60213a439d1552382d04aabb905e0b784 ]

Need to set lat buf to lat_list when lat decode error, or lat buffer will
be lost.

Fixes: 5d418351ca8f ("media: mediatek: vcodec: support stateless VP9 decoding")
Signed-off-by: Yunfei Dong <yunfei.dong@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mediatek/vcodec/vdec/vdec_vp9_req_lat_if.c    | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/mediatek/vcodec/vdec/vdec_vp9_req_lat_if.c b/drivers/media/platform/mediatek/vcodec/vdec/vdec_vp9_req_lat_if.c
index fb1c36a3592d..cbb6728b8a40 100644
--- a/drivers/media/platform/mediatek/vcodec/vdec/vdec_vp9_req_lat_if.c
+++ b/drivers/media/platform/mediatek/vcodec/vdec/vdec_vp9_req_lat_if.c
@@ -2073,21 +2073,23 @@ static int vdec_vp9_slice_lat_decode(void *h_vdec, struct mtk_vcodec_mem *bs,
 		return -EBUSY;
 	}
 	pfc = (struct vdec_vp9_slice_pfc *)lat_buf->private_data;
-	if (!pfc)
-		return -EINVAL;
+	if (!pfc) {
+		ret = -EINVAL;
+		goto err_free_fb_out;
+	}
 	vsi = &pfc->vsi;
 
 	ret = vdec_vp9_slice_setup_lat(instance, bs, lat_buf, pfc);
 	if (ret) {
 		mtk_vcodec_err(instance, "Failed to setup VP9 lat ret %d\n", ret);
-		return ret;
+		goto err_free_fb_out;
 	}
 	vdec_vp9_slice_vsi_to_remote(vsi, instance->vsi);
 
 	ret = vpu_dec_start(&instance->vpu, NULL, 0);
 	if (ret) {
 		mtk_vcodec_err(instance, "Failed to dec VP9 ret %d\n", ret);
-		return ret;
+		goto err_free_fb_out;
 	}
 
 	if (instance->irq) {
@@ -2107,7 +2109,7 @@ static int vdec_vp9_slice_lat_decode(void *h_vdec, struct mtk_vcodec_mem *bs,
 	/* LAT trans full, no more UBE or decode timeout */
 	if (ret) {
 		mtk_vcodec_err(instance, "VP9 decode error: %d\n", ret);
-		return ret;
+		goto err_free_fb_out;
 	}
 
 	mtk_vcodec_debug(instance, "lat dma addr: 0x%lx 0x%lx\n",
@@ -2120,6 +2122,9 @@ static int vdec_vp9_slice_lat_decode(void *h_vdec, struct mtk_vcodec_mem *bs,
 	vdec_msg_queue_qbuf(&ctx->dev->msg_queue_core_ctx, lat_buf);
 
 	return 0;
+err_free_fb_out:
+	vdec_msg_queue_qbuf(&ctx->msg_queue.lat_ctx, lat_buf);
+	return ret;
 }
 
 static int vdec_vp9_slice_decode(void *h_vdec, struct mtk_vcodec_mem *bs,
-- 
2.35.1



