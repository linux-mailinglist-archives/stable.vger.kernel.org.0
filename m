Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6B4D6086CB
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbiJVHxd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231754AbiJVHwE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:52:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6A612C2AEA;
        Sat, 22 Oct 2022 00:46:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E268660BA2;
        Sat, 22 Oct 2022 07:43:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015B9C433C1;
        Sat, 22 Oct 2022 07:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424619;
        bh=KTZcokemeTem35PNMjBQHPCVWK2pq04hPNhpZ0yUFtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WdLAHb0xQZYfsAoJjnn+P94E+HckkTYwP3kznLgyCFKg/DLsHHCvfWjiTcNT+s43g
         7LgnBoSGzPn+jg7cenRdUZZbw4A8F5c4MP49hF0hvytpXR9WkUwW47QDlKolzDC73q
         ooYgAdAc6R3zPOCEgBrLZKH9jzBIGJtB4hfVutJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 214/717] spi: mt7621: Fix an error message in mt7621_spi_probe()
Date:   Sat, 22 Oct 2022 09:21:33 +0200
Message-Id: <20221022072453.129048558@linuxfoundation.org>
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
 drivers/spi/spi-mt7621.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi-mt7621.c b/drivers/spi/spi-mt7621.c
index b4b9b7309b5e..351b0ef52bbc 100644
--- a/drivers/spi/spi-mt7621.c
+++ b/drivers/spi/spi-mt7621.c
@@ -340,11 +340,9 @@ static int mt7621_spi_probe(struct platform_device *pdev)
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



