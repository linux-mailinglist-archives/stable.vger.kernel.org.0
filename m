Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C92F6042F5
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 13:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232698AbiJSLM2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 07:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232190AbiJSLL3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 07:11:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08C80152C6F;
        Wed, 19 Oct 2022 03:38:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29E0C617F0;
        Wed, 19 Oct 2022 09:00:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC2FC433D7;
        Wed, 19 Oct 2022 09:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170006;
        bh=S4RSHtuV1Yq7gBtTypNHchaWySqiBm1BQG1Zydq1K/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dMOMn7qrddfAc6xqWngJeM5kpklMQ4xasrJIGZc1fcZOS9wLYORoeTxaeqjagmdzU
         fwYtyOLqsbJMUI9k79zi71WO7pWmaFj2AxfDuv3QfN1v1HdBRCj12bkU7OMJ5YeC0M
         XWsoVy9ZVUGQJ6uXkBZhU/ehRYLO9ci/7KFjSvcA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Qian <ming.qian@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 492/862] media: amphion: dont change the colorspace reported by decoder.
Date:   Wed, 19 Oct 2022 10:29:39 +0200
Message-Id: <20221019083311.727638675@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Qian <ming.qian@nxp.com>

[ Upstream commit 61c2698ee60630c6a7d2e99850fa81ff6450270a ]

decoder will report the colorspace information
which is parsed from the sequence header,
if they are unspecified, just let application to determine it,
don't change it in driver.

Fixes: 6de8d628df6ef ("media: amphion: add v4l2 m2m vpu decoder stateful driver")
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vdec.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/amphion/vdec.c b/drivers/media/platform/amphion/vdec.c
index 9e64041cc1c1..feb75dc204de 100644
--- a/drivers/media/platform/amphion/vdec.c
+++ b/drivers/media/platform/amphion/vdec.c
@@ -808,14 +808,6 @@ static void vdec_init_fmt(struct vpu_inst *inst)
 		inst->cap_format.field = V4L2_FIELD_NONE;
 	else
 		inst->cap_format.field = V4L2_FIELD_SEQ_TB;
-	if (vdec->codec_info.color_primaries == V4L2_COLORSPACE_DEFAULT)
-		vdec->codec_info.color_primaries = V4L2_COLORSPACE_REC709;
-	if (vdec->codec_info.transfer_chars == V4L2_XFER_FUNC_DEFAULT)
-		vdec->codec_info.transfer_chars = V4L2_XFER_FUNC_709;
-	if (vdec->codec_info.matrix_coeffs == V4L2_YCBCR_ENC_DEFAULT)
-		vdec->codec_info.matrix_coeffs = V4L2_YCBCR_ENC_709;
-	if (vdec->codec_info.full_range == V4L2_QUANTIZATION_DEFAULT)
-		vdec->codec_info.full_range = V4L2_QUANTIZATION_LIM_RANGE;
 }
 
 static void vdec_init_crop(struct vpu_inst *inst)
@@ -1555,6 +1547,14 @@ static int vdec_get_debug_info(struct vpu_inst *inst, char *str, u32 size, u32 i
 				vdec->codec_info.frame_rate.numerator,
 				vdec->codec_info.frame_rate.denominator);
 		break;
+	case 9:
+		num = scnprintf(str, size, "colorspace: %d, %d, %d, %d (%d)\n",
+				vdec->codec_info.color_primaries,
+				vdec->codec_info.transfer_chars,
+				vdec->codec_info.matrix_coeffs,
+				vdec->codec_info.full_range,
+				vdec->codec_info.vui_present);
+		break;
 	default:
 		break;
 	}
-- 
2.35.1



