Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72905411D63
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346770AbhITRTH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:19:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:42212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348123AbhITRRH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:17:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03A2F619F8;
        Mon, 20 Sep 2021 16:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157159;
        bh=WqAwgBkVR7Gfqe6M+0qPUQ5lsZJYBe2IY8rsNf5tUOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m8xDfK3cAZ7sA19u03lss6L58+tZht1Or6OHg/KBMgKKrmRoTEqXeaULp9Xs83YNn
         3qE7x7oLP3q/6vqk3nUnCCaC9KXF1xdbmIOz5OE5Ph1ENWqtaBWUQQr/HhypLRJr2H
         yItZSK3FE8lpGo4UbE2QLYr6mxglib0eqr01YPSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Qii Wang <qii.wang@mediatek.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 081/217] i2c: mt65xx: fix IRQ check
Date:   Mon, 20 Sep 2021 18:41:42 +0200
Message-Id: <20210920163927.373552582@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Shtylyov <s.shtylyov@omp.ru>

[ Upstream commit 58fb7c643d346e2364404554f531cfa6a1a3917c ]

Iff platform_get_irq() returns 0, the driver's probe() method will return 0
early (as if the method's call was successful).  Let's consider IRQ0 valid
for simplicity -- devm_request_irq() can always override that decision...

Fixes: ce38815d39ea ("I2C: mediatek: Add driver for MediaTek I2C controller")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>
Reviewed-by: Qii Wang <qii.wang@mediatek.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-mt65xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-mt65xx.c b/drivers/i2c/busses/i2c-mt65xx.c
index 09d288ce0ddb..cbcf76ea9c19 100644
--- a/drivers/i2c/busses/i2c-mt65xx.c
+++ b/drivers/i2c/busses/i2c-mt65xx.c
@@ -740,7 +740,7 @@ static int mtk_i2c_probe(struct platform_device *pdev)
 		return PTR_ERR(i2c->pdmabase);
 
 	irq = platform_get_irq(pdev, 0);
-	if (irq <= 0)
+	if (irq < 0)
 		return irq;
 
 	init_completion(&i2c->msg_complete);
-- 
2.30.2



