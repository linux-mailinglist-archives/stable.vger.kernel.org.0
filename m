Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B28B450DDFD
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 12:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241621AbiDYKiD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 06:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239269AbiDYKhd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 06:37:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B4F615FF4
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 03:34:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7145760C40
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 10:34:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D17FC385A7;
        Mon, 25 Apr 2022 10:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650882867;
        bh=oJG+7Rw/D8We2e+sTDL9925PWHUNiC5IHuUIgh7Ci3A=;
        h=Subject:To:Cc:From:Date:From;
        b=wRQDTucp7mrQ0Preqjm9XN9oLNW10pYCRZykQiq3f2cAkGCzNrAdHoOe0tTpG7CGR
         LOR//8/xVkvh/N9sHqPy3SUCe8MHreCbWd58Jkt7uGqTfixV4Ecos6Cd4MIACaGK5E
         LEAW6zfnv+HGXcb4AGWeNpYcwzOrMC7Xm9/hdn7Q=
Subject: FAILED: patch "[PATCH] ASoC: rt5682: fix an incorrect NULL check on list iterator" failed to apply to 5.10-stable tree
To:     xiam0nd.tong@gmail.com, broonie@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 Apr 2022 12:34:11 +0200
Message-ID: <16508828512471@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c8618d65007ba68d7891130642d73e89372101e8 Mon Sep 17 00:00:00 2001
From: Xiaomeng Tong <xiam0nd.tong@gmail.com>
Date: Sun, 27 Mar 2022 16:10:02 +0800
Subject: [PATCH] ASoC: rt5682: fix an incorrect NULL check on list iterator

The bug is here:
	if (!dai) {

The list iterator value 'dai' will *always* be set and non-NULL
by for_each_component_dais(), so it is incorrect to assume that
the iterator value will be NULL if the list is empty or no element
is found (In fact, it will be a bogus pointer to an invalid struct
object containing the HEAD). Otherwise it will bypass the check
'if (!dai) {' (never call dev_err() and never return -ENODEV;)
and lead to invalid memory access lately when calling
'rt5682_set_bclk1_ratio(dai, factor);'.

To fix the bug, just return rt5682_set_bclk1_ratio(dai, factor);
when found the 'dai', otherwise dev_err() and return -ENODEV;

Cc: stable@vger.kernel.org
Fixes: ebbfabc16d23d ("ASoC: rt5682: Add CCF usage for providing I2S clks")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
Link: https://lore.kernel.org/r/20220327081002.12684-1-xiam0nd.tong@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/sound/soc/codecs/rt5682.c b/sound/soc/codecs/rt5682.c
index be68d573a490..c9ff9c89adf7 100644
--- a/sound/soc/codecs/rt5682.c
+++ b/sound/soc/codecs/rt5682.c
@@ -2822,14 +2822,11 @@ static int rt5682_bclk_set_rate(struct clk_hw *hw, unsigned long rate,
 
 	for_each_component_dais(component, dai)
 		if (dai->id == RT5682_AIF1)
-			break;
-	if (!dai) {
-		dev_err(rt5682->i2c_dev, "dai %d not found in component\n",
-			RT5682_AIF1);
-		return -ENODEV;
-	}
+			return rt5682_set_bclk1_ratio(dai, factor);
 
-	return rt5682_set_bclk1_ratio(dai, factor);
+	dev_err(rt5682->i2c_dev, "dai %d not found in component\n",
+		RT5682_AIF1);
+	return -ENODEV;
 }
 
 static const struct clk_ops rt5682_dai_clk_ops[RT5682_DAI_NUM_CLKS] = {

