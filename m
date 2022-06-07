Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 220B7541591
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376744AbiFGUgm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378075AbiFGUet (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:34:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF55181443;
        Tue,  7 Jun 2022 11:37:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 481DD6156D;
        Tue,  7 Jun 2022 18:37:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E3B5C385A5;
        Tue,  7 Jun 2022 18:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627038;
        bh=MWvXMyoHOrEdCFlLY9mx2YvjDbiogfrSF1YvuFt01/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uN2rci62ii8oaLxRVIDY6SsWqGhHVjobry6yLNzY0uAv6lHJYl0WdRLceaVE+eYrc
         m2FTujUt5Ln2adkgKl+NSUpGDrPiLvVhNIKYanc37IL+aM6tCKG2s3LiYnjSMG7JJU
         BsXFhgXdQWK9OhPs5ugD6LeEVIeAVQ+bPDXlmuII=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 594/772] i2c: rcar: fix PM ref counts in probe error paths
Date:   Tue,  7 Jun 2022 19:03:06 +0200
Message-Id: <20220607165006.447141889@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit 3fe2ec59db1a7569e18594b9c0cf1f4f1afd498e ]

We have to take care of ID_P_PM_BLOCKED when bailing out during probe.

Fixes: 7ee24eb508d6 ("i2c: rcar: disable PM in multi-master mode")
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-rcar.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/i2c/busses/i2c-rcar.c b/drivers/i2c/busses/i2c-rcar.c
index f71c730f9838..995ecf5e4438 100644
--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -1062,8 +1062,10 @@ static int rcar_i2c_probe(struct platform_device *pdev)
 	pm_runtime_enable(dev);
 	pm_runtime_get_sync(dev);
 	ret = rcar_i2c_clock_calculate(priv);
-	if (ret < 0)
-		goto out_pm_put;
+	if (ret < 0) {
+		pm_runtime_put(dev);
+		goto out_pm_disable;
+	}
 
 	rcar_i2c_write(priv, ICSAR, 0); /* Gen2: must be 0 if not using slave */
 
@@ -1092,19 +1094,19 @@ static int rcar_i2c_probe(struct platform_device *pdev)
 
 	ret = platform_get_irq(pdev, 0);
 	if (ret < 0)
-		goto out_pm_disable;
+		goto out_pm_put;
 	priv->irq = ret;
 	ret = devm_request_irq(dev, priv->irq, irqhandler, irqflags, dev_name(dev), priv);
 	if (ret < 0) {
 		dev_err(dev, "cannot get irq %d\n", priv->irq);
-		goto out_pm_disable;
+		goto out_pm_put;
 	}
 
 	platform_set_drvdata(pdev, priv);
 
 	ret = i2c_add_numbered_adapter(adap);
 	if (ret < 0)
-		goto out_pm_disable;
+		goto out_pm_put;
 
 	if (priv->flags & ID_P_HOST_NOTIFY) {
 		priv->host_notify_client = i2c_new_slave_host_notify_device(adap);
@@ -1121,7 +1123,8 @@ static int rcar_i2c_probe(struct platform_device *pdev)
  out_del_device:
 	i2c_del_adapter(&priv->adap);
  out_pm_put:
-	pm_runtime_put(dev);
+	if (priv->flags & ID_P_PM_BLOCKED)
+		pm_runtime_put(dev);
  out_pm_disable:
 	pm_runtime_disable(dev);
 	return ret;
-- 
2.35.1



