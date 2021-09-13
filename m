Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 955E9408DF0
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242848AbhIMNam (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:30:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:34834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241299AbhIMNXs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:23:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25969610CB;
        Mon, 13 Sep 2021 13:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539285;
        bh=iOY7Mi7mIXGjAjDRAXnlIHKeuvyco5yoBW9Kg+Y2XbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YacdfeWazSI2UGK7TjMYWgutb2pi2rId+WYgc8EEysmErNnPTzbrzO6YqTIG4IO3C
         Dil1WFX5ONakDmxFRaAy6EgcddlxFIzBCUWq1uw3Z4IPvH6npJaKVetlNrLhB8NfsK
         22Ov3MAxK9fKFLZZTp9+KsIzpth/rXWFK2TUmVfg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Qii Wang <qii.wang@mediatek.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 111/144] i2c: mt65xx: fix IRQ check
Date:   Mon, 13 Sep 2021 15:14:52 +0200
Message-Id: <20210913131051.652091627@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
References: <20210913131047.974309396@linuxfoundation.org>
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
index e1ef0122ef75..5587e7c549c4 100644
--- a/drivers/i2c/busses/i2c-mt65xx.c
+++ b/drivers/i2c/busses/i2c-mt65xx.c
@@ -932,7 +932,7 @@ static int mtk_i2c_probe(struct platform_device *pdev)
 		return PTR_ERR(i2c->pdmabase);
 
 	irq = platform_get_irq(pdev, 0);
-	if (irq <= 0)
+	if (irq < 0)
 		return irq;
 
 	init_completion(&i2c->msg_complete);
-- 
2.30.2



