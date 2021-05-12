Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CFB737CA3D
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbhELQ2E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:28:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:59022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234502AbhELQSx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:18:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00CB461D7F;
        Wed, 12 May 2021 15:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834320;
        bh=zc8zZmSbGv0fbHbctOE8oi5ff/COuMFjxNliAZb7iaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0KZvJsPZg+2SuRL8DdmrA4rXMu6iIPOk1sXDfFbMGU4msOrDUS8B1T97t9RCRPwJW
         YgSAWuZlDOHxHtKfDs+vY/8y+vErs91qVi9NwkRO/VZiGPya3x9k1ffwwzHcmZYWpc
         w10oPw9v1jxpbRPq3d6ZejXTMYr3Z+CXkl/2vDVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 498/601] i2c: jz4780: add IRQ check
Date:   Wed, 12 May 2021 16:49:35 +0200
Message-Id: <20210512144844.238947003@linuxfoundation.org>
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

[ Upstream commit c5e5f7a8d931fb4beba245bdbc94734175fda9de ]

The driver neglects to check the result of platform_get_irq()'s call and
blithely passes the negative error codes to devm_request_irq() (which
takes *unsigned* IRQ #), causing it to fail with -EINVAL, overriding
an original error code.  Stop calling devm_request_irq() with invalid
IRQ #s.

Fixes: ba92222ed63a ("i2c: jz4780: Add i2c bus controller driver for Ingenic JZ4780")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-jz4780.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-jz4780.c b/drivers/i2c/busses/i2c-jz4780.c
index 2a946c207928..e181db3fd2cc 100644
--- a/drivers/i2c/busses/i2c-jz4780.c
+++ b/drivers/i2c/busses/i2c-jz4780.c
@@ -826,7 +826,10 @@ static int jz4780_i2c_probe(struct platform_device *pdev)
 
 	jz4780_i2c_writew(i2c, JZ4780_I2C_INTM, 0x0);
 
-	i2c->irq = platform_get_irq(pdev, 0);
+	ret = platform_get_irq(pdev, 0);
+	if (ret < 0)
+		goto err;
+	i2c->irq = ret;
 	ret = devm_request_irq(&pdev->dev, i2c->irq, jz4780_i2c_irq, 0,
 			       dev_name(&pdev->dev), i2c);
 	if (ret)
-- 
2.30.2



