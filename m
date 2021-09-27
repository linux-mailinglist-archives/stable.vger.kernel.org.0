Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF7E3419C80
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236568AbhI0R3p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:29:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:43622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238105AbhI0R0E (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:26:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32D19611C7;
        Mon, 27 Sep 2021 17:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762976;
        bh=YwW3Vl+aWLWc/1UTMI7y3brIlWl/0Pf8DMSaAiBM3ns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fcUqNdN5pm3YrdI1K7m+jj0Lla3h1Z2n/aTc3N6Lr0BR/TyFLYe8cMAG/zpG3U+T6
         dC5KcSVuf/BWmBFhKzn8sLswrMgiqCBBK9aIPS56hBbBEaebaUxG2/qwsbIWTxgson
         FuORMh3HW7pNH1gDVpMolPrl2imG4D+0eTstvN6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        luojiaxing <luojiaxing@huawei.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 120/162] blk-mq: avoid to iterate over stale request
Date:   Mon, 27 Sep 2021 19:02:46 +0200
Message-Id: <20210927170237.603016788@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
2.33.0



