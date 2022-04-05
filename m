Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6292C4F280A
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232157AbiDEIKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235679AbiDEIAA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:00:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D37B193E8;
        Tue,  5 Apr 2022 00:57:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A22B615CD;
        Tue,  5 Apr 2022 07:57:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F88BC340EE;
        Tue,  5 Apr 2022 07:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145460;
        bh=9xEAKMpxGzf2culwYA+lPprUuDTBQpTKmsGMIu0d/v0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZUT/0MhVEsF1LSkoVR3YUQ2U2vbEXzGMefbLgvlY5W8LoEQp3PzviqkHFNxI2gzTc
         tMioP31PSvMay5FPtfX0R+WMOvm7By8Ujw0PSAj/3IoUarkZEe2nkPQJDiQtFWW1Um
         nBO9lO8aeFceZzaIR5In4haR0UhACy2dowcQVKxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0412/1126] mmc: davinci_mmc: Handle error for clk_enable
Date:   Tue,  5 Apr 2022 09:19:19 +0200
Message-Id: <20220405070419.719535298@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 09e7af76db02c74f2a339b3cb2d95460fa2ddbe4 ]

As the potential failure of the clk_enable(),
it should be better to check it and return error
if fails.

Fixes: bbce5802afc5 ("davinci: mmc: updates to suspend/resume implementation")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Link: https://lore.kernel.org/r/20220308071415.1093393-1-jiasheng@iscas.ac.cn
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/davinci_mmc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
index 2a757c88f9d2..80de660027d8 100644
--- a/drivers/mmc/host/davinci_mmc.c
+++ b/drivers/mmc/host/davinci_mmc.c
@@ -1375,8 +1375,12 @@ static int davinci_mmcsd_suspend(struct device *dev)
 static int davinci_mmcsd_resume(struct device *dev)
 {
 	struct mmc_davinci_host *host = dev_get_drvdata(dev);
+	int ret;
+
+	ret = clk_enable(host->clk);
+	if (ret)
+		return ret;
 
-	clk_enable(host->clk);
 	mmc_davinci_reset_ctrl(host, 0);
 
 	return 0;
-- 
2.34.1



