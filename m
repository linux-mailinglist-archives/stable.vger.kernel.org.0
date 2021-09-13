Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6894092C5
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344834AbhIMOP1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:15:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:35260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241738AbhIMOOC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:14:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF79C61AE1;
        Mon, 13 Sep 2021 13:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540597;
        bh=ZsoFKtjxaynejBnhMK7B8GZj+KDmchYI0AEwUrGLKUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YYvMi72D6iZZoU/OUjAx1oEdEwVmUnXOwanv71k0qXLpT9snc8dh8dIShxtz95mhy
         K+GboFBaxZ0UwTeLjsSlqoBulIecoXT436HPhQhp2L3+db3TMIA8fk3mEaM84xaZl3
         ft+4PbDl4BxusS26Hpa2/8ETKfmM+7YyzoczAnxs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Qii Wang <qii.wang@mediatek.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 231/300] i2c: mt65xx: fix IRQ check
Date:   Mon, 13 Sep 2021 15:14:52 +0200
Message-Id: <20210913131117.153861110@linuxfoundation.org>
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
index 4e9fb6b44436..d90d80d046bd 100644
--- a/drivers/i2c/busses/i2c-mt65xx.c
+++ b/drivers/i2c/busses/i2c-mt65xx.c
@@ -1211,7 +1211,7 @@ static int mtk_i2c_probe(struct platform_device *pdev)
 		return PTR_ERR(i2c->pdmabase);
 
 	irq = platform_get_irq(pdev, 0);
-	if (irq <= 0)
+	if (irq < 0)
 		return irq;
 
 	init_completion(&i2c->msg_complete);
-- 
2.30.2



