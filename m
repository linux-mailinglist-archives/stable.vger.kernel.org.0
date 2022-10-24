Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5F060B26F
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbiJXQqv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234942AbiJXQpj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:45:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9266380BEC;
        Mon, 24 Oct 2022 08:31:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E9D5B8197B;
        Mon, 24 Oct 2022 12:41:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94AD9C433C1;
        Mon, 24 Oct 2022 12:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615271;
        bh=qfRkPOfBXEFDRbBTB/Q/Jpv5q9piXIqG1CnSctn/W4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f/IwYPVIQJfcw1mBd6r7wA+Us9pT3d06Ah2GIBH8IufqIZWx1TWGzqqKHNsa8ZC8U
         OPimbSPTx4iY51pSt/DjPMK4BJAIC3cA49Jgsf1Makc7F3OabzUUeXVC7EJTa4/Xnk
         zGls5LKx0wM7vk6vzggOJgYy9uabgL97VeIeD+Nk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 187/530] spi/omap100k:Fix PM disable depth imbalance in omap1_spi100k_probe
Date:   Mon, 24 Oct 2022 13:28:51 +0200
Message-Id: <20221024113053.503111192@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 29f65f2171c85a9633daa380df14009a365f42f2 ]

The pm_runtime_enable will increase power disable depth. Thus
a pairing decrement is needed on the error handling path to
keep it balanced according to context.

Fixes:db91841b58f9a ("spi/omap100k: Convert to runtime PM")

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20220924121310.78331-4-zhangqilong3@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-omap-100k.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-omap-100k.c b/drivers/spi/spi-omap-100k.c
index 20b047172965..061f7394e5b9 100644
--- a/drivers/spi/spi-omap-100k.c
+++ b/drivers/spi/spi-omap-100k.c
@@ -412,6 +412,7 @@ static int omap1_spi100k_probe(struct platform_device *pdev)
 	return status;
 
 err_fck:
+	pm_runtime_disable(&pdev->dev);
 	clk_disable_unprepare(spi100k->fck);
 err_ick:
 	clk_disable_unprepare(spi100k->ick);
-- 
2.35.1



