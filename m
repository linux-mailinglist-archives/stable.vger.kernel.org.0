Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA33F6BB383
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233156AbjCOMpi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232994AbjCOMpL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:45:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1D40A2F34
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:43:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80C7861D4F
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:43:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99339C433EF;
        Wed, 15 Mar 2023 12:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678884202;
        bh=A9tmklPM1QtixDaVMZfJxnuUKywmHvlooSrUIZs5ojM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ksJdDV1tGTQqZfnNxLc2W4a3Yk+zl7sEHK0gUO/zMoUwep3rr2wXJ6NwR7ZCJ5dT6
         sQnnK9miNhzz2+dFh9mcoeIh62I0wTHUkMN2FvtNAk+hPMBZXbgnp/w1FoGixWe4wP
         LyzF1Ne8fcD5onTNBXC1T91VmoIfm9UWBmLaJpcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Paul Elder <paul.elder@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
        Jai Luthra <j-luthra@ti.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 134/141] media: ov5640: Fix analogue gain control
Date:   Wed, 15 Mar 2023 13:13:57 +0100
Message-Id: <20230315115744.059568018@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
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

From: Paul Elder <paul.elder@ideasonboard.com>

[ Upstream commit afa4805799c1d332980ad23339fdb07b5e0cf7e0 ]

Gain control is badly documented in publicly available (including
leaked) documentation.

There is an AGC pre-gain in register 0x3a13, expressed as a 6-bit value
(plus an enable bit in bit 6). The driver hardcodes it to 0x43, which
one application note states is equal to x1.047. The documentation also
states that 0x40 is equel to x1.000. The pre-gain thus seems to be
expressed as in 1/64 increments, and thus ranges from x1.00 to x1.984.
What the pre-gain does is however unspecified.

There is then an AGC gain limit, in registers 0x3a18 and 0x3a19,
expressed as a 10-bit "real gain format" value. One application note
sets it to 0x00f8 and states it is equal to x15.5, so it appears to be
expressed in 1/16 increments, up to x63.9375.

The manual gain is stored in registers 0x350a and 0x350b, also as a
10-bit "real gain format" value. It is documented in the application
note as a Q6.4 values, up to x63.9375.

One version of the datasheet indicates that the sensor supports a
digital gain:

  The OV5640 supports 1/2/4 digital gain. Normally, the gain is
  controlled automatically by the automatic gain control (AGC) block.

It isn't clear how that would be controlled manually.

There appears to be no indication regarding whether the gain controlled
through registers 0x350a and 0x350b is an analogue gain only or also
includes digital gain. The words "real gain" don't necessarily mean
"combined analogue and digital gains". Some OmniVision sensors (such as
the OV8858) are documented as supoprting different formats for the gain
values, selectable through a register bit, and they are called "real
gain format" and "sensor gain format". For that sensor, we have (one of)
the gain registers documented as

  0x3503[2]=0, gain[7:0] is real gain format, where low 4 bits are
  fraction bits, for example, 0x10 is 1x gain, 0x28 is 2.5x gain

  If 0x3503[2]=1, gain[7:0] is sensor gain format, gain[7:4] is coarse
  gain, 00000: 1x, 00001: 2x, 00011: 4x, 00111: 8x, gain[7] is 1,
  gain[3:0] is fine gain. For example, 0x10 is 1x gain, 0x30 is 2x gain,
  0x70 is 4x gain

(The second part of the text makes little sense)

"Real gain" may thus refer to the combination of the coarse and fine
analogue gains as a single value.

The OV5640 0x350a and 0x350b registers thus appear to control analogue
gain. The driver incorrectly uses V4L2_CID_GAIN as V4L2 has a specific
control for analogue gain, V4L2_CID_ANALOGUE_GAIN. Use it.

If registers 0x350a and 0x350b are later found to control digital gain
as well, the driver could then restrict the range of the analogue gain
control value to lower than x64 and add a separate digital gain control.

Signed-off-by: Paul Elder <paul.elder@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Reviewed-by: Jai Luthra <j-luthra@ti.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov5640.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index c159f297ab92a..16ca9dbf15442 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -3482,7 +3482,7 @@ static int ov5640_init_controls(struct ov5640_dev *sensor)
 	/* Auto/manual gain */
 	ctrls->auto_gain = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_AUTOGAIN,
 					     0, 1, 1, 1);
-	ctrls->gain = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_GAIN,
+	ctrls->gain = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_ANALOGUE_GAIN,
 					0, 1023, 1, 0);
 
 	ctrls->saturation = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_SATURATION,
-- 
2.39.2



