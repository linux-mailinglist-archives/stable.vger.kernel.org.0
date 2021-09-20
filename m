Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA38411A97
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242396AbhITQup (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:50:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:37262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242757AbhITQtx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:49:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15426611AE;
        Mon, 20 Sep 2021 16:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156506;
        bh=RIslOFZYcQb3jfkRSB4e3DOO1ULVjvFJPY4ZleFHr5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LqdE8q7IaUyQJwwdl/SB6HIZeDhGV63N/zaYuD3kGmVBt9OPGf5CHLcL7hjKOzAbg
         0TETG/P30iFaoenCvjIHQLU49yEDuwywha69FabG+MvQ0BfQsaRQe2+hMwXuguSjEz
         spz5b9mqro6CdLjpJv9M3mI1Xrr72nfwUwvT+hik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 059/133] i2c: s3c2410: fix IRQ check
Date:   Mon, 20 Sep 2021 18:42:17 +0200
Message-Id: <20210920163914.582441994@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163912.603434365@linuxfoundation.org>
References: <20210920163912.603434365@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Shtylyov <s.shtylyov@omp.ru>

[ Upstream commit d6840a5e370b7ea4fde16ce2caf431bcc87f9a75 ]

Iff platform_get_irq() returns 0, the driver's probe() method will return 0
early (as if the method's call was successful).  Let's consider IRQ0 valid
for simplicity -- devm_request_irq() can always override that decision...

Fixes: e0d1ec97853f ("i2c-s3c2410: Change IRQ to be plain integer.")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-s3c2410.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index bea74aa3f56c..44af640496bb 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -1213,7 +1213,7 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 
 	if (!(i2c->quirks & QUIRK_POLL)) {
 		i2c->irq = ret = platform_get_irq(pdev, 0);
-		if (ret <= 0) {
+		if (ret < 0) {
 			dev_err(&pdev->dev, "cannot find IRQ\n");
 			clk_unprepare(i2c->clk);
 			return ret;
-- 
2.30.2



