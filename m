Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3757B501138
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 16:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241902AbiDNOFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347118AbiDNN63 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:58:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8EA9B7162;
        Thu, 14 Apr 2022 06:48:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 374DE61D73;
        Thu, 14 Apr 2022 13:48:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F8DEC385A9;
        Thu, 14 Apr 2022 13:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649944137;
        bh=+bi3CB0sKMUtiIkI6DbmdeWT1n5jF2lA8k1vBDqSFM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pIINmJoJ5KuniuVGI3WMEUPcEKt3ilKU54IFmkE4XCXhXtn7wc2PmBmToRwsu97/L
         F/tRjdrCjfpqxCZdyvv13Fv9Ti8/RklcVHAXmce4kNhcfzEovdCYV8pHZbHHFzDyF9
         o3m3/0d3uUARGDwfX06zQRJrREMQJFf8/hCusxuw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Wujek <dev_public@wujek.eu>,
        Robert Hancock <robert.hancock@calian.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 408/475] clk: si5341: fix reported clk_rate when output divider is 2
Date:   Thu, 14 Apr 2022 15:13:13 +0200
Message-Id: <20220414110906.482208290@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Wujek <dev_public@wujek.eu>

[ Upstream commit 2a8b539433e111c4de364237627ef219d2f6350a ]

SI5341_OUT_CFG_RDIV_FORCE2 shall be checked first to distinguish whether
a divider for a given output is set to 2 (SI5341_OUT_CFG_RDIV_FORCE2
is set) or the output is disabled (SI5341_OUT_CFG_RDIV_FORCE2 not set,
SI5341_OUT_R_REG is set 0).
Before the change, divider set to 2 (SI5341_OUT_R_REG set to 0) was
interpreted as output is disabled.

Signed-off-by: Adam Wujek <dev_public@wujek.eu>
Link: https://lore.kernel.org/r/20211203141125.2447520-1-dev_public@wujek.eu
Reviewed-by: Robert Hancock <robert.hancock@calian.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-si5341.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/clk/clk-si5341.c b/drivers/clk/clk-si5341.c
index 20ed0955416a..07ef9995b3cb 100644
--- a/drivers/clk/clk-si5341.c
+++ b/drivers/clk/clk-si5341.c
@@ -638,6 +638,15 @@ static unsigned long si5341_output_clk_recalc_rate(struct clk_hw *hw,
 	u32 r_divider;
 	u8 r[3];
 
+	err = regmap_read(output->data->regmap,
+			SI5341_OUT_CONFIG(output), &val);
+	if (err < 0)
+		return err;
+
+	/* If SI5341_OUT_CFG_RDIV_FORCE2 is set, r_divider is 2 */
+	if (val & SI5341_OUT_CFG_RDIV_FORCE2)
+		return parent_rate / 2;
+
 	err = regmap_bulk_read(output->data->regmap,
 			SI5341_OUT_R_REG(output), r, 3);
 	if (err < 0)
@@ -654,13 +663,6 @@ static unsigned long si5341_output_clk_recalc_rate(struct clk_hw *hw,
 	r_divider += 1;
 	r_divider <<= 1;
 
-	err = regmap_read(output->data->regmap,
-			SI5341_OUT_CONFIG(output), &val);
-	if (err < 0)
-		return err;
-
-	if (val & SI5341_OUT_CFG_RDIV_FORCE2)
-		r_divider = 2;
 
 	return parent_rate / r_divider;
 }
-- 
2.35.1



