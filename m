Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C53438A983
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239307AbhETLDJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:03:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:59406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238805AbhETLBG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:01:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5EA161D0B;
        Thu, 20 May 2021 10:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505016;
        bh=AjGOqExW+quzqlpRH62MIZZf6FTJQ3uW+MLWMVs9zNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zz8HuAZ09Y5QcQs1a/NkeUerLh8lv51k8mfydJZY2IeskbJlUv/nJQ5o1/PtrRAYV
         t6CSUQR3FymAfPxuIrWBVRqwc6VJh4iRHhZ2niindLvG7loScYD8PCpfDZpFlq0Kur
         IQD15KeqHFm6RERC2N91zdl+K+ckKlOBPAy2BbGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 151/240] i2c: emev2: add IRQ check
Date:   Thu, 20 May 2021 11:22:23 +0200
Message-Id: <20210520092113.715678155@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
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
index 0218ba6eb26a..ad33c1e3a30f 100644
--- a/drivers/i2c/busses/i2c-emev2.c
+++ b/drivers/i2c/busses/i2c-emev2.c
@@ -398,7 +398,10 @@ static int em_i2c_probe(struct platform_device *pdev)
 
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



