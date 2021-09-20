Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01EF1411F77
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346904AbhITRld (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:41:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:46308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352482AbhITRjc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:39:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2E3761B48;
        Mon, 20 Sep 2021 17:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157670;
        bh=bVY+hQhJCNipJnM5nmraGGdtxsMn/xqSgATVjH+WMF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b4osaOhFDpzSBYjIQ/tmyIfuaFfXxBYxUVKImDejdJ6XsOCHOaL0OO5XkXDz0MBRd
         wDEsjcLu+l9ksDj3/IXezJzySY33v9vvSVMvNGmZj4WkIv38XwRFSOajbtd+TObTH7
         juIO3djqqHZ804idWQ1MwWtdIkmquxN162f8SDDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 070/293] i2c: highlander: add IRQ check
Date:   Mon, 20 Sep 2021 18:40:32 +0200
Message-Id: <20210920163935.654214560@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
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
index ff340d7ae2e5..6a880c262380 100644
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



