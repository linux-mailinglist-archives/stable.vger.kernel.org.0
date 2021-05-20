Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A782E38A440
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235125AbhETKCY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:02:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234672AbhETKAW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:00:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC3206141E;
        Thu, 20 May 2021 09:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503544;
        bh=os3IdbjtmowGQlAp1NLTz3BkNBLLRVYjWB6eNY2ukH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xh0UKHLuG7HE0Okpt+vOiqpG5mO/jZJDRfYeMmZEQHOSwnM1DC7mxxhpceHp1v3O6
         DVPQMZiPx6ARhKhhj4Ip8A31cD3bA6vnc37aI6Y5UGaW2sO3W3KNrzka4+DR1ZAWkf
         9QIgXk5IgJTf3hNlQER2kFuE8WYbljPqS6cdNugE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 270/425] i2c: sh7760: add IRQ check
Date:   Thu, 20 May 2021 11:20:39 +0200
Message-Id: <20210520092140.316154444@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Shtylyov <s.shtylyov@omprussia.ru>

[ Upstream commit e5b2e3e742015dd2aa6bc7bcef2cb59b2de1221c ]

The driver neglects to check the result of platform_get_irq()'s call and
blithely passes the negative error codes to devm_request_irq() (which
takes *unsigned* IRQ #), causing it to fail with -EINVAL, overriding
an original error code.  Stop calling devm_request_irq() with invalid
IRQ #s.

Fixes: a26c20b1fa6d ("i2c: Renesas SH7760 I2C master driver")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-sh7760.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-sh7760.c b/drivers/i2c/busses/i2c-sh7760.c
index c2005c789d2b..c79c9f542c5a 100644
--- a/drivers/i2c/busses/i2c-sh7760.c
+++ b/drivers/i2c/busses/i2c-sh7760.c
@@ -471,7 +471,10 @@ static int sh7760_i2c_probe(struct platform_device *pdev)
 		goto out2;
 	}
 
-	id->irq = platform_get_irq(pdev, 0);
+	ret = platform_get_irq(pdev, 0);
+	if (ret < 0)
+		return ret;
+	id->irq = ret;
 
 	id->adap.nr = pdev->id;
 	id->adap.algo = &sh7760_i2c_algo;
-- 
2.30.2



