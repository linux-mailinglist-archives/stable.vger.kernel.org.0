Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF6C550F7BC
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346953AbiDZJMN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345987AbiDZJHC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:07:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A543AA4C;
        Tue, 26 Apr 2022 01:48:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70F69B81CF2;
        Tue, 26 Apr 2022 08:48:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B68A1C385A4;
        Tue, 26 Apr 2022 08:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962894;
        bh=4AXazc0jgDq/CltRhbfOjP6IiwafM5rb0c14XsM8sU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ij+CAe8pojujSsAQDQNGEHSlZGrzVOCO81tKQ/YnjzlKslumDTs5t8AuxjMrV059o
         ZUL1UlGC8lX5Fx0JyWwA09/JxEGNon4iUyy/UVb2mzlmSxrLbNQvaiDfV0huhDXtcw
         FLQRYARlQrFjXXf5rgddAd0kB0BMg53eNlHyFB48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.17 124/146] codecs: rt5682s: fix an incorrect NULL check on list iterator
Date:   Tue, 26 Apr 2022 10:21:59 +0200
Message-Id: <20220426081753.548650313@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaomeng Tong <xiam0nd.tong@gmail.com>

commit acc72863e0f11cd0bedc888b663700229f9ba5ff upstream.

The bug is here:
            if (!dai) {

The list iterator value 'dai' will *always* be set and non-NULL
by for_each_component_dais(), so it is incorrect to assume that
the iterator value will be NULL if the list is empty or no element
is found (In fact, it will be a bogus pointer to an invalid struct
object containing the HEAD). Otherwise it will bypass the check
'if (!dai) {' (never call dev_err() and never return -ENODEV;)
and lead to invalid memory access lately when calling
'rt5682s_set_bclk1_ratio(dai, factor);'.

To fix the bug, just return rt5682s_set_bclk1_ratio(dai, factor);
when found the 'dai', otherwise dev_err() and return -ENODEV;

Cc: stable@vger.kernel.org
Fixes: bdd229ab26be9 ("ASoC: rt5682s: Add driver for ALC5682I-VS codec")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
Link: https://lore.kernel.org/r/20220327081300.12962-1-xiam0nd.tong@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/rt5682s.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/sound/soc/codecs/rt5682s.c
+++ b/sound/soc/codecs/rt5682s.c
@@ -2679,14 +2679,11 @@ static int rt5682s_bclk_set_rate(struct
 
 	for_each_component_dais(component, dai)
 		if (dai->id == RT5682S_AIF1)
-			break;
-	if (!dai) {
-		dev_err(component->dev, "dai %d not found in component\n",
-			RT5682S_AIF1);
-		return -ENODEV;
-	}
+			return rt5682s_set_bclk1_ratio(dai, factor);
 
-	return rt5682s_set_bclk1_ratio(dai, factor);
+	dev_err(component->dev, "dai %d not found in component\n",
+		RT5682S_AIF1);
+	return -ENODEV;
 }
 
 static const struct clk_ops rt5682s_dai_clk_ops[RT5682S_DAI_NUM_CLKS] = {


