Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8CE55D1FF
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243403AbiF1CTS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243362AbiF1CTB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:19:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3FD20BFE;
        Mon, 27 Jun 2022 19:18:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AE5B617C5;
        Tue, 28 Jun 2022 02:18:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5DD0C34115;
        Tue, 28 Jun 2022 02:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382738;
        bh=HrcPwdqzux1SSIv3OoIU5/I4Yj+Y6VDA1+xfrZ+URJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bLGYrKMeF3Fzwt5dez9cX/uL6ulqil7Ypk1Yjg5LKPwMrCtjyRc36QO1B6K59mfnu
         p1Q8BX6PjgwczcNDjAp4A6D+cc8PPqN1nSNjsQdIaMpfuCoGPFxB6/HJXaysD3M/Ly
         7Yb2XGPXKEQlOyVmxMtteTNr+7DicyvNTi6Bm4eNhYPtFt+QC3N33Hs8xpBdB53nEY
         xAzv2cNLQuercnFSxF2YrdfpV1Ysqd/jTe0UCU1ZxyPMa9+dBLgiGqT/elc1ZLo8+R
         qoX9C81LMGNl29bp1XzwTwsCZdMZatYpqrZTTa+JCPTvPjGTos8n4EfS1B5WUPAMnV
         XKRtDViANcGJA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.18 08/53] bus: bt1-axi: Don't print error on -EPROBE_DEFER
Date:   Mon, 27 Jun 2022 22:17:54 -0400
Message-Id: <20220628021839.594423-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628021839.594423-1-sashal@kernel.org>
References: <20220628021839.594423-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

[ Upstream commit 5e93207e962a6d23893ff4405f6c5d4396fb5934 ]

The Baikal-T1 AXI bus driver correctly handles the deferred probe
situation, but still pollutes the system log with a misleading error
message. Let's fix that by using the dev_err_probe() method to print the
log message in case of the clocks/resets request errors.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Link: https://lore.kernel.org/r/20220610104030.28399-2-Sergey.Semin@baikalelectronics.ru'
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/bt1-axi.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/bus/bt1-axi.c b/drivers/bus/bt1-axi.c
index e7a6744acc7b..70e49a6e5374 100644
--- a/drivers/bus/bt1-axi.c
+++ b/drivers/bus/bt1-axi.c
@@ -135,10 +135,9 @@ static int bt1_axi_request_rst(struct bt1_axi *axi)
 	int ret;
 
 	axi->arst = devm_reset_control_get_optional_exclusive(axi->dev, "arst");
-	if (IS_ERR(axi->arst)) {
-		dev_warn(axi->dev, "Couldn't get reset control line\n");
-		return PTR_ERR(axi->arst);
-	}
+	if (IS_ERR(axi->arst))
+		return dev_err_probe(axi->dev, PTR_ERR(axi->arst),
+				     "Couldn't get reset control line\n");
 
 	ret = reset_control_deassert(axi->arst);
 	if (ret)
@@ -159,10 +158,9 @@ static int bt1_axi_request_clk(struct bt1_axi *axi)
 	int ret;
 
 	axi->aclk = devm_clk_get(axi->dev, "aclk");
-	if (IS_ERR(axi->aclk)) {
-		dev_err(axi->dev, "Couldn't get AXI Interconnect clock\n");
-		return PTR_ERR(axi->aclk);
-	}
+	if (IS_ERR(axi->aclk))
+		return dev_err_probe(axi->dev, PTR_ERR(axi->aclk),
+				     "Couldn't get AXI Interconnect clock\n");
 
 	ret = clk_prepare_enable(axi->aclk);
 	if (ret) {
-- 
2.35.1

