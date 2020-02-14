Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECA815EC77
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390743AbgBNR1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:27:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:60058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390876AbgBNQIN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:08:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8236022314;
        Fri, 14 Feb 2020 16:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696493;
        bh=p5HfsD/7oSJvIOKScBFttuw+L3MLtwgbJ+C+qro4QB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xb3MV2MnbWV+WTQRo72fH7iWyzjkow26+V/hldrlBg0vlIHKzAB7NwutN5UjtfKRQ
         y0LugU7FAix4fbEPUQ5l2JNZhRwyyOxB4BRbPrS3/ibP07c0ZWo+hGFSztBqXXCpYn
         fZ6PCACAXqdKjOHUXsC/+czFtbkbccE8hYwAm1QQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hongbo Yao <yaohongbo@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 298/459] misc: genwqe: fix compile warnings
Date:   Fri, 14 Feb 2020 10:59:08 -0500
Message-Id: <20200214160149.11681-298-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hongbo Yao <yaohongbo@huawei.com>

[ Upstream commit 8edf4cd193067ac5e03fd9580f1affbb6a3f729b ]

Using the following command will get compile warnings:
make W=1 drivers/misc/genwqe/card_ddcb.o ARCH=x86_64

drivers/misc/genwqe/card_ddcb.c: In function setup_ddcb_queue:
drivers/misc/genwqe/card_ddcb.c:1024:6: warning: variable rc set but not
used [-Wunused-but-set-variable]
drivers/misc/genwqe/card_ddcb.c: In function genwqe_card_thread:
drivers/misc/genwqe/card_ddcb.c:1190:23: warning: variable rc set but
not used [-Wunused-but-set-variable]

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Hongbo Yao <yaohongbo@huawei.com>
Link: https://lore.kernel.org/r/20191205111655.170382-1-yaohongbo@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/genwqe/card_ddcb.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/genwqe/card_ddcb.c b/drivers/misc/genwqe/card_ddcb.c
index 026c6ca245408..905106579935a 100644
--- a/drivers/misc/genwqe/card_ddcb.c
+++ b/drivers/misc/genwqe/card_ddcb.c
@@ -1084,7 +1084,7 @@ static int setup_ddcb_queue(struct genwqe_dev *cd, struct ddcb_queue *queue)
 				queue->ddcb_daddr);
 	queue->ddcb_vaddr = NULL;
 	queue->ddcb_daddr = 0ull;
-	return -ENODEV;
+	return rc;
 
 }
 
@@ -1179,7 +1179,7 @@ static irqreturn_t genwqe_vf_isr(int irq, void *dev_id)
  */
 static int genwqe_card_thread(void *data)
 {
-	int should_stop = 0, rc = 0;
+	int should_stop = 0;
 	struct genwqe_dev *cd = (struct genwqe_dev *)data;
 
 	while (!kthread_should_stop()) {
@@ -1187,12 +1187,12 @@ static int genwqe_card_thread(void *data)
 		genwqe_check_ddcb_queue(cd, &cd->queue);
 
 		if (GENWQE_POLLING_ENABLED) {
-			rc = wait_event_interruptible_timeout(
+			wait_event_interruptible_timeout(
 				cd->queue_waitq,
 				genwqe_ddcbs_in_flight(cd) ||
 				(should_stop = kthread_should_stop()), 1);
 		} else {
-			rc = wait_event_interruptible_timeout(
+			wait_event_interruptible_timeout(
 				cd->queue_waitq,
 				genwqe_next_ddcb_ready(cd) ||
 				(should_stop = kthread_should_stop()), HZ);
-- 
2.20.1

