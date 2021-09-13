Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFBF0409553
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345011AbhIMOkp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:40:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:57712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344907AbhIMOhm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:37:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A678619E3;
        Mon, 13 Sep 2021 13:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541278;
        bh=x/mROKq2joeZNE9BFEHNXlD9a+AN47SAkPAv5ayDKiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=odwEwnPAU/mDS4zVBPMd0tOdyqWZcRRv+w7dtoluCISmB2WYmwW0VxW1hJinZzl40
         ZMoxXcpsDRbQnuabiOuvkpL3mihMrf1jkm8Zb7Egltc9pHZx84wy9xsr51Y0aB8AZg
         ZXTKaT/f4wR+7zy+9d2xO+aqJUN7UtqrwgacgHIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 233/334] i2c: iop3xx: fix deferred probing
Date:   Mon, 13 Sep 2021 15:14:47 +0200
Message-Id: <20210913131121.299882056@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Shtylyov <s.shtylyov@omp.ru>

[ Upstream commit a1299505162ad00def3573260c2c68b9c8e8d697 ]

When adding the code to handle platform_get_irq*() errors in the commit
489447380a29 ("handle errors returned by platform_get_irq*()"), the
actual error code was enforced to be -ENXIO in the driver for some
strange reason.  This didn't matter much until the deferred probing was
introduced -- which requires an actual error code to be propagated
upstream from the failure site.

While fixing this, also stop overriding the errors from request_irq() to
-EIO (done since the pre-git era).

Fixes: 489447380a29 ("[PATCH] handle errors returned by platform_get_irq*()")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-iop3xx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-iop3xx.c b/drivers/i2c/busses/i2c-iop3xx.c
index cfecaf18ccbb..4a6ff54d87fe 100644
--- a/drivers/i2c/busses/i2c-iop3xx.c
+++ b/drivers/i2c/busses/i2c-iop3xx.c
@@ -469,16 +469,14 @@ iop3xx_i2c_probe(struct platform_device *pdev)
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
-		ret = -ENXIO;
+		ret = irq;
 		goto unmap;
 	}
 	ret = request_irq(irq, iop3xx_i2c_irq_handler, 0,
 				pdev->name, adapter_data);
 
-	if (ret) {
-		ret = -EIO;
+	if (ret)
 		goto unmap;
-	}
 
 	memcpy(new_adapter->name, pdev->name, strlen(pdev->name));
 	new_adapter->owner = THIS_MODULE;
-- 
2.30.2



