Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9A53D2998
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbhGVQFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:05:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:39684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234228AbhGVQE3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:04:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0CBA61CEC;
        Thu, 22 Jul 2021 16:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972302;
        bh=Z4P5MoOI1A3rTntoZ5jca6mUwSxAZ6VYmqDO5ThiPEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1V+3dx17z+fFwEV+i8igbt+uImalx5Nc60LlSm0ph/xECieJ47b2T2MGKO+tCiVwY
         L3RLN16P8y9OJVufJdT/8Bq5WxtthKOm6p1wlZpfCcN8FsTY6ccjgSkjHNUJwYgx05
         YzJV2nBYNAE19ZNkpQ9WAE8cFTi6PRYLgVZuITBg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 062/156] i3c: master: svc: drop free_irq of devm_request_irq allocated irq
Date:   Thu, 22 Jul 2021 18:30:37 +0200
Message-Id: <20210722155630.413158197@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 59a61e69c4252b4e8ecd15e752b0d2337f0121b7 ]

irq allocated with devm_request_irq() will be freed in devm_irq_release(),
using free_irq() in ->remove() will causes a dangling pointer, and a
subsequent double free. So remove the free_irq() in svc_i3c_master_remove().

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20210602084935.3977636-1-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/svc-i3c-master.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/i3c/master/svc-i3c-master.c b/drivers/i3c/master/svc-i3c-master.c
index 1f6ba4221817..eeb49b5d90ef 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -1448,7 +1448,6 @@ static int svc_i3c_master_remove(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	free_irq(master->irq, master);
 	clk_disable_unprepare(master->pclk);
 	clk_disable_unprepare(master->fclk);
 	clk_disable_unprepare(master->sclk);
-- 
2.30.2



