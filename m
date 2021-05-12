Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40FB237CE8D
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344999AbhELRFp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:05:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:37578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244439AbhELQqG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:46:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D8F26144F;
        Wed, 12 May 2021 16:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836086;
        bh=os3IdbjtmowGQlAp1NLTz3BkNBLLRVYjWB6eNY2ukH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rRMCLJMnBMnfrrDzRwiZtLS1suMNNVLIUIIhbNrB4uoMLRg5g6pPBSsx2zE/tbUsR
         9WHZCpy47edxnen5vL+rT+gGlEAJ5pzEWb6vKoynbJWFbBAk43CzAq7cSjM14/1Ceo
         hFnoaDWvSxUnzF8kkmWV+VHLFvBebZ/oCXE02AHM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 569/677] i2c: sh7760: add IRQ check
Date:   Wed, 12 May 2021 16:50:15 +0200
Message-Id: <20210512144856.302558952@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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



