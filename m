Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0980833B6B6
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbhCON6j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:58:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:57494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231423AbhCONyZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:54:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A04264EEA;
        Mon, 15 Mar 2021 13:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816463;
        bh=ncJmh/5M5rHsZMi6hbBZQBpe2HbBRnUl8h1JQ37PPQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EgeSX/RV5oIfzTY7931L0ZiqkRZlR0uX1nJWsZd5N/epqajXZw04RVX72Dw9V36z5
         EucfHVFV6j5qY0sYtZ+aRF0H09hTFdgm9B76o6OLzbRsu0/m0am065BOeVpZGXCTvK
         6U6SK838uABRnC4Jfyq4xH0rGamhiGfYniuwswbw=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 59/75] block: rsxx: fix error return code of rsxx_pci_probe()
Date:   Mon, 15 Mar 2021 14:52:13 +0100
Message-Id: <20210315135210.187056507@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135208.252034256@linuxfoundation.org>
References: <20210315135208.252034256@linuxfoundation.org>
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
index 0d9137408e3c..a53271acc2a2 100644
--- a/drivers/block/rsxx/core.c
+++ b/drivers/block/rsxx/core.c
@@ -895,6 +895,7 @@ static int rsxx_pci_probe(struct pci_dev *dev,
 	card->event_wq = create_singlethread_workqueue(DRIVER_NAME"_event");
 	if (!card->event_wq) {
 		dev_err(CARD_TO_DEV(card), "Failed card event setup.\n");
+		st = -ENOMEM;
 		goto failed_event_handler;
 	}
 
-- 
2.30.1



