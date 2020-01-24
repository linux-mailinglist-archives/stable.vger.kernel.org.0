Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19690147B55
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732685AbgAXJmi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:42:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:40332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731166AbgAXJmi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:42:38 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79F06208C4;
        Fri, 24 Jan 2020 09:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858958;
        bh=9ikAnuKXYVTrUYZSVlqYyhEwoHYAgpuy6/5q5PQ9Ins=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OGgaB6atmizK5u+S7ctRvHxpKQ+pfwMEfICwmKRIplFIUT0cl9oJF0/kHLWpitmIn
         ulX0gOyipy8FMUqpn0k8ZsQOflMZdb4U/sxvVieC5T14Y8YGXV44MdnGZ6j9JIqq0n
         7JbSXnJ9KAoN1b4ebSM0Cj0q4P3FGuTVfwiU0iiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Andrew Jeffery <andrew@aj.id.au>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 100/102] gpio: aspeed: avoid return type warning
Date:   Fri, 24 Jan 2020 10:31:41 +0100
Message-Id: <20200124092821.829200623@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 11e299de3aced4ea23a9fb1fef6c983c8d516302 ]

gcc has a hard time tracking whether BUG_ON(1) ends
execution or not:

drivers/gpio/gpio-aspeed-sgpio.c: In function 'bank_reg':
drivers/gpio/gpio-aspeed-sgpio.c:112:1: error: control reaches end of non-void function [-Werror=return-type]

Use the simpler BUG() that gcc knows cannot continue.

Fixes: f8b410e3695a ("gpio: aspeed-sgpio: Rename and add Kconfig/Makefile")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Andrew Jeffery <andrew@aj.id.au>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/sgpio-aspeed.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/sgpio-aspeed.c b/drivers/gpio/sgpio-aspeed.c
index 7e99860ca447e..8319812593e31 100644
--- a/drivers/gpio/sgpio-aspeed.c
+++ b/drivers/gpio/sgpio-aspeed.c
@@ -107,7 +107,7 @@ static void __iomem *bank_reg(struct aspeed_sgpio *gpio,
 		return gpio->base + bank->irq_regs + GPIO_IRQ_STATUS;
 	default:
 		/* acturally if code runs to here, it's an error case */
-		BUG_ON(1);
+		BUG();
 	}
 }
 
-- 
2.20.1



