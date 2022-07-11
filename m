Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4532F56FD18
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233694AbiGKJu4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233716AbiGKJuC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:50:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 198BD27FD0;
        Mon, 11 Jul 2022 02:24:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8A5A61137;
        Mon, 11 Jul 2022 09:24:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD97C34115;
        Mon, 11 Jul 2022 09:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531466;
        bh=07WT9RtlxwLOxY71BOZkHyVY+aRKwX1I6w6eyvoueyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NSV4X/EPBggYQ7XgdZrPg+Ux1iUuFlLAdKlULj8ceCeMrrfrJk/qMT283/zMbumAr
         0XZM3ZADC9Dgdq8IAbW0FLdIxATdYcGxiW8pjanKO7VPo3TpuBsqWBUTuyZJpC/yxh
         JnSk7oxrojUjwC5IF2R1yUgkQPTURVyu6VGDKnDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 115/230] ASoC: rt5682: fix an incorrect NULL check on list iterator
Date:   Mon, 11 Jul 2022 11:06:11 +0200
Message-Id: <20220711090607.329020791@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Xiaomeng Tong <xiam0nd.tong@gmail.com>

[ Upstream commit c8618d65007ba68d7891130642d73e89372101e8 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5682.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/sound/soc/codecs/rt5682.c b/sound/soc/codecs/rt5682.c
index 80d199843b8c..8a9e1a4fa03e 100644
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
-- 
2.35.1



