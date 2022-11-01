Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20E6A61492B
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 12:34:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbiKALeK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 07:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbiKALdX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 07:33:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FF641B1CF;
        Tue,  1 Nov 2022 04:30:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 930DAB81CCD;
        Tue,  1 Nov 2022 11:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28FEFC433C1;
        Tue,  1 Nov 2022 11:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667302215;
        bh=vLsWhaWfthnY1eDb3thOqafTKkz9DILQDMTO4Ks0ZkY=;
        h=From:To:Cc:Subject:Date:From;
        b=reH42v+QZegfrULq45Tg3GKowzECfbwwXAU4RxnG9r5wnSmvSQAGsCiaRmIUffXto
         x33Y+w/HzelUdcwdzgu96CYj+kqsFVKayv5nctOgqyLH/cTHFSQ85PBS0QmwgHvu1c
         7BHW6vDpqsSVWxf0bXXuzHpoNyIRcABW5OySIz9mZ9VsF1arYblvwhvw7NFT56oZJJ
         7oHnUWnIpWp2YZDCtApNrGPcgaMSGiCjru+E3LJUXu1l0b3cw9VBcEwXIn5Osa2vkX
         pRbYfR4FGyBFHdQbikYeQwngKOSE3F1W+nbyJZCcMpn6si5N1X4K1LhV528avFwC79
         KaV8SEO6Lh7YQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Paul Elder <paul.elder@ideasonboard.com>,
        Dafna Hirschfeld <dafna@fastmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.10 01/14] media: rkisp1: Initialize color space on resizer sink and source pads
Date:   Tue,  1 Nov 2022 07:29:57 -0400
Message-Id: <20221101113012.800271-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 drivers/staging/media/rkisp1/rkisp1-resizer.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/staging/media/rkisp1/rkisp1-resizer.c b/drivers/staging/media/rkisp1/rkisp1-resizer.c
index 4dcc342ac2b2..76f17dd7670f 100644
--- a/drivers/staging/media/rkisp1/rkisp1-resizer.c
+++ b/drivers/staging/media/rkisp1/rkisp1-resizer.c
@@ -500,6 +500,10 @@ static int rkisp1_rsz_init_config(struct v4l2_subdev *sd,
 	sink_fmt->height = RKISP1_DEFAULT_HEIGHT;
 	sink_fmt->field = V4L2_FIELD_NONE;
 	sink_fmt->code = RKISP1_DEF_FMT;
+	sink_fmt->colorspace = V4L2_COLORSPACE_SRGB;
+	sink_fmt->xfer_func = V4L2_XFER_FUNC_SRGB;
+	sink_fmt->ycbcr_enc = V4L2_YCBCR_ENC_601;
+	sink_fmt->quantization = V4L2_QUANTIZATION_LIM_RANGE;
 
 	sink_crop = v4l2_subdev_get_try_crop(sd, cfg, RKISP1_RSZ_PAD_SINK);
 	sink_crop->width = RKISP1_DEFAULT_WIDTH;
-- 
2.35.1

