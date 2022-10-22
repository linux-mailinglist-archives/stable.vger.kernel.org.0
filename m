Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 991F8608740
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232256AbiJVH6h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232277AbiJVH4z (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:56:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC5425B108;
        Sat, 22 Oct 2022 00:48:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 861DEB82E17;
        Sat, 22 Oct 2022 07:47:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B405BC433C1;
        Sat, 22 Oct 2022 07:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424863;
        bh=juEF15GNwvV1UwXjbjTX7qGN5uH7jvIijRl/WPZIT4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ve7dQ7sIUqHX948qp3RKXBk+e1F6fOSNMpEmz3zSuAQQOc6+fWezZsJif6mY+8IyY
         QY70ede0xTKdQcTe3RBfJMGuMERmj3j1qeLLiAPnM3k9YUI1xW4E7xit8cp25nXv4y
         elkfThQNbswyqu8ufDSjq0lUNqAWWv8rtVERWI2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 305/717] ASoC: mt6359: fix tests for platform_get_irq() failure
Date:   Sat, 22 Oct 2022 09:23:04 +0200
Message-Id: <20221022072506.706529547@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 51eea3a6fb4d39c2cc71824e6eee5949d7ae4d1c ]

The platform_get_irq() returns negative error codes.  It can't actually
return zero, but if it did that should be treated as success.

Fixes: eef07b9e0925 ("ASoC: mediatek: mt6359: add MT6359 accdet jack driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/YvThhr86N3qQM2EO@kili
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/mt6359-accdet.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/mt6359-accdet.c b/sound/soc/codecs/mt6359-accdet.c
index c190628e2905..7f624854948c 100644
--- a/sound/soc/codecs/mt6359-accdet.c
+++ b/sound/soc/codecs/mt6359-accdet.c
@@ -965,7 +965,7 @@ static int mt6359_accdet_probe(struct platform_device *pdev)
 	mutex_init(&priv->res_lock);
 
 	priv->accdet_irq = platform_get_irq(pdev, 0);
-	if (priv->accdet_irq) {
+	if (priv->accdet_irq >= 0) {
 		ret = devm_request_threaded_irq(&pdev->dev, priv->accdet_irq,
 						NULL, mt6359_accdet_irq,
 						IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
@@ -979,7 +979,7 @@ static int mt6359_accdet_probe(struct platform_device *pdev)
 
 	if (priv->caps & ACCDET_PMIC_EINT0) {
 		priv->accdet_eint0 = platform_get_irq(pdev, 1);
-		if (priv->accdet_eint0) {
+		if (priv->accdet_eint0 >= 0) {
 			ret = devm_request_threaded_irq(&pdev->dev,
 							priv->accdet_eint0,
 							NULL, mt6359_accdet_irq,
@@ -994,7 +994,7 @@ static int mt6359_accdet_probe(struct platform_device *pdev)
 		}
 	} else if (priv->caps & ACCDET_PMIC_EINT1) {
 		priv->accdet_eint1 = platform_get_irq(pdev, 2);
-		if (priv->accdet_eint1) {
+		if (priv->accdet_eint1 >= 0) {
 			ret = devm_request_threaded_irq(&pdev->dev,
 							priv->accdet_eint1,
 							NULL, mt6359_accdet_irq,
-- 
2.35.1



