Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0292E671F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731658AbgL1QU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:20:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:42132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732350AbgL1NN6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:13:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1310822AAA;
        Mon, 28 Dec 2020 13:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161197;
        bh=Lwv8CmGye8bYWj3ELKJ9mQRHMfNUnWuYrQQaayD9kGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mqMms2IsaANzOo2iQdQx43MqcooaAAZZG4J3YshtpSueaiiu28jFSPAn44IxMZ49Y
         ddW9Uvs2qQJVcKpXsyT6+/9A9CdBBfNtASi5M+iRPPDw1+fuROBIM1BcS016fqTYz1
         eKcr0g5pRoKnwcT7jKKQsANPh0nlyNxmHZuLDeuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 107/242] memstick: fix a double-free bug in memstick_check
Date:   Mon, 28 Dec 2020 13:48:32 +0100
Message-Id: <20201228124909.959344678@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

[ Upstream commit e3e9ced5c93803d5b2ea1942c4bf0192622531d6 ]

kfree(host->card) has been called in put_device so that
another kfree would raise cause a double-free bug.

Fixes: 0193383a5833 ("memstick: core: fix device_register() error handling")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Link: https://lore.kernel.org/r/20201120074846.31322-1-miaoqinglang@huawei.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memstick/core/memstick.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/memstick/core/memstick.c b/drivers/memstick/core/memstick.c
index b1564cacd19e1..20ae8652adf44 100644
--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -469,7 +469,6 @@ static void memstick_check(struct work_struct *work)
 			host->card = card;
 			if (device_register(&card->dev)) {
 				put_device(&card->dev);
-				kfree(host->card);
 				host->card = NULL;
 			}
 		} else
-- 
2.27.0



