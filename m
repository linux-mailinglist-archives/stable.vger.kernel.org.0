Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7469A5406F7
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346832AbiFGRlb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348010AbiFGRka (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:40:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B30145C87E;
        Tue,  7 Jun 2022 10:33:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 918CC614BC;
        Tue,  7 Jun 2022 17:33:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0A0C385A5;
        Tue,  7 Jun 2022 17:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623225;
        bh=6liBI5zJu26OZInGUvmtcme7fluxGacz4kc/ayEpB+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qDCYMZh0Kb5Vlv2dyJlLTIje5Im/WZMsH+CXZWbX/qAqOYtRwBldE0xOaH69kytXy
         R7ifFljYw0DXfpKTLrq2J5wDX5YjlrPIQNQeyHiOhka4o6J5hviE5LsOJawFn2xw3x
         StAj30SO8vw8ifcVqR35JKEwsKWYpYqPxRCX2ifA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 341/452] i2c: rcar: fix PM ref counts in probe error paths
Date:   Tue,  7 Jun 2022 19:03:18 +0200
Message-Id: <20220607164918.718474217@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
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
index 8722ca23f889..6a7a7a074a97 100644
--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -999,8 +999,10 @@ static int rcar_i2c_probe(struct platform_device *pdev)
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
 
@@ -1029,19 +1031,19 @@ static int rcar_i2c_probe(struct platform_device *pdev)
 
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
@@ -1058,7 +1060,8 @@ static int rcar_i2c_probe(struct platform_device *pdev)
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



