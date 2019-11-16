Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8E5DFF3AD
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727944AbfKPPlh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:41:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:44792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727936AbfKPPlg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:41:36 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A70A4207DD;
        Sat, 16 Nov 2019 15:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918895;
        bh=E+336G3Zqyz4BvpRIJ6RtfyKVtr1OG5s4I4J4q3nsHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cD5n6WiIpdPxpzfOas/t0IroVOt3FjnM7I4GDkYdb0JBoT+xuBqMqzpK8Pq0xpSD+
         hjTK/eop/S0ZRma6hZK1pZEUdyrdfhTNjpkduZEvPZwABaRQHQP3WnAN2Xx5jOo++q
         +xGVoZteJIzVjuK4JwCSM4+Ywmf0mh99sdrhi2iw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 021/237] skd: fixup usage of legacy IO API
Date:   Sat, 16 Nov 2019 10:37:36 -0500
Message-Id: <20191116154113.7417-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 6d1f9dfde7343c4ebfb8f84dcb333af571bb3b22 ]

We need to be using the mq variant of request requeue here.

Fixes: ca33dd92968b ("skd: Convert to blk-mq")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/skd_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 87b9e7fbf0621..27323fa23997d 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -1416,7 +1416,7 @@ static void skd_resolve_req_exception(struct skd_device *skdev,
 
 	case SKD_CHECK_STATUS_BUSY_IMMINENT:
 		skd_log_skreq(skdev, skreq, "retry(busy)");
-		blk_requeue_request(skdev->queue, req);
+		blk_mq_requeue_request(req, true);
 		dev_info(&skdev->pdev->dev, "drive BUSY imminent\n");
 		skdev->state = SKD_DRVR_STATE_BUSY_IMMINENT;
 		skdev->timer_countdown = SKD_TIMER_MINUTES(20);
@@ -1426,7 +1426,7 @@ static void skd_resolve_req_exception(struct skd_device *skdev,
 	case SKD_CHECK_STATUS_REQUEUE_REQUEST:
 		if ((unsigned long) ++req->special < SKD_MAX_RETRIES) {
 			skd_log_skreq(skdev, skreq, "retry");
-			blk_requeue_request(skdev->queue, req);
+			blk_mq_requeue_request(req, true);
 			break;
 		}
 		/* fall through */
-- 
2.20.1

