Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C79396584EC
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 18:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235244AbiL1RD5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 12:03:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234484AbiL1RDg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 12:03:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 525A11274D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:57:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E31366157A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:57:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015F5C433EF;
        Wed, 28 Dec 2022 16:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246671;
        bh=TMjMsjHmMhbl2ZFSTDpsbYNl/eWUpsAJug78mago/Y0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PMc1yEemlm7qL1yMug5JcOLO20eD7aB/vHo87zulAihuWB7LvW4HU5jBs7zGaN/Gm
         wqrLJhgsjeInOLmmJOnyXbIQccFXR/dzWWTBfOuRZ3GmR3DCYshhZj9rwlPOplPBBc
         I/rJ9sCQrNmmJt3NdtxtbcR66klkz1gOFGjnGQjk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jeff LaBundy <jeff@labundy.com>,
        Mattijs Korpershoek <mkorpershoek@baylibre.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1093/1146] Input: iqs7222 - report malformed properties
Date:   Wed, 28 Dec 2022 15:43:52 +0100
Message-Id: <20221228144359.863076746@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Jeff LaBundy <jeff@labundy.com>

[ Upstream commit 404f3b48e65f058d94429e4a1ec16a1f82ff3b2f ]

Nonzero return values of several calls to fwnode_property_read_u32()
are silently ignored, leaving no way to know the properties were not
applied in the event of an error.

Solve this problem by evaluating fwnode_property_read_u32()'s return
value, and reporting an error for any nonzero return value not equal
to -EINVAL which indicates the property was absent altogether.

Fixes: e505edaedcb9 ("Input: add support for Azoteq IQS7222A/B/C")
Signed-off-by: Jeff LaBundy <jeff@labundy.com>
Reviewed-by: Mattijs Korpershoek <mkorpershoek@baylibre.com>
Link: https://lore.kernel.org/r/Y1SRRrpQXvkETjfm@nixie71
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/iqs7222.c | 44 +++++++++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 8 deletions(-)

diff --git a/drivers/input/misc/iqs7222.c b/drivers/input/misc/iqs7222.c
index 1c450ba4fdc3..6af25dfd1d2a 100644
--- a/drivers/input/misc/iqs7222.c
+++ b/drivers/input/misc/iqs7222.c
@@ -1807,8 +1807,9 @@ static int iqs7222_parse_chan(struct iqs7222_private *iqs7222,
 		chan_setup[0] |= IQS7222_CHAN_SETUP_0_REF_MODE_FOLLOW;
 		chan_setup[4] = val * 42 + 1048;
 
-		if (!fwnode_property_read_u32(chan_node, "azoteq,ref-weight",
-					      &val)) {
+		error = fwnode_property_read_u32(chan_node, "azoteq,ref-weight",
+						 &val);
+		if (!error) {
 			if (val > U16_MAX) {
 				dev_err(&client->dev,
 					"Invalid %s reference weight: %u\n",
@@ -1817,6 +1818,11 @@ static int iqs7222_parse_chan(struct iqs7222_private *iqs7222,
 			}
 
 			chan_setup[5] = val;
+		} else if (error != -EINVAL) {
+			dev_err(&client->dev,
+				"Failed to read %s reference weight: %d\n",
+				fwnode_get_name(chan_node), error);
+			return error;
 		}
 
 		/*
@@ -1889,9 +1895,10 @@ static int iqs7222_parse_chan(struct iqs7222_private *iqs7222,
 		if (!event_node)
 			continue;
 
-		if (!fwnode_property_read_u32(event_node,
-					      "azoteq,timeout-press-ms",
-					      &val)) {
+		error = fwnode_property_read_u32(event_node,
+						 "azoteq,timeout-press-ms",
+						 &val);
+		if (!error) {
 			/*
 			 * The IQS7222B employs a global pair of press timeout
 			 * registers as opposed to channel-specific registers.
@@ -1911,6 +1918,12 @@ static int iqs7222_parse_chan(struct iqs7222_private *iqs7222,
 
 			*setup &= ~(U8_MAX << i * 8);
 			*setup |= (val / 500 << i * 8);
+		} else if (error != -EINVAL) {
+			dev_err(&client->dev,
+				"Failed to read %s press timeout: %d\n",
+				fwnode_get_name(event_node), error);
+			fwnode_handle_put(event_node);
+			return error;
 		}
 
 		error = iqs7222_parse_event(iqs7222, event_node, chan_index,
@@ -2009,7 +2022,8 @@ static int iqs7222_parse_sldr(struct iqs7222_private *iqs7222,
 	if (fwnode_property_present(sldr_node, "azoteq,use-prox"))
 		sldr_setup[4 + reg_offset] -= 2;
 
-	if (!fwnode_property_read_u32(sldr_node, "azoteq,slider-size", &val)) {
+	error = fwnode_property_read_u32(sldr_node, "azoteq,slider-size", &val);
+	if (!error) {
 		if (val > dev_desc->sldr_res) {
 			dev_err(&client->dev, "Invalid %s size: %u\n",
 				fwnode_get_name(sldr_node), val);
@@ -2023,6 +2037,10 @@ static int iqs7222_parse_sldr(struct iqs7222_private *iqs7222,
 			sldr_setup[2] |= (val / 16 <<
 					  IQS7222_SLDR_SETUP_2_RES_SHIFT);
 		}
+	} else if (error != -EINVAL) {
+		dev_err(&client->dev, "Failed to read %s size: %d\n",
+			fwnode_get_name(sldr_node), error);
+		return error;
 	}
 
 	if (!(reg_offset ? sldr_setup[3]
@@ -2032,7 +2050,8 @@ static int iqs7222_parse_sldr(struct iqs7222_private *iqs7222,
 		return -EINVAL;
 	}
 
-	if (!fwnode_property_read_u32(sldr_node, "azoteq,top-speed", &val)) {
+	error = fwnode_property_read_u32(sldr_node, "azoteq,top-speed", &val);
+	if (!error) {
 		if (val > (reg_offset ? U16_MAX : U8_MAX * 4)) {
 			dev_err(&client->dev, "Invalid %s top speed: %u\n",
 				fwnode_get_name(sldr_node), val);
@@ -2045,9 +2064,14 @@ static int iqs7222_parse_sldr(struct iqs7222_private *iqs7222,
 			sldr_setup[2] &= ~IQS7222_SLDR_SETUP_2_TOP_SPEED_MASK;
 			sldr_setup[2] |= (val / 4);
 		}
+	} else if (error != -EINVAL) {
+		dev_err(&client->dev, "Failed to read %s top speed: %d\n",
+			fwnode_get_name(sldr_node), error);
+		return error;
 	}
 
-	if (!fwnode_property_read_u32(sldr_node, "linux,axis", &val)) {
+	error = fwnode_property_read_u32(sldr_node, "linux,axis", &val);
+	if (!error) {
 		u16 sldr_max = sldr_setup[3] - 1;
 
 		if (!reg_offset) {
@@ -2061,6 +2085,10 @@ static int iqs7222_parse_sldr(struct iqs7222_private *iqs7222,
 
 		input_set_abs_params(iqs7222->keypad, val, 0, sldr_max, 0, 0);
 		iqs7222->sl_axis[sldr_index] = val;
+	} else if (error != -EINVAL) {
+		dev_err(&client->dev, "Failed to read %s axis: %d\n",
+			fwnode_get_name(sldr_node), error);
+		return error;
 	}
 
 	if (dev_desc->wheel_enable) {
-- 
2.35.1



