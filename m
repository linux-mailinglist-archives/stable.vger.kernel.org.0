Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C46E537D61
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 15:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237488AbiE3Ngr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238044AbiE3NgC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:36:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5527C9809C;
        Mon, 30 May 2022 06:29:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A92B60DD5;
        Mon, 30 May 2022 13:29:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD64C36AE9;
        Mon, 30 May 2022 13:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917380;
        bh=1IhMAlmpFLnSmrF7JaiDJvASdMM846kQitQkMmoRy58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lXXCCXlPc+3itHLjAZFu6I+SIfjiVAH618tt5tUd7hr61PFqIG6wWXgLim+UclCRh
         Utu8oG3ca2U9PytPMwcnxB2rG7fBom1VczEplfTE38ZwxQRh1ZQtToM64UHWkdMpZr
         jbJp2UUpzNwMDbjg5pSaq0LjE57yCnQ7rF40fCh4KD6yhSV20tdFZ4hWQPT6BO/iMA
         a+jI0i53NuzUvbEY7RtXpAcu8yhJ+HrDa1iqgfK7aZq91RaNDLPFbTtx0YW/UNVFxY
         5xT0L90WRplME7J1Xu21GgTChrr2UpvwZcGCaQLRLEiTE2KF6qgfWcVohY5TJNzA0P
         YGlLBUqoraZ9Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Benjamin Gaignard <benjamin.gaignard@collabora.com>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, p.zabel@pengutronix.de,
        gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        linux-rockchip@lists.infradead.org, linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.18 114/159] media: hantro: HEVC: unconditionnaly set pps_{cb/cr}_qp_offset values
Date:   Mon, 30 May 2022 09:23:39 -0400
Message-Id: <20220530132425.1929512-114-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
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

From: Benjamin Gaignard <benjamin.gaignard@collabora.com>

[ Upstream commit 46c836569196f377f87a3657b330cffaf94bd727 ]

Always set pps_cb_qp_offset and pps_cr_qp_offset values in Hantro/G2
register whatever is V4L2_HEVC_PPS_FLAG_PPS_SLICE_CHROMA_QP_OFFSETS_PRESENT
flag value.
The vendor code does the same to set these values.
This fixes conformance test CAINIT_G_SHARP_3.

Fluster HEVC score is increase by one with this patch.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@collabora.com>
Reviewed-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/hantro/hantro_g2_hevc_dec.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/media/hantro/hantro_g2_hevc_dec.c b/drivers/staging/media/hantro/hantro_g2_hevc_dec.c
index c524af41baf5..2e7eec0372cd 100644
--- a/drivers/staging/media/hantro/hantro_g2_hevc_dec.c
+++ b/drivers/staging/media/hantro/hantro_g2_hevc_dec.c
@@ -180,13 +180,8 @@ static void set_params(struct hantro_ctx *ctx)
 		hantro_reg_write(vpu, &g2_max_cu_qpd_depth, 0);
 	}
 
-	if (pps->flags & V4L2_HEVC_PPS_FLAG_PPS_SLICE_CHROMA_QP_OFFSETS_PRESENT) {
-		hantro_reg_write(vpu, &g2_cb_qp_offset, pps->pps_cb_qp_offset);
-		hantro_reg_write(vpu, &g2_cr_qp_offset, pps->pps_cr_qp_offset);
-	} else {
-		hantro_reg_write(vpu, &g2_cb_qp_offset, 0);
-		hantro_reg_write(vpu, &g2_cr_qp_offset, 0);
-	}
+	hantro_reg_write(vpu, &g2_cb_qp_offset, pps->pps_cb_qp_offset);
+	hantro_reg_write(vpu, &g2_cr_qp_offset, pps->pps_cr_qp_offset);
 
 	hantro_reg_write(vpu, &g2_filt_offset_beta, pps->pps_beta_offset_div2);
 	hantro_reg_write(vpu, &g2_filt_offset_tc, pps->pps_tc_offset_div2);
-- 
2.35.1

