Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B71D38AB13
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240308AbhETLUW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:20:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:41738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240622AbhETLTB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:19:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FEEC61D6E;
        Thu, 20 May 2021 10:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505410;
        bh=iZTZoo/H+Eb2+ejsX1PnEeku1dWxbnLOkC9Ru8jOEns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1B/gJ5UXgutpUAb/HVPDdrsO7JGLXDU8PfydCVHDLnCF+fc0iHhNQ3gp2ObnJq0aK
         bYRfgSn9yHVg2gU5B4hBl0zYx3dVoi5Tu39cygwvh3i/SR6Q/B8MgAILL/oWCoQadu
         PrwRazmd71Dyg2G4+A+dN6+hROvWVMcwjD4Ov+/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 123/190] i2c: sh7760: add IRQ check
Date:   Thu, 20 May 2021 11:23:07 +0200
Message-Id: <20210520092106.268405422@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
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
index 24968384b401..70e4437060d5 100644
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



