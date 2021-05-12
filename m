Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D55437CA0D
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237116AbhELQYQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:24:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:59020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240702AbhELQSw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:18:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D89F61D82;
        Wed, 12 May 2021 15:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834318;
        bh=qhp8UxIizMNAxqsyug1Q2e9MLRrjNztI+6JTKsnSaYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y0Fe2wdp3EEbbT2YD60lidWi5URk5hx4aLeHCv29jTZK7lZSyNLHrqcBBbJ3hptyl
         MTkLshgMHsVzZLZn3NGMSaMHOleyyaI6H9z3YuZMYjwsnD8IduQGxkUfOPKPsEll7h
         nwJ0VJkETah3oCHf6MiTI44NDAD0dqQ1zGe+pSQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 497/601] i2c: emev2: add IRQ check
Date:   Wed, 12 May 2021 16:49:34 +0200
Message-Id: <20210512144844.206587549@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
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



