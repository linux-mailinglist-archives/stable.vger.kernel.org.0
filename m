Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D37A594285
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346365AbiHOVvy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350218AbiHOVuw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:50:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF530DEB57;
        Mon, 15 Aug 2022 12:32:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76B89B81126;
        Mon, 15 Aug 2022 19:32:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC52AC433C1;
        Mon, 15 Aug 2022 19:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591939;
        bh=Sl8pAt6Q0dhidSZAmwSvNFkkV5IgZon/SaDP+uWCIr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JF4CRkpFMQRi/6zirq/w9cGhy/l40AIDNwNerQsxoCInHzvBVfgOnJTvSJZcLTSRZ
         5EUzPaZA6D0GuXhGhgU5L1eNBHMQ0PajVIcu94ALiqMD+XRujtJMpY38nLGDbMJE0n
         TKjUAa56W9uxo3EaH0SqlLGYe80WlErgFaC7fwDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Marko <robimarko@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0707/1095] clk: qcom: ipq8074: SW workaround for UBI32 PLL lock
Date:   Mon, 15 Aug 2022 20:01:46 +0200
Message-Id: <20220815180458.639328837@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Robert Marko <robimarko@gmail.com>

[ Upstream commit 3401ea2856ef84f39b75f0dc5ebcaeda81cb90ec ]

UBI32 Huayra PLL fails to lock in 5 us in some SoC silicon and thus it
will cause the wait_for_pll() to timeout and thus return the error
indicating that the PLL failed to lock.

This is bug in Huayra PLL HW for which SW workaround
is to set bit 26 of TEST_CTL register.

This is ported from the QCA 5.4 based downstream kernel.

Fixes: b8e7e519625f ("clk: qcom: ipq8074: add remaining PLL’s")
Signed-off-by: Robert Marko <robimarko@gmail.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220515210048.483898-2-robimarko@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-ipq8074.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clk/qcom/gcc-ipq8074.c b/drivers/clk/qcom/gcc-ipq8074.c
index 1a5141da7e23..b4291ba53c78 100644
--- a/drivers/clk/qcom/gcc-ipq8074.c
+++ b/drivers/clk/qcom/gcc-ipq8074.c
@@ -4805,6 +4805,9 @@ static int gcc_ipq8074_probe(struct platform_device *pdev)
 	if (IS_ERR(regmap))
 		return PTR_ERR(regmap);
 
+	/* SW Workaround for UBI32 Huayra PLL */
+	regmap_update_bits(regmap, 0x2501c, BIT(26), BIT(26));
+
 	clk_alpha_pll_configure(&ubi32_pll_main, regmap, &ubi32_pll_config);
 	clk_alpha_pll_configure(&nss_crypto_pll_main, regmap,
 				&nss_crypto_pll_config);
-- 
2.35.1



