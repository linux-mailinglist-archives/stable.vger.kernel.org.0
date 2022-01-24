Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D970849A25C
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 02:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365696AbiAXXva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:51:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1836973AbiAXWla (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:41:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A78C04D625;
        Mon, 24 Jan 2022 13:04:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 756AFB812A8;
        Mon, 24 Jan 2022 21:04:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94027C340E5;
        Mon, 24 Jan 2022 21:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058263;
        bh=KzpJCoQ7YeJ8gsCUsWa3i1sfOZTwvJHTEKYvDdhXVmg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g4x0xfJRVbfv+VZ174qsxj+/ptzMa0rqry+z3dNg3QI9Xm35NrtnmtZyipQVUC1bC
         4zlGJso/B92AnZLG/raux3EePBFFn5gZ/P/KlqEcmKZZRmkqcSdnyHTc15qvXD1iGk
         CPkkfMsuCtR9IbtT0JHl4s/3X/oMx5FOcRyj//Xk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0199/1039] net: lantiq: fix missing free_netdev() on error in ltq_etop_probe()
Date:   Mon, 24 Jan 2022 19:33:08 +0100
Message-Id: <20220124184132.013656393@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 2680ce7fc9939221da16e86a2e73cc1df563c82c ]

Add the missing free_netdev() before return from ltq_etop_probe()
in the error handling case.

Fixes: 14d4e308e0aa ("net: lantiq: configure the burst length in ethernet drivers")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/lantiq_etop.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/lantiq_etop.c b/drivers/net/ethernet/lantiq_etop.c
index 072391c494ce4..14059e11710ad 100644
--- a/drivers/net/ethernet/lantiq_etop.c
+++ b/drivers/net/ethernet/lantiq_etop.c
@@ -687,13 +687,13 @@ ltq_etop_probe(struct platform_device *pdev)
 	err = device_property_read_u32(&pdev->dev, "lantiq,tx-burst-length", &priv->tx_burst_len);
 	if (err < 0) {
 		dev_err(&pdev->dev, "unable to read tx-burst-length property\n");
-		return err;
+		goto err_free;
 	}
 
 	err = device_property_read_u32(&pdev->dev, "lantiq,rx-burst-length", &priv->rx_burst_len);
 	if (err < 0) {
 		dev_err(&pdev->dev, "unable to read rx-burst-length property\n");
-		return err;
+		goto err_free;
 	}
 
 	for (i = 0; i < MAX_DMA_CHAN; i++) {
-- 
2.34.1



