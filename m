Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52D824866FA
	for <lists+stable@lfdr.de>; Thu,  6 Jan 2022 16:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240737AbiAFPp5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jan 2022 10:45:57 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:47176 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240585AbiAFPpq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jan 2022 10:45:46 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 46CDB1F39B;
        Thu,  6 Jan 2022 15:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1641483945; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uH6rLm0uvdtCUs+5Hj4fNqeCcJ6uGEpoau8APl9ELjQ=;
        b=3TeVkJopoFu9yJLUeZy2ffsgUZp1dfofweUi4OTkDOEkdAHDtQ1lLOH0iKq46Fnqa4kzIu
        PbEX3HsoUBeniKgu9yWHckzge8iv/adfLYxYI4F5ppQvlE/MCSnc8MQocCSckir2GKB4MZ
        kv2MUv8oWcnhT+JADEtdbnp0ffZMuVc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1641483945;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uH6rLm0uvdtCUs+5Hj4fNqeCcJ6uGEpoau8APl9ELjQ=;
        b=EOPcjPEN/MirAIsj8vRnUOnZhy8MYcz199sfKPDjurQCzbpDKW+m3pApA7ZiG322nJCVnn
        zIwgWV1TZftVioDA==
Received: from quack3.suse.cz (unknown [10.163.43.118])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 270B3A3B84;
        Thu,  6 Jan 2022 15:45:44 +0000 (UTC)
Received: by localhost (Postfix, from userid 1000)
        id D495BA0845; Wed,  5 Jan 2022 15:36:39 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     <linux-block@vger.kernel.org>
Cc:     Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>,
        "yukuai (C)" <yukuai3@huawei.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 4/5] bfq: Split shared queues on move between cgroups
Date:   Wed,  5 Jan 2022 15:36:35 +0100
Message-Id: <20220105143639.31266-4-jack@suse.cz>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220105143037.20542-1-jack@suse.cz>
References: <20220105143037.20542-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1577; h=from:subject; bh=KDVBmw4QcP3RG5Cns2TtzfOpGdWxxpHSimIBb2OfTMA=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBh1azz4GQZ1mDoa1ToN0BKKpd5760WlukVhwGlI8La zvCOHxqJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYdWs8wAKCRCcnaoHP2RA2XkNB/ sHs9rnqYjK6S4mzAveq9dokCAW3IvCdySiHU1oobzP4qhIqUOorlOunDDa4N/KC4WbA9TuGXEFBXLY HyXU21Zi99rlBGpKuRQ2ZLjfgwmHnlqSzu47XY0vOo+dQbP7RGxMM8G3r9t2iMuxPj36kq68PjTSLu CXvZAL7f4oKWJmUDqCjRaqrTbMfQXcWNW6cT8Y+8k6gYLaEg5VAzU5cR98EuUw5VGjlFYoQLtfp2nv m+2Zt+QKYl1Nur4KrpF/FjwTSbCrlpXed/LVH5fuxlpGZX8MglymJPwAQn92+Ts7dq8aX5c4lRSWax hh6a7Pqums7nyFrlpI2xgSQ58Q+OpB
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When bfqq is shared by multiple processes it can happen that one of the
processes gets moved to a different cgroup (or just starts submitting IO
for different cgroup). In case that happens we need to split the merged
bfqq as otherwise we will have IO for multiple cgroups in one bfqq and
we will just account IO time to wrong entities etc.

Similarly if the bfqq is scheduled to merge with another bfqq but the
merge didn't happen yet, cancel the merge as it need not be valid
anymore.

CC: stable@vger.kernel.org
Fixes: e21b7a0b9887 ("block, bfq: add full hierarchical scheduling and cgroups support")
Signed-off-by: Jan Kara <jack@suse.cz>
---
 block/bfq-cgroup.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 24a5c5329bcd..a78d86805bd5 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -730,8 +730,19 @@ static struct bfq_group *__bfq_bic_change_cgroup(struct bfq_data *bfqd,
 
 	if (sync_bfqq) {
 		entity = &sync_bfqq->entity;
-		if (entity->sched_data != &bfqg->sched_data)
+		if (entity->sched_data != &bfqg->sched_data) {
+			/*
+			 * Moving bfqq that is shared with another process?
+			 * Split the queues at the nearest occasion as the
+			 * processes can be in different cgroups now.
+			 */
+			if (bfq_bfqq_coop(sync_bfqq)) {
+				bic->stably_merged = false;
+				bfq_mark_bfqq_split_coop(sync_bfqq);
+			}
+			WARN_ON_ONCE(sync_bfqq->new_bfqq);
 			bfq_bfqq_move(bfqd, sync_bfqq, bfqg);
+		}
 	}
 
 	return bfqg;
-- 
2.31.1

