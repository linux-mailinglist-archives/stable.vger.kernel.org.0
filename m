Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF919411C21
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346195AbhITRGL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:06:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:53956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229747AbhITRD1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:03:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3B6061462;
        Mon, 20 Sep 2021 16:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156833;
        bh=l73SjNGlQcnLx4hNRwXUvBhJotaknGZvJbC6mfEZ+rw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DS+RV/MmbGmGBY5HraLkp2xMwwo7kCCbZXo1UJd06o58yFsyuhi0Dfo3D9up2jOrc
         XJkJwE6cGuUOqlKDtUBQ2y+xnas2kpg/M4awgFVg809mWW2VO4vHJmRD3bQ9yPLCQY
         Xs3vOmXBrS9o9Q1KZEkEnf7zsH3CfziS45JM/WMA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 074/175] i2c: s3c2410: fix IRQ check
Date:   Mon, 20 Sep 2021 18:42:03 +0200
Message-Id: <20210920163920.477135226@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
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
index acccdfb95420..3814c160ff17 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -1181,7 +1181,7 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 	 */
 	if (!(i2c->quirks & QUIRK_POLL)) {
 		i2c->irq = ret = platform_get_irq(pdev, 0);
-		if (ret <= 0) {
+		if (ret < 0) {
 			dev_err(&pdev->dev, "cannot find IRQ\n");
 			clk_unprepare(i2c->clk);
 			return ret;
-- 
2.30.2



