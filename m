Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFEC621489
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234955AbiKHOCQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:02:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235015AbiKHOCJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:02:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0204623B6
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:02:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8BFD5B81AFA
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:02:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD59BC433C1;
        Tue,  8 Nov 2022 14:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916126;
        bh=HruG7jQ4za4m7TozHiv4ec4kangJmfDPWzplEJO2B50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x68/fsc91uogWpuMRFM9cdvKgxFGVgI2KSXDHz29aq6rAfmZ27rXwuer9H9AE2tJq
         44BLpfspv+jz3Jt0wgGi3xCZGAtdRaL9zR9TLsK8VMDmu613Rb4Rz5B903CVzqtahQ
         0GvBNifUWLHf0RFqvRsvADcjHol0ZAflDoIWmMpA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Paul Elder <paul.elder@ideasonboard.com>,
        Dafna Hirschfeld <dafna@fastmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 070/144] media: rkisp1: Initialize color space on resizer sink and source pads
Date:   Tue,  8 Nov 2022 14:39:07 +0100
Message-Id: <20221108133348.239287313@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
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

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit 83b9296e399367862845d3b19984444fc756bd61 ]

Initialize the four color space fields on the sink and source video pads
of the resizer in the .init_cfg() operation. The resizer can't perform
any color space conversion, so set the sink and source color spaces to
the same defaults, which match the ISP source video pad default.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Paul Elder <paul.elder@ideasonboard.com>
Reviewed-by: Dafna Hirschfeld <dafna@fastmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rockchip/rkisp1/rkisp1-resizer.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/platform/rockchip/rkisp1/rkisp1-resizer.c b/drivers/media/platform/rockchip/rkisp1/rkisp1-resizer.c
index 2070f4b06705..a166ede40967 100644
--- a/drivers/media/platform/rockchip/rkisp1/rkisp1-resizer.c
+++ b/drivers/media/platform/rockchip/rkisp1/rkisp1-resizer.c
@@ -510,6 +510,10 @@ static int rkisp1_rsz_init_config(struct v4l2_subdev *sd,
 	sink_fmt->height = RKISP1_DEFAULT_HEIGHT;
 	sink_fmt->field = V4L2_FIELD_NONE;
 	sink_fmt->code = RKISP1_DEF_FMT;
+	sink_fmt->colorspace = V4L2_COLORSPACE_SRGB;
+	sink_fmt->xfer_func = V4L2_XFER_FUNC_SRGB;
+	sink_fmt->ycbcr_enc = V4L2_YCBCR_ENC_601;
+	sink_fmt->quantization = V4L2_QUANTIZATION_LIM_RANGE;
 
 	sink_crop = v4l2_subdev_get_try_crop(sd, sd_state,
 					     RKISP1_RSZ_PAD_SINK);
-- 
2.35.1



