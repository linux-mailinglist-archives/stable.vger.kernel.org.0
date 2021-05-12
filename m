Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62E3E37CE7B
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343534AbhELRFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:05:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233830AbhELQoK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:44:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34BFC61D56;
        Wed, 12 May 2021 16:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836056;
        bh=qhp8UxIizMNAxqsyug1Q2e9MLRrjNztI+6JTKsnSaYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CoqgOuEWywJ/pUVdzjPrTKn+yuA3/NO6iwYf4h0cH1MmcnxekcWAaoAuzX0KLRy1L
         0Q/XJas9b9+m9ma82tuMRA96zen5VDk1a/uO5PU4arduwNf3yuVcG3CI5AmV0aNDFw
         eKvFGDuQ+KesJGKuz5e71fT7w2GseUBEG+Yh4V1Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 565/677] i2c: emev2: add IRQ check
Date:   Wed, 12 May 2021 16:50:11 +0200
Message-Id: <20210512144856.173548495@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Shtylyov <s.shtylyov@omprussia.ru>

[ Upstream commit bb6129c32867baa7988f7fd2066cf18ed662d240 ]

The driver neglects to check the result of platform_get_irq()'s call and
blithely passes the negative error codes to devm_request_irq() (which
takes *unsigned* IRQ #), causing it to fail with -EINVAL, overriding
an original error code.  Stop calling devm_request_irq() with invalid
IRQ #s.

Fixes: 5faf6e1f58b4 ("i2c: emev2: add driver")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-emev2.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-emev2.c b/drivers/i2c/busses/i2c-emev2.c
index a08554c1a570..bdff0e6345d9 100644
--- a/drivers/i2c/busses/i2c-emev2.c
+++ b/drivers/i2c/busses/i2c-emev2.c
@@ -395,7 +395,10 @@ static int em_i2c_probe(struct platform_device *pdev)
 
 	em_i2c_reset(&priv->adap);
 
-	priv->irq = platform_get_irq(pdev, 0);
+	ret = platform_get_irq(pdev, 0);
+	if (ret < 0)
+		goto err_clk;
+	priv->irq = ret;
 	ret = devm_request_irq(&pdev->dev, priv->irq, em_i2c_irq_handler, 0,
 				"em_i2c", priv);
 	if (ret)
-- 
2.30.2



