Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D874091C6
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245193AbhIMOFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:05:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:54738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244570AbhIMOCq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:02:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4B4D61A3B;
        Mon, 13 Sep 2021 13:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540306;
        bh=4AeE5WfbLORWsAT3jU2iIbCpPd29hPNC6tCN5hoShQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gI0qx9jZPA8sR4Ij+3+byHiwqtEIAfvJ0lMBT4BVsTN/olAii6gO2/IRR+vXdXV3+
         0MvaXXER/+MQTOMzBNCytvEEufWGh9/cXDBJOc7La/SqUBplg2tVRiS6PZ/iJu1PqG
         SRwTnBh3kqHU1wk2cwJTkhpmVicyOsstr8hTWO64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 139/300] i2c: highlander: add IRQ check
Date:   Mon, 13 Sep 2021 15:13:20 +0200
Message-Id: <20210913131114.098284331@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Shtylyov <s.shtylyov@omp.ru>

[ Upstream commit f16a3bb69aa6baabf8f0aca982c8cf21e2a4f6bc ]

The driver is written as if platform_get_irq() returns 0 on errors (while
actually it returns a negative error code), blithely passing these error
codes to request_irq() (which takes *unsigned* IRQ #) -- which fails with
-EINVAL. Add the necessary error check to the pre-existing *if* statement
forcing the driver into the polling mode...

Fixes: 4ad48e6ab18c ("i2c: Renesas Highlander FPGA SMBus support")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-highlander.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-highlander.c b/drivers/i2c/busses/i2c-highlander.c
index 803dad70e2a7..a2add128d084 100644
--- a/drivers/i2c/busses/i2c-highlander.c
+++ b/drivers/i2c/busses/i2c-highlander.c
@@ -379,7 +379,7 @@ static int highlander_i2c_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, dev);
 
 	dev->irq = platform_get_irq(pdev, 0);
-	if (iic_force_poll)
+	if (dev->irq < 0 || iic_force_poll)
 		dev->irq = 0;
 
 	if (dev->irq) {
-- 
2.30.2



