Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E70060A711
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232193AbiJXMrx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:47:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234284AbiJXMoH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:44:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA03A7EFCF;
        Mon, 24 Oct 2022 05:09:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0373461259;
        Mon, 24 Oct 2022 11:57:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 191F8C433D6;
        Mon, 24 Oct 2022 11:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612669;
        bh=brYtHU42pdCzx+EVdOKsAMZy1gp+KJ7GwY6PpsFheis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L/HhGeQR/5Lajsc4pQjxpeM4uCE5eGpzWpMpIdmDYUKy69M5Rn1+LgLVNyywu1j5u
         r8iWWd4nS5kjF4YirfFi/Rs4flqFaUgYZVVvoHDW6LV/LkH4MbqgY1dqt65/eP5+Zd
         bjojZ3pK8Kkk3EoxgeZcB/SlQFOE72PLvzSGdi8o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 074/229] spi: mt7621: Fix an error message in mt7621_spi_probe()
Date:   Mon, 24 Oct 2022 13:29:53 +0200
Message-Id: <20221024113001.469797349@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 2b2bf6b7faa9010fae10dc7de76627a3fdb525b3 ]

'status' is known to be 0 at this point. The expected error code is
PTR_ERR(clk).

Switch to dev_err_probe() in order to display the expected error code (in a
human readable way).
This also filters -EPROBE_DEFER cases, should it happen.

Fixes: 1ab7f2a43558 ("staging: mt7621-spi: add mt7621 support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Link: https://lore.kernel.org/r/928f3fb507d53ba0774df27cea0bbba4b055993b.1661599671.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/mt7621-spi/spi-mt7621.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/mt7621-spi/spi-mt7621.c b/drivers/staging/mt7621-spi/spi-mt7621.c
index 75ed48f60c8c..b73823830e3a 100644
--- a/drivers/staging/mt7621-spi/spi-mt7621.c
+++ b/drivers/staging/mt7621-spi/spi-mt7621.c
@@ -442,11 +442,9 @@ static int mt7621_spi_probe(struct platform_device *pdev)
 		return PTR_ERR(base);
 
 	clk = devm_clk_get(&pdev->dev, NULL);
-	if (IS_ERR(clk)) {
-		dev_err(&pdev->dev, "unable to get SYS clock, err=%d\n",
-			status);
-		return PTR_ERR(clk);
-	}
+	if (IS_ERR(clk))
+		return dev_err_probe(&pdev->dev, PTR_ERR(clk),
+				     "unable to get SYS clock\n");
 
 	status = clk_prepare_enable(clk);
 	if (status)
-- 
2.35.1



