Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE9566D17
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727462AbfGLM0Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:26:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:37474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727606AbfGLM0X (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:26:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1F212166E;
        Fri, 12 Jul 2019 12:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934382;
        bh=yI9lQGvkfE2VG2EgKJi2P2TGT6qoGK+er9pkMhTkG8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rxKSLmoI6SYDjBbvdesmWaTPwxbnRBJvCno4KsZZsDG4qDxVrHvNKQMr9GPbsOd8z
         AVWQV4mtVulo3OPRdlKRnYX+Tbs10ZXcbqzBHwAcWDCbE4tAZlCZIoHTgTwMSm9v/L
         1N7jOic9uwHuGM0/bPwLkj7lHurdRxEW/9CeevJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 038/138] can: flexcan: Remove unneeded registration message
Date:   Fri, 12 Jul 2019 14:18:22 +0200
Message-Id: <20190712121630.143981567@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
References: <20190712121628.731888964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit eb503004a7e563d543c9cb869907156de7efe720 ]

Currently the following message is observed when the flexcan
driver is probed:

flexcan 2090000.flexcan: device registered (reg_base=(ptrval), irq=23)

The reason for printing 'ptrval' is explained at
Documentation/core-api/printk-formats.rst:

"Pointers printed without a specifier extension (i.e unadorned %p) are
hashed to prevent leaking information about the kernel memory layout. This
has the added benefit of providing a unique identifier. On 64-bit machines
the first 32 bits are zeroed. The kernel will print ``(ptrval)`` until it
gathers enough entropy."

Instead of passing %pK, which can print the correct address, simply
remove the entire message as it is not really that useful.

Signed-off-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/flexcan.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index f97c628eb2ad..f2fe344593d5 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1583,9 +1583,6 @@ static int flexcan_probe(struct platform_device *pdev)
 			dev_dbg(&pdev->dev, "failed to setup stop-mode\n");
 	}
 
-	dev_info(&pdev->dev, "device registered (reg_base=%p, irq=%d)\n",
-		 priv->regs, dev->irq);
-
 	return 0;
 
  failed_register:
-- 
2.20.1



