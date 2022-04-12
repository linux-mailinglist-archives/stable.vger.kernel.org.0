Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1380C4FD1A1
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350987AbiDLG7h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352548AbiDLG4A (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:56:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E26822519;
        Mon, 11 Apr 2022 23:46:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CA4CB81B43;
        Tue, 12 Apr 2022 06:46:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74CC2C385A1;
        Tue, 12 Apr 2022 06:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745958;
        bh=eyF2VnUNxOloLVIPfKJn9iNPrihstZvyrnDzYF9Nnbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tnwJtzl7UpDNFxdK0ns58nNC8EykBLeQ82cFzRgw2h5CHCY5ePjROegkfO0Q1zIKi
         GC9EtBRabrGKySU3U5/Y9nlp3g0JsdKaSy7d4nKxMUg3gP3dzhHktxYkfzV6JxHnRb
         d+x8sTjAI8hK6dUg8gT66YUgPZXkx3ZGuZw6D6E4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Wujek <dev_public@wujek.eu>,
        Robert Hancock <robert.hancock@calian.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 110/277] clk: si5341: fix reported clk_rate when output divider is 2
Date:   Tue, 12 Apr 2022 08:28:33 +0200
Message-Id: <20220412062945.223193810@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
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
index f7b41366666e..4de098b6b0d4 100644
--- a/drivers/clk/clk-si5341.c
+++ b/drivers/clk/clk-si5341.c
@@ -798,6 +798,15 @@ static unsigned long si5341_output_clk_recalc_rate(struct clk_hw *hw,
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
@@ -814,13 +823,6 @@ static unsigned long si5341_output_clk_recalc_rate(struct clk_hw *hw,
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



