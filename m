Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8EE415644
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 05:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239283AbhIWDk2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 23:40:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:40550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239071AbhIWDkD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Sep 2021 23:40:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62B3C610A1;
        Thu, 23 Sep 2021 03:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632368311;
        bh=L6blX4ytRWLsQcA3c2TsdxkGaOJvCsSpkaUHP2vCsrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KYjVjeRfX7FPzsgLYwm0sd27wA3pqQkLQfZBaxEkQeY3AYhCymBIBKWRA81j2mEGp
         Luis72T7oVDWgcUQxT+YTfOPfO2VWa1uaqJLfgFSznCZAD0klU2doHffrZ2l0mIcza
         byP9n2A8kbAZsDuzxLp67sGpQQEUPAbza1vxgk8nKP30xM1MchgdkIrxQwqLcCBNvh
         Z3JxqKm5vLLwoiYFOzoIBk27iHih5PjqACbf9+ZPUSElYtZvxXYNGtqHfgO9wSY/OO
         /jWmdkOGKeBIEfG1O0DwJwLYfdIpJGad53QeBsQ3jnqCXLDYk7DrkIGedF7rork0RI
         Uyho51J8FntfA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        luojiaxing <luojiaxing@huawei.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 05/34] blk-mq: avoid to iterate over stale request
Date:   Wed, 22 Sep 2021 23:37:53 -0400
Message-Id: <20210923033823.1420814-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210923033823.1420814-1-sashal@kernel.org>
References: <20210923033823.1420814-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 67f3b2f822b7e71cfc9b42dbd9f3144fa2933e0b ]

blk-mq can't run allocating driver tag and updating ->rqs[tag]
atomically, meantime blk-mq doesn't clear ->rqs[tag] after the driver
tag is released.

So there is chance to iterating over one stale request just after the
tag is allocated and before updating ->rqs[tag].

scsi_host_busy_iter() calls scsi_host_check_in_flight() to count scsi
in-flight requests after scsi host is blocked, so no new scsi command can
be marked as SCMD_STATE_INFLIGHT. However, driver tag allocation still can
be run by blk-mq core. One request is marked as SCMD_STATE_INFLIGHT,
but this request may have been kept in another slot of ->rqs[], meantime
the slot can be allocated out but ->rqs[] isn't updated yet. Then this
in-flight request is counted twice as SCMD_STATE_INFLIGHT. This way causes
trouble in handling scsi error.

Fixes the issue by not iterating over stale request.

Cc: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Reported-by: luojiaxing <luojiaxing@huawei.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20210906065003.439019-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq-tag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 86f87346232a..ff5caeb82542 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -208,7 +208,7 @@ static struct request *blk_mq_find_and_get_req(struct blk_mq_tags *tags,
 
 	spin_lock_irqsave(&tags->lock, flags);
 	rq = tags->rqs[bitnr];
-	if (!rq || !refcount_inc_not_zero(&rq->ref))
+	if (!rq || rq->tag != bitnr || !refcount_inc_not_zero(&rq->ref))
 		rq = NULL;
 	spin_unlock_irqrestore(&tags->lock, flags);
 	return rq;
-- 
2.30.2

