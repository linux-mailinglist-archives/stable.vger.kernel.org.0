Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFB3657B7F
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233330AbiL1PXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:23:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233344AbiL1PWl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:22:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDB7E14032
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:22:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54CBAB8170E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:22:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE2FC433D2;
        Wed, 28 Dec 2022 15:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240938;
        bh=rLHu2CYfxahU9xq6+rUVZpyjwkXOw6GYE1rOuZsnWMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SBCzgfQQmoawKzbd+y4FV/+Ggih6evpVbTBkV7T4xqeK2PToHJamExf2KvNviT3Gz
         vVpN75KjAc4l8mGrLwq7nKx/nWWhPuXFVb55utH0NzAOVPEUygS0L89epge2SSgE2G
         SIvrES2lDAl2TDrQG/spQScx8gZ/VOvFmxOl+xsk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jeff LaBundy <jeff@labundy.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0221/1073] Input: iqs7222 - set all ULP entry masks by default
Date:   Wed, 28 Dec 2022 15:30:09 +0100
Message-Id: <20221228144334.019659502@linuxfoundation.org>
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

From: Jeff LaBundy <jeff@labundy.com>

[ Upstream commit d56111ed58482de0045e1e1201122e6e71516945 ]

Some devices expose an ultra-low-power (ULP) mode entry mask for
each channel. If the mask is set, the device cannot enter ULP so
long as the corresponding channel remains in an active state.

The vendor has advised setting the mask for any disabled channel.
To accommodate this suggestion, initially set all masks and then
clear them only if specified in the device tree.

Fixes: e505edaedcb9 ("Input: add support for Azoteq IQS7222A/B/C")
Signed-off-by: Jeff LaBundy <jeff@labundy.com>
Link: https://lore.kernel.org/r/20220908131548.48120-8-jeff@labundy.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Stable-dep-of: 2f6fd2329789 ("Input: iqs7222 - protect against undefined slider size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/iqs7222.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/input/misc/iqs7222.c b/drivers/input/misc/iqs7222.c
index b2e8097a2e6d..8b3362169265 100644
--- a/drivers/input/misc/iqs7222.c
+++ b/drivers/input/misc/iqs7222.c
@@ -1771,11 +1771,9 @@ static int iqs7222_parse_chan(struct iqs7222_private *iqs7222, int chan_index)
 	if (!chan_node)
 		return 0;
 
-	if (dev_desc->allow_offset) {
-		sys_setup[dev_desc->allow_offset] |= BIT(chan_index);
-		if (fwnode_property_present(chan_node, "azoteq,ulp-allow"))
-			sys_setup[dev_desc->allow_offset] &= ~BIT(chan_index);
-	}
+	if (dev_desc->allow_offset &&
+	    fwnode_property_present(chan_node, "azoteq,ulp-allow"))
+		sys_setup[dev_desc->allow_offset] &= ~BIT(chan_index);
 
 	chan_setup[0] |= IQS7222_CHAN_SETUP_0_CHAN_EN;
 
@@ -2206,6 +2204,9 @@ static int iqs7222_parse_all(struct iqs7222_private *iqs7222)
 	u16 *sys_setup = iqs7222->sys_setup;
 	int error, i;
 
+	if (dev_desc->allow_offset)
+		sys_setup[dev_desc->allow_offset] = U16_MAX;
+
 	if (dev_desc->event_offset)
 		sys_setup[dev_desc->event_offset] = IQS7222_EVENT_MASK_ATI;
 
-- 
2.35.1



