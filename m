Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83700657BA2
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233354AbiL1PXt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:23:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233689AbiL1PXs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:23:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC6113F44
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:23:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D80996154D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:23:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6205C433D2;
        Wed, 28 Dec 2022 15:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241026;
        bh=it1IqFbAMGrQR55YRJyMG3htlj7dBdDxPU83/mm0UFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X5FYNEDUGHWUinBKCyDZpiI+A+kz1GK0GMkWVjlBU9LT7KFu7n2CgjlrZWjEtKOpp
         WP4I9Re8/u/Mx2L0mrejKqPWsiKDJgUmxW8haiihLnuzx3f4MWqgkWstrZKUCV/T+N
         X7HJVUIeqUiPrWNhxTAAUmcu3bDF7dO44ja3HL3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yunfei Dong <yunfei.dong@mediatek.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0231/1073] media: mediatek: vcodec: fix h264 cavlc bitstream fail
Date:   Wed, 28 Dec 2022 15:30:19 +0100
Message-Id: <20221228144334.300933794@linuxfoundation.org>
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

[ Upstream commit d555409dd1b7cc9e7e5b9e2924c0ef4bf23f6c9b ]

Some cavlc bistream will decode fail when the frame size is less than
20 bytes. Need to add pending data at the end of the bitstream.

For the minimum size of mapped memory is 256 bytes(16x16), adding four
bytes data won't lead to access unknown virtual memory.

Fixes: 59fba9eed5a7 ("media: mediatek: vcodec: support stateless H.264 decoding for mt8192")
Signed-off-by: Yunfei Dong <yunfei.dong@mediatek.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../vcodec/vdec/vdec_h264_req_multi_if.c      | 32 +++++++++++++++++--
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/mediatek/vcodec/vdec/vdec_h264_req_multi_if.c b/drivers/media/platform/mediatek/vcodec/vdec/vdec_h264_req_multi_if.c
index 4cc92700692b..18e048755d11 100644
--- a/drivers/media/platform/mediatek/vcodec/vdec/vdec_h264_req_multi_if.c
+++ b/drivers/media/platform/mediatek/vcodec/vdec/vdec_h264_req_multi_if.c
@@ -539,6 +539,29 @@ static int vdec_h264_slice_core_decode(struct vdec_lat_buf *lat_buf)
 	return 0;
 }
 
+static void vdec_h264_insert_startcode(struct mtk_vcodec_dev *vcodec_dev, unsigned char *buf,
+				       size_t *bs_size, struct mtk_h264_pps_param *pps)
+{
+	struct device *dev = &vcodec_dev->plat_dev->dev;
+
+	/* Need to add pending data at the end of bitstream when bs_sz is small than
+	 * 20 bytes for cavlc bitstream, or lat will decode fail. This pending data is
+	 * useful for mt8192 and mt8195 platform.
+	 *
+	 * cavlc bitstream when entropy_coding_mode_flag is false.
+	 */
+	if (pps->entropy_coding_mode_flag || *bs_size > 20 ||
+	    !(of_device_is_compatible(dev->of_node, "mediatek,mt8192-vcodec-dec") ||
+	    of_device_is_compatible(dev->of_node, "mediatek,mt8195-vcodec-dec")))
+		return;
+
+	buf[*bs_size] = 0;
+	buf[*bs_size + 1] = 0;
+	buf[*bs_size + 2] = 1;
+	buf[*bs_size + 3] = 0xff;
+	(*bs_size) += 4;
+}
+
 static int vdec_h264_slice_lat_decode(void *h_vdec, struct mtk_vcodec_mem *bs,
 				      struct vdec_fb *fb, bool *res_chg)
 {
@@ -582,9 +605,6 @@ static int vdec_h264_slice_lat_decode(void *h_vdec, struct mtk_vcodec_mem *bs,
 	}
 
 	inst->vsi->dec.nal_info = buf[nal_start_idx];
-	inst->vsi->dec.bs_buf_addr = (u64)bs->dma_addr;
-	inst->vsi->dec.bs_buf_size = bs->size;
-
 	lat_buf->src_buf_req = src_buf_info->m2m_buf.vb.vb2_buf.req_obj.req;
 	v4l2_m2m_buf_copy_metadata(&src_buf_info->m2m_buf.vb, &lat_buf->ts_info, true);
 
@@ -592,6 +612,12 @@ static int vdec_h264_slice_lat_decode(void *h_vdec, struct mtk_vcodec_mem *bs,
 	if (err)
 		goto err_free_fb_out;
 
+	vdec_h264_insert_startcode(inst->ctx->dev, buf, &bs->size,
+				   &share_info->h264_slice_params.pps);
+
+	inst->vsi->dec.bs_buf_addr = (uint64_t)bs->dma_addr;
+	inst->vsi->dec.bs_buf_size = bs->size;
+
 	*res_chg = inst->resolution_changed;
 	if (inst->resolution_changed) {
 		mtk_vcodec_debug(inst, "- resolution changed -");
-- 
2.35.1



