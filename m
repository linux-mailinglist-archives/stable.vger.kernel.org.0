Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 911D4683018
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 16:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbjAaPAJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 10:00:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232589AbjAaO76 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 09:59:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8691E1E1;
        Tue, 31 Jan 2023 06:59:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3E4A6155B;
        Tue, 31 Jan 2023 14:59:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 563B3C433D2;
        Tue, 31 Jan 2023 14:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675177194;
        bh=aOrXWbZZS9UgzCifRBScWp/Ew1uVkBCfNly7tzT8iAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UDzFq3eXvpQn4w7GA1lRSzgkK79FrVjTxuHwRMQNb+Az0vhl2M+ZSNWdCtXyQE9VI
         VjdzJSNhzuBUYGAqZfrLrAQCtMbvcNv9GSrRisr+DTDW6gSxI4ErQGSEZYLfU4IUNB
         6Xa1xye1vmI31c5OAcPwAoLsLMx2KgtgdQepCJGBB9kUf59gu4SQsqhmtFD2qc8fxT
         AKJBB5PgCBUlBp0qwAZw1y1nGvZd2gSyex6cTLC76hL+dO0+qwhZwN3b3wKi17xow7
         nydRdwavf3OeQ6fBcr6oMvmcUVFszhFrhXSrm0XtYIPylYCUBUip5Bl/cF4nz8TFmx
         n9aiwY4+a0oag==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefan Wahren <stefan.wahren@i2se.com>,
        Fabio Estevam <festevam@gmail.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        shawnguo@kernel.org, wsa+renesas@sang-engineering.com,
        linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.1 02/20] i2c: mxs: suppress probe-deferral error message
Date:   Tue, 31 Jan 2023 09:59:28 -0500
Message-Id: <20230131145946.1249850-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230131145946.1249850-1-sashal@kernel.org>
References: <20230131145946.1249850-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Wahren <stefan.wahren@i2se.com>

[ Upstream commit 78a4471fa1a76a8bef4919105de67660a89a1e9b ]

During boot of I2SE Duckbill the kernel log contains a
confusing error:

  Failed to request dma

This is caused by i2c-mxs tries to request a not yet available DMA
channel (-EPROBE_DEFER). So suppress this message by using
dev_err_probe().

Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-mxs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-mxs.c b/drivers/i2c/busses/i2c-mxs.c
index 5af5cffc444e..d113bed79545 100644
--- a/drivers/i2c/busses/i2c-mxs.c
+++ b/drivers/i2c/busses/i2c-mxs.c
@@ -826,8 +826,8 @@ static int mxs_i2c_probe(struct platform_device *pdev)
 	/* Setup the DMA */
 	i2c->dmach = dma_request_chan(dev, "rx-tx");
 	if (IS_ERR(i2c->dmach)) {
-		dev_err(dev, "Failed to request dma\n");
-		return PTR_ERR(i2c->dmach);
+		return dev_err_probe(dev, PTR_ERR(i2c->dmach),
+				     "Failed to request dma\n");
 	}
 
 	platform_set_drvdata(pdev, i2c);
-- 
2.39.0

