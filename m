Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0075C59001D
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236248AbiHKPh4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235800AbiHKPhi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:37:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7220B98C92;
        Thu, 11 Aug 2022 08:33:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E006E615F5;
        Thu, 11 Aug 2022 15:33:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B277C433B5;
        Thu, 11 Aug 2022 15:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232018;
        bh=6cI4e/SzWqwKuLBDWqm/NtSsDV1+WYzfcjjsNPihx/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YiiU3a6dmL+WQAVrttzw7x0dQQguzeLU6HCkkdK8e4dYXaDGeRGXWW36luHdD4Ljz
         9zNs+JzR7GAgIFQ8seLRd0VpGpbSLDRpOVMeTe4xX2B4i6uXZPX0vzfP9iX746wLEN
         bhs5SGIZvBhhpYfYvMQ1JfHLvecF3CQol9yHZ+Fd0rE0rJD+dK2FoZyF/qLJUyVxUg
         VGVr42NwfcRLUURJc6qw1iNbkIOy5fcyplqLLvXZZ1jLHRQzo+20/eh4G6pajegq0h
         intv7L1eplK9S8Eqi2wk5xXRjniXqRvOM+VDpyIvpgTgixbyw9uOZ/wnsnplInI8IJ
         UTS+L0/rPbKpA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eugen Hristev <eugen.hristev@microchip.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, nicolas.ferre@microchip.com,
        alexandre.belloni@bootlin.com, claudiu.beznea@microchip.com,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.19 048/105] media: atmel: atmel-isc-base: allow wb ctrls to be changed when isc is not configured
Date:   Thu, 11 Aug 2022 11:27:32 -0400
Message-Id: <20220811152851.1520029-48-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
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

From: Eugen Hristev <eugen.hristev@microchip.com>

[ Upstream commit aa63c5eaf7f7d2d3a4b1cc5782e7151b8ae3079f ]

When attempting to change the white balance (WB) ctrls before starting
streaming, e.g.:

 # v4l2-ctl -L

User Controls
..
            blue_component_gain 0x009819c1 (int)    : min=0 max=8191 step=1 default=512 value=512 flags=slider
..
 # v4l2-ctl --set-ctrl=blue_component_gain=500
 # v4l2-ctl -L
..
            blue_component_gain 0x009819c1 (int)    : min=0 max=8191 step=1 default=512 value=500 flags=slider
..

These will not be written to the internal data struct and will not be
written to the WB hardware module.
Thus, after starting streaming, they will be reset to default:

 # v4l2-ctl -L
..
            blue_component_gain 0x009819c1 (int)    : min=0 max=8191 step=1 default=512 value=512 flags=slider
..

It does not make much sense to not be able to configure the WB controls
at all times. Even if the sensor would not be RAW Bayer (and in this case the
WB module is unavailable), the user could configure the ISC itself, as the
ISC should not care about the sensor format.
Thus, when WB module is available (if the sensor changes format e.g.) it will
be already configured as be user's desires.
In consequence, remove the check in isc_s_awb_ctrl that will return if ISC
does not know the sensor format.

Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/atmel/atmel-isc-base.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/platform/atmel/atmel-isc-base.c b/drivers/media/platform/atmel/atmel-isc-base.c
index 2f07a50035c8..fce4a7ae43d7 100644
--- a/drivers/media/platform/atmel/atmel-isc-base.c
+++ b/drivers/media/platform/atmel/atmel-isc-base.c
@@ -1525,10 +1525,6 @@ static int isc_s_awb_ctrl(struct v4l2_ctrl *ctrl)
 		else
 			ctrls->awb = ISC_WB_NONE;
 
-		/* we did not configure ISC yet */
-		if (!isc->config.sd_format)
-			break;
-
 		/* configure the controls with new values from v4l2 */
 		if (ctrl->cluster[ISC_CTRL_R_GAIN]->is_new)
 			ctrls->gain[ISC_HIS_CFG_MODE_R] = isc->r_gain_ctrl->val;
-- 
2.35.1

