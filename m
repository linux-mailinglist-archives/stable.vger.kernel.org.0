Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E739C33B915
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234777AbhCOOFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:05:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:37836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233217AbhCOOBL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17CA364F23;
        Mon, 15 Mar 2021 14:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816845;
        bh=e+biyl84nGKnbtngIlTFtk/yIT2OJU8s+xalLhPS010=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DI0epbtiJyGSYlOizi1JUJaEZo4RZ5WCZ5QdbZZlYlGaJ6jA+MFs7ueEhAyLV9bF/
         o+7TEwdxg+6MiACvAsKcxVs7YU9xgzvGEQMa9Tswwr8mq3jyp1jY4q79TnmsnTEn4C
         lQR26ejq9S4cs/gyvc4+odNRAIk1I8RFKpB61luc=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 149/168] block: rsxx: fix error return code of rsxx_pci_probe()
Date:   Mon, 15 Mar 2021 14:56:21 +0100
Message-Id: <20210315135555.236979509@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit df66617bfe87487190a60783d26175b65d2502ce ]

When create_singlethread_workqueue returns NULL to card->event_wq, no
error return code of rsxx_pci_probe() is assigned.

To fix this bug, st is assigned with -ENOMEM in this case.

Fixes: 8722ff8cdbfa ("block: IBM RamSan 70/80 device driver")
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Link: https://lore.kernel.org/r/20210310033017.4023-1-baijiaju1990@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/rsxx/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/rsxx/core.c b/drivers/block/rsxx/core.c
index 804d28faa97b..a1824bb08044 100644
--- a/drivers/block/rsxx/core.c
+++ b/drivers/block/rsxx/core.c
@@ -869,6 +869,7 @@ static int rsxx_pci_probe(struct pci_dev *dev,
 	card->event_wq = create_singlethread_workqueue(DRIVER_NAME"_event");
 	if (!card->event_wq) {
 		dev_err(CARD_TO_DEV(card), "Failed card event setup.\n");
+		st = -ENOMEM;
 		goto failed_event_handler;
 	}
 
-- 
2.30.1



