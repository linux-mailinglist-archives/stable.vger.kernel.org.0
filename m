Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8957740955A
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345333AbhIMOkx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:40:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344253AbhIMOiL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:38:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA31E6112E;
        Mon, 13 Sep 2021 13:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541283;
        bh=ZJe7jnB1GWaJqSwLnCr04Nl2/MgqFHUp/pe6OZWi7sk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nUh3Ff1XMbGor8AiYdb/ueCqEoi/zkcPHIUojx2a+mbVGCCgHK07ShTrclOY3Tja3
         02v3cX7Xzi3EJuvBqM/F987vtXhsPoljNdOWHkT4RKh9EXCcHMKig8wY2kax7Zn7Vl
         PAK4SoGaJAqD9vJo13TcsnMNwCg5ewGotOY+xYrM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 235/334] i2c: hix5hd2: fix IRQ check
Date:   Mon, 13 Sep 2021 15:14:49 +0200
Message-Id: <20210913131121.362071914@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Shtylyov <s.shtylyov@omp.ru>

[ Upstream commit f9b459c2ba5edfe247e86b45ad5dea8da542f3ea ]

Iff platform_get_irq() returns 0, the driver's probe() method will return 0
early (as if the method's call was successful).  Let's consider IRQ0 valid
for simplicity -- devm_request_irq() can always override that decision...

Fixes: 15ef27756b23 ("i2c: hix5hd2: add i2c controller driver")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-hix5hd2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-hix5hd2.c b/drivers/i2c/busses/i2c-hix5hd2.c
index aa00ba8bcb70..61ae58f57047 100644
--- a/drivers/i2c/busses/i2c-hix5hd2.c
+++ b/drivers/i2c/busses/i2c-hix5hd2.c
@@ -413,7 +413,7 @@ static int hix5hd2_i2c_probe(struct platform_device *pdev)
 		return PTR_ERR(priv->regs);
 
 	irq = platform_get_irq(pdev, 0);
-	if (irq <= 0)
+	if (irq < 0)
 		return irq;
 
 	priv->clk = devm_clk_get(&pdev->dev, NULL);
-- 
2.30.2



