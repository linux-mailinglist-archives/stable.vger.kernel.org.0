Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 771CF1B74EE
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 14:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgDXM3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 08:29:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:54082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728184AbgDXMXw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 08:23:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAF712168B;
        Fri, 24 Apr 2020 12:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587731032;
        bh=FNO5HnRA8S9+d8oyUQAZzI9nV37VP+FJrNUT5nn94nw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KTG41VHIpNJ0mBIKdiKWfQO8oZJBGRxzZCh2uFeUt5XdjsgGIeZEO3trEtm8rpHIX
         3OF0lW8ypUOd/ok+Z1a7rTIkgkzxsbAoJSc2XotRE312rUYHjowQhMn1hwa4UAvGjb
         QrkkuIN3xyOCsnj+nvIKEalGcugaIi3A/bTqANzM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Garry <john.garry@huawei.com>, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 25/26] blk-mq: Put driver tag in blk_mq_dispatch_rq_list() when no budget
Date:   Fri, 24 Apr 2020 08:23:22 -0400
Message-Id: <20200424122323.10194-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200424122323.10194-1-sashal@kernel.org>
References: <20200424122323.10194-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Garry <john.garry@huawei.com>

[ Upstream commit 5fe56de799ad03e92d794c7936bf363922b571df ]

If in blk_mq_dispatch_rq_list() we find no budget, then we break of the
dispatch loop, but the request may keep the driver tag, evaulated
in 'nxt' in the previous loop iteration.

Fix by putting the driver tag for that request.

Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index a8c1a45cedde0..757c0fd9f0cc2 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1232,8 +1232,10 @@ bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list,
 		rq = list_first_entry(list, struct request, queuelist);
 
 		hctx = rq->mq_hctx;
-		if (!got_budget && !blk_mq_get_dispatch_budget(hctx))
+		if (!got_budget && !blk_mq_get_dispatch_budget(hctx)) {
+			blk_mq_put_driver_tag(rq);
 			break;
+		}
 
 		if (!blk_mq_get_driver_tag(rq)) {
 			/*
-- 
2.20.1

