Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF3BE47266B
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235261AbhLMJvv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:51:51 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:38888 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236073AbhLMJtr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:49:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9C344CE0E6B;
        Mon, 13 Dec 2021 09:49:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49596C341CA;
        Mon, 13 Dec 2021 09:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388983;
        bh=xOV9z0AyIUabxqpnSHrReHYlmAhkaUmQJAmOew9aPCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HlKBd0IWxcl6G9QMjH55VbYKv/kOmru+yc4OTtd7iuG26QNoqjdJfUknELL550y68
         d1WvvZqYUTKKhOU20Wj2UOJNIY4vV3/0jWJzbjHOPkxf9vklLdAdEKQrUZRZ3WIIdm
         fz/99HNajgYHffV5nsT158DiGQoVecFOTKAQaTqY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 076/132] ASoC: rt5682: Fix crash due to out of scope stack vars
Date:   Mon, 13 Dec 2021 10:30:17 +0100
Message-Id: <20211213092941.726545845@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
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
@@ -2797,6 +2797,8 @@ static int rt5682_register_dai_clks(stru
 
 	for (i = 0; i < RT5682_DAI_NUM_CLKS; ++i) {
 		struct clk_init_data init = { };
+		struct clk_parent_data parent_data;
+		const struct clk_hw *parent;
 
 		dai_clk_hw = &rt5682->dai_clks_hw[i];
 
@@ -2804,17 +2806,17 @@ static int rt5682_register_dai_clks(stru
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


