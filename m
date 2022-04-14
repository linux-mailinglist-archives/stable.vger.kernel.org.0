Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB145014E2
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244383AbiDNNdy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245045AbiDNN21 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:28:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6FE099ECC;
        Thu, 14 Apr 2022 06:21:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41A0FB82989;
        Thu, 14 Apr 2022 13:21:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8668BC385A1;
        Thu, 14 Apr 2022 13:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942490;
        bh=0cwtickP+NgWw+WWecWdYHUHie0YObIM9I8XHcGackM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q6E3huqoPXHzeA6xEO1H4pWDEWGDg2h37gxMMAlGJSveWAcNUw/wHvzuD7vkaOCa4
         TKRzJ9nY4Yt2eJq6kgXXMvNUHLJLuPkisPYYvgOmkG9c1wpd1LGhyE2MvCR03Lo6q1
         Jad78UxpVBHT+QAp0fvpQOHygYWLJwisWLD5h6Q8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 114/338] mmc: davinci_mmc: Handle error for clk_enable
Date:   Thu, 14 Apr 2022 15:10:17 +0200
Message-Id: <20220414110842.152990433@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
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
index e6f14257a7d0..70d04962f53a 100644
--- a/drivers/mmc/host/davinci_mmc.c
+++ b/drivers/mmc/host/davinci_mmc.c
@@ -1389,8 +1389,12 @@ static int davinci_mmcsd_suspend(struct device *dev)
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



