Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35B84408FCA
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243312AbhIMNqn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:46:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:51540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243610AbhIMNok (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:44:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F347161502;
        Mon, 13 Sep 2021 13:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539867;
        bh=lnBHHFRuLJzQHrYQ4bLpSlqqObR463nOfp12ypBvfNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ctL4YRYYzjD3vOSV46pkGRaR+67h+Fcnp4FbsBJmmYRldbAL4TgQbrOWEeZXhewHa
         ceaRkc/B5vbFMwBvOHR5p582/6eDx15smJ1X6truMy1iVlwCEAaqZAqZ4cLHMqpRqg
         0154Cfv+D2Nm6mZZPFBZdrh73Yom8ywWIScXdyog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omp.ru>,
        George Cherian <george.cherian@marvell.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 192/236] i2c: xlp9xx: fix main IRQ check
Date:   Mon, 13 Sep 2021 15:14:57 +0200
Message-Id: <20210913131106.918247647@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Shtylyov <s.shtylyov@omp.ru>

[ Upstream commit 661e8a88e8317eb9ffe69c69d6cb4876370fe7e2 ]

Iff platform_get_irq() returns 0 for the main IRQ, the driver's probe()
method will return 0 early (as if the method's call was successful).
Let's consider IRQ0 valid for simplicity -- devm_request_irq() can always
override that decision...

Fixes: 2bbd681ba2b ("i2c: xlp9xx: Driver for Netlogic XLP9XX/5XX I2C controller")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Reviewed-by: George Cherian <george.cherian@marvell.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-xlp9xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-xlp9xx.c b/drivers/i2c/busses/i2c-xlp9xx.c
index f2241cedf5d3..6d24dc385522 100644
--- a/drivers/i2c/busses/i2c-xlp9xx.c
+++ b/drivers/i2c/busses/i2c-xlp9xx.c
@@ -517,7 +517,7 @@ static int xlp9xx_i2c_probe(struct platform_device *pdev)
 		return PTR_ERR(priv->base);
 
 	priv->irq = platform_get_irq(pdev, 0);
-	if (priv->irq <= 0)
+	if (priv->irq < 0)
 		return priv->irq;
 	/* SMBAlert irq */
 	priv->alert_data.irq = platform_get_irq(pdev, 1);
-- 
2.30.2



