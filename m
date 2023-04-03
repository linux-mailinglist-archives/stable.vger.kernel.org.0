Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A07CB6D498A
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233731AbjDCOiu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233714AbjDCOit (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:38:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 860306A5E
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:38:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FA1661EB7
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:38:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38FC0C433EF;
        Mon,  3 Apr 2023 14:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532727;
        bh=O61t+1YL3XxxO/y3OMHk0ny13zEfWQt8Tnh5ByxMsXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lx4GKli50cApKw2a9Ithqn9vDLacAQBaNz//Rj4Apispqfc46qowvkhF6C0RXuIii
         Ct/mxcMLxkCybQb/CZpCORL5GdAXfAYc0FFGz6l5IKKFFXpAcwn7H7ynW/KBqL09WQ
         qWnLzZ959Ojo9sI6gF1MsILrmR79NXLTkVriwoN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 094/181] regulator: Handle deferred clk
Date:   Mon,  3 Apr 2023 16:08:49 +0200
Message-Id: <20230403140418.165019450@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 02bcba0b9f9da706d5bd1e8cbeb83493863e17b5 ]

devm_clk_get() can return -EPROBE_DEFER. So it is better to return the
error code from devm_clk_get(), instead of a hard coded -ENOENT.

This gives more opportunities to successfully probe the driver.

Fixes: 8959e5324485 ("regulator: fixed: add possibility to enable by clock")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/18459fae3d017a66313699c7c8456b28158b2dd0.1679819354.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/fixed.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 2a9867abba20c..e6724a229d237 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -215,7 +215,7 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
 		drvdata->enable_clock = devm_clk_get(dev, NULL);
 		if (IS_ERR(drvdata->enable_clock)) {
 			dev_err(dev, "Can't get enable-clock from devicetree\n");
-			return -ENOENT;
+			return PTR_ERR(drvdata->enable_clock);
 		}
 	} else if (drvtype && drvtype->has_performance_state) {
 		drvdata->desc.ops = &fixed_voltage_domain_ops;
-- 
2.39.2



