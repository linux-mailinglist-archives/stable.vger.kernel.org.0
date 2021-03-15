Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8C933B920
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234792AbhCOOF3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:05:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:36764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233223AbhCOOBM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D20564F10;
        Mon, 15 Mar 2021 14:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816844;
        bh=IQlC1z8Ebef9PYH+7dqCkyGLDlclV7kgTHOWoSXZ/1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OT6FunnkK6dhkveJMMNvcDKbZRf3Iw4XUJbt108n7W5TnBG3tqz48SmVN8YdCmmXZ
         IexKb6F6eebIJ7K4YuQEbh8Kx1plkRx4hGBhY348CW21K7JNL5epBjt1GqWGNTN4xa
         c5qkW8U9rmG159sgjreGehnXskcOuyg2UJ6LohDI=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 107/120] block: rsxx: fix error return code of rsxx_pci_probe()
Date:   Mon, 15 Mar 2021 14:57:38 +0100
Message-Id: <20210315135723.475897012@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135720.002213995@linuxfoundation.org>
References: <20210315135720.002213995@linuxfoundation.org>
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
index d8ef8b16fb2e..08acfe11752b 100644
--- a/drivers/block/rsxx/core.c
+++ b/drivers/block/rsxx/core.c
@@ -883,6 +883,7 @@ static int rsxx_pci_probe(struct pci_dev *dev,
 	card->event_wq = create_singlethread_workqueue(DRIVER_NAME"_event");
 	if (!card->event_wq) {
 		dev_err(CARD_TO_DEV(card), "Failed card event setup.\n");
+		st = -ENOMEM;
 		goto failed_event_handler;
 	}
 
-- 
2.30.1



