Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCE194FD465
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353353AbiDLHds (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353561AbiDLHZq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:25:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BEFA25EA7;
        Tue, 12 Apr 2022 00:01:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C794DB81B35;
        Tue, 12 Apr 2022 07:01:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA59C385A6;
        Tue, 12 Apr 2022 07:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746882;
        bh=eyF2VnUNxOloLVIPfKJn9iNPrihstZvyrnDzYF9Nnbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HZsdwr8np/GYYJO4uQ9f2DJZ6t+pfD+AoCMijirN94XG7gL+w+cISNmAL3UgBl54s
         VYpYSmYjjx5RJEKkAqoXl8z+taqbLKBDx02mSKiLTPyb8ycK0FNTAEZy4CLuLhePOk
         SVAWet6tcFtRzoLQz/elHGeQXNAwWyHWKLGLsJqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Wujek <dev_public@wujek.eu>,
        Robert Hancock <robert.hancock@calian.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 114/285] clk: si5341: fix reported clk_rate when output divider is 2
Date:   Tue, 12 Apr 2022 08:29:31 +0200
Message-Id: <20220412062946.956613334@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
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



