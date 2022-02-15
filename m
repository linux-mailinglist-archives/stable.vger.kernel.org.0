Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB7F4B7153
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240585AbiBOPem (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 10:34:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240435AbiBOPdw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 10:33:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB633124C18;
        Tue, 15 Feb 2022 07:30:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6AE1CB8185B;
        Tue, 15 Feb 2022 15:30:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E2BC340EB;
        Tue, 15 Feb 2022 15:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644939025;
        bh=yuq7N6KXFH+m2wC+MZgvdB7GI5U4Ag5FX7Z/OFPQx8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z4nb+gYmForXbFbDuw5GRHKqCbyg9ZK24glTqiA8c3oO9qswvr+cmKbtuzkxmkUNr
         vcNNd/hD9HCHc1Va4pSc1DUzTDOVXtp8QK6upyYPi/RtmPTvSfxSsVv+O74I6ZX8c+
         LlcGU8afbO1iGN4dVi1zZWQHAKA+z9SVdGHKc3gF2WVydHd0q+vOpoUQd3cik/VkMv
         f6H3iNSmzm8Y4vEGjjxvvDD4Ot6eBNB5sxd6OFdJskURLHjty2SVTxojIf+faEkCgV
         5khOnTtT3QMkruh0BETNwNxMtLIkw7oDa62zMlnxnQ4lNtLKU1+KccAaHYWvwxj//P
         /ieATCodpb8JA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jae Hyun Yoo <jae.hyun.yoo@linux.intel.com>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Iwona Winiarska <iwona.winiarska@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>,
        chiawei_wang@aspeedtech.com, yangyingliang@huawei.com,
        linux-arm-kernel@lists.infradead.org, linux-aspeed@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.10 16/23] soc: aspeed: lpc-ctrl: Block error printing on probe defer cases
Date:   Tue, 15 Feb 2022 10:29:50 -0500
Message-Id: <20220215152957.581303-16-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215152957.581303-1-sashal@kernel.org>
References: <20220215152957.581303-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jae Hyun Yoo <jae.hyun.yoo@linux.intel.com>

[ Upstream commit 301a5d3ad2432d7829f59432ca0a93a6defbb9a1 ]

Add a checking code when it gets -EPROBE_DEFER while getting a clock
resource. In this case, it doesn't need to print out an error message
because the probing will be re-visited.

Signed-off-by: Jae Hyun Yoo <jae.hyun.yoo@linux.intel.com>
Signed-off-by: Joel Stanley <joel@jms.id.au>
Reviewed-by: Andrew Jeffery <andrew@aj.id.au>
Reviewed-by: Iwona Winiarska <iwona.winiarska@intel.com>
Link: https://lore.kernel.org/r/20211104173709.222912-1-jae.hyun.yoo@intel.com
Link: https://lore.kernel.org/r/20220201070118.196372-1-joel@jms.id.au'
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/aspeed/aspeed-lpc-ctrl.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/soc/aspeed/aspeed-lpc-ctrl.c b/drivers/soc/aspeed/aspeed-lpc-ctrl.c
index 040c7dc1d4792..71b555c715d2e 100644
--- a/drivers/soc/aspeed/aspeed-lpc-ctrl.c
+++ b/drivers/soc/aspeed/aspeed-lpc-ctrl.c
@@ -251,10 +251,9 @@ static int aspeed_lpc_ctrl_probe(struct platform_device *pdev)
 	}
 
 	lpc_ctrl->clk = devm_clk_get(dev, NULL);
-	if (IS_ERR(lpc_ctrl->clk)) {
-		dev_err(dev, "couldn't get clock\n");
-		return PTR_ERR(lpc_ctrl->clk);
-	}
+	if (IS_ERR(lpc_ctrl->clk))
+		return dev_err_probe(dev, PTR_ERR(lpc_ctrl->clk),
+				     "couldn't get clock\n");
 	rc = clk_prepare_enable(lpc_ctrl->clk);
 	if (rc) {
 		dev_err(dev, "couldn't enable clock\n");
-- 
2.34.1

