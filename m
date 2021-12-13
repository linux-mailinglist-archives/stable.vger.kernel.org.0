Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2B24728A2
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239844AbhLMKOO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:14:14 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:46724 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbhLMJ6C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:58:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7E337CE0EB0;
        Mon, 13 Dec 2021 09:58:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6F8DC34601;
        Mon, 13 Dec 2021 09:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389478;
        bh=FVSTAyBrxX7NpEwaz60fIMFmPtl1OE063Icm1++nifY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xnf86kHZinE3pzWTczn3gmS80OMQKZdMJ2OirmTMoCDQZ8N7k+hgX3OsJ2ud4LrfV
         L2H/E1vieYyNuoHx7Tdxub2dkv8htP0Vt2QlOeOWNHQq4XqRbv4SrNSBweG/4RrfcX
         hK8xeOZ9bNnoKfHJu+uDc1Dww/aIFCOIXdXbRtkQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 108/171] ASoC: rt5682: Fix crash due to out of scope stack vars
Date:   Mon, 13 Dec 2021 10:30:23 +0100
Message-Id: <20211213092948.687985898@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Clark <robdclark@chromium.org>

commit 4999d703c0e66f9f196b6edc0b8fdeca8846b8b6 upstream.

Move the declaration of temporary arrays to somewhere that won't go out
of scope before the devm_clk_hw_register() call, lest we be at the whim
of the compiler for whether those stack variables get overwritten.

Fixes a crash seen with gcc version 11.2.1 20210728 (Red Hat 11.2.1-1)

Fixes: edbd24ea1e5c ("ASoC: rt5682: Drop usage of __clk_get_name()")
Signed-off-by: Rob Clark <robdclark@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20211118010453.843286-1-robdclark@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/rt5682.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/sound/soc/codecs/rt5682.c
+++ b/sound/soc/codecs/rt5682.c
@@ -2840,6 +2840,8 @@ static int rt5682_register_dai_clks(stru
 
 	for (i = 0; i < RT5682_DAI_NUM_CLKS; ++i) {
 		struct clk_init_data init = { };
+		struct clk_parent_data parent_data;
+		const struct clk_hw *parent;
 
 		dai_clk_hw = &rt5682->dai_clks_hw[i];
 
@@ -2847,17 +2849,17 @@ static int rt5682_register_dai_clks(stru
 		case RT5682_DAI_WCLK_IDX:
 			/* Make MCLK the parent of WCLK */
 			if (rt5682->mclk) {
-				init.parent_data = &(struct clk_parent_data){
+				parent_data = (struct clk_parent_data){
 					.fw_name = "mclk",
 				};
+				init.parent_data = &parent_data;
 				init.num_parents = 1;
 			}
 			break;
 		case RT5682_DAI_BCLK_IDX:
 			/* Make WCLK the parent of BCLK */
-			init.parent_hws = &(const struct clk_hw *){
-				&rt5682->dai_clks_hw[RT5682_DAI_WCLK_IDX]
-			};
+			parent = &rt5682->dai_clks_hw[RT5682_DAI_WCLK_IDX];
+			init.parent_hws = &parent;
 			init.num_parents = 1;
 			break;
 		default:


