Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7000447FEDE
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbhL0PdT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:33:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237824AbhL0PdF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:33:05 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA1CBC061799;
        Mon, 27 Dec 2021 07:33:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 547E2CE10B6;
        Mon, 27 Dec 2021 15:33:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469E5C36AE7;
        Mon, 27 Dec 2021 15:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619181;
        bh=y86o3xk3ngnUTq8GOTtwJRgwiyBeHgAWyp3WdEb8XTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O/BwFaZy4WRAmz26exwWh3MfdOV+HdqDxp7CqzJr4v7ZLLxAUrNou7p/nj6Zl7iSv
         HPRSlbUqIUjSIt8mHyns5ZGekMT7/PlELh6Ku/337+xCIb9dHBwqX0pM5Ie+cC0Hle
         CkDU9wZdbyu6sQCCScAkmUAwZe5XWfNuJ5UYlyyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongliang Mu <mudongliangabcd@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 09/38] spi: change clk_disable_unprepare to clk_unprepare
Date:   Mon, 27 Dec 2021 16:30:46 +0100
Message-Id: <20211227151319.688381090@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151319.379265346@linuxfoundation.org>
References: <20211227151319.379265346@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

[ Upstream commit db6689b643d8653092f5853751ea2cdbc299f8d3 ]

The corresponding API for clk_prepare is clk_unprepare, other than
clk_disable_unprepare.

Fix this by changing clk_disable_unprepare to clk_unprepare.

Fixes: 5762ab71eb24 ("spi: Add support for Armada 3700 SPI Controller")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Link: https://lore.kernel.org/r/20211206101931.2816597-1-mudongliangabcd@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-armada-3700.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-armada-3700.c b/drivers/spi/spi-armada-3700.c
index 7dcb14d303eb4..d8715954f4e08 100644
--- a/drivers/spi/spi-armada-3700.c
+++ b/drivers/spi/spi-armada-3700.c
@@ -912,7 +912,7 @@ static int a3700_spi_probe(struct platform_device *pdev)
 	return 0;
 
 error_clk:
-	clk_disable_unprepare(spi->clk);
+	clk_unprepare(spi->clk);
 error:
 	spi_master_put(master);
 out:
-- 
2.34.1



