Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0FC110B9C8
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730197AbfK0U4n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:56:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:47518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730176AbfK0U4m (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:56:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1581020862;
        Wed, 27 Nov 2019 20:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888201;
        bh=E+336G3Zqyz4BvpRIJ6RtfyKVtr1OG5s4I4J4q3nsHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yxdjey30MvxHVWXhy3o7GU3GWyZDiGyB18ITXWkZYvJZzO+58JdYtMAvNi5rnW5iI
         g6JmKQA22TzH0lRmpPqlr6mjLF8cVWH8bbc6NPvi/kmbPyEDi2QpVunMPOl0gEF4MY
         tg9lPpYs210xBTtsUS/DhD7OaGQvcdlXCsda9kJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 042/306] skd: fixup usage of legacy IO API
Date:   Wed, 27 Nov 2019 21:28:12 +0100
Message-Id: <20191127203117.912903311@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



