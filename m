Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A82E38A981
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238806AbhETLDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:03:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:59276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232682AbhETLBD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:01:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B93C61355;
        Thu, 20 May 2021 10:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505014;
        bh=Z6UbPC3YaFr6xZOYx04oMx0zKfG+uYNupeNTenzyxoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HkXsznKl0xDwM7+qXVL2zaUvclf98NPdico/uHvDBtHpILajCyTF2s/XQj776905f
         pvyZKZ4BD+Zut8D8lBCRF57ig/B29iqO3j226iOu3KDkBr+J/SxGx8LXyFLh0Y8vKk
         2m2eaVbHVGbE0cJG9qG+v6aJuviEKlyBWnOPLsUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 150/240] i2c: cadence: add IRQ check
Date:   Thu, 20 May 2021 11:22:22 +0200
Message-Id: <20210520092113.684270469@linuxfoundation.org>
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

[ Upstream commit 5581c2c5d02bc63a0edb53e061c8e97cd490646e ]

The driver neglects to check the result of platform_get_irq()'s call and
blithely passes the negative error codes to devm_request_irq() (which
takes *unsigned* IRQ #), causing it to fail with -EINVAL, overriding
an original error code.  Stop calling devm_request_irq() with invalid
IRQ #s.

Fixes: df8eb5691c48 ("i2c: Add driver for Cadence I2C controller")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-cadence.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-cadence.c b/drivers/i2c/busses/i2c-cadence.c
index 45d6771fac8c..23ee1a423654 100644
--- a/drivers/i2c/busses/i2c-cadence.c
+++ b/drivers/i2c/busses/i2c-cadence.c
@@ -908,7 +908,10 @@ static int cdns_i2c_probe(struct platform_device *pdev)
 	if (IS_ERR(id->membase))
 		return PTR_ERR(id->membase);
 
-	id->irq = platform_get_irq(pdev, 0);
+	ret = platform_get_irq(pdev, 0);
+	if (ret < 0)
+		return ret;
+	id->irq = ret;
 
 	id->adap.owner = THIS_MODULE;
 	id->adap.dev.of_node = pdev->dev.of_node;
-- 
2.30.2



