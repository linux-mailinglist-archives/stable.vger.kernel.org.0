Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A860409535
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346246AbhIMOjD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:39:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:55800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345349AbhIMOhB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:37:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6702861BF3;
        Mon, 13 Sep 2021 13:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541252;
        bh=dsms3c+evS3RID/JnKvL64KwUkp1O7wh9aJlk/eaKuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vMONo71ycAZwt3u5E5O/zgLHsWSEudfQxj77AfOcO69caEL9rkUZA91tcCTm2ZeFH
         D+i2s/PAr9B+gS2Hcx4sZ/7cS0qBhNj14GKWME4FAXQoxuwhrz436bqR9APe7gZUDs
         l3iCKGHpne0GfoP0/Eu0wHmujCtzbRVtLbn3XMbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Ard Biesheuvel <ardb@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 224/334] i2c: synquacer: fix deferred probing
Date:   Mon, 13 Sep 2021 15:14:38 +0200
Message-Id: <20210913131120.993498057@linuxfoundation.org>
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

[ Upstream commit 8d744da241b81f4211f4813b0d3c1981326fa9ca ]

The driver overrides the error codes returned by platform_get_irq() to
-ENODEV, so if it returns -EPROBE_DEFER, the driver will fail the probe
permanently instead of the deferred probing. Switch to propagating the
error codes upstream.

Fixes: 0d676a6c4390 ("i2c: add support for Socionext SynQuacer I2C controller")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-synquacer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-synquacer.c b/drivers/i2c/busses/i2c-synquacer.c
index 31be1811d5e6..e4026c5416b1 100644
--- a/drivers/i2c/busses/i2c-synquacer.c
+++ b/drivers/i2c/busses/i2c-synquacer.c
@@ -578,7 +578,7 @@ static int synquacer_i2c_probe(struct platform_device *pdev)
 
 	i2c->irq = platform_get_irq(pdev, 0);
 	if (i2c->irq < 0)
-		return -ENODEV;
+		return i2c->irq;
 
 	ret = devm_request_irq(&pdev->dev, i2c->irq, synquacer_i2c_isr,
 			       0, dev_name(&pdev->dev), i2c);
-- 
2.30.2



