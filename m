Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C285247E715
	for <lists+stable@lfdr.de>; Thu, 23 Dec 2021 18:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244497AbhLWRcm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Dec 2021 12:32:42 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:58400 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349656AbhLWRcM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Dec 2021 12:32:12 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 629591F387;
        Thu, 23 Dec 2021 17:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1640280730; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CLdWcUxslRhox4mbm09PAaOqxikabSZEH3WG0zJ7e6A=;
        b=rCWy6ph0y8Qy20nsINIYj4FMVg60gb7b9Xp2KdO2he3LzKbZ8D9LatSmmQstfasCiUSKxe
        zLRz4s75Fo4Wy5TK14YoFdwtjsMAa7BbKn96Vf7iy60AQQ35Ddch9s88sdYSrdfrXeutdc
        7pKQWW9Q5+/P3Nk7KcDFhAHirao9/TY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1640280730;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CLdWcUxslRhox4mbm09PAaOqxikabSZEH3WG0zJ7e6A=;
        b=D9r75/tervm3m0BWnq9artqnfHn/PB/iEmViJqWGR+1pEDlSfTUXax/u8eKDGmlPfvW+LH
        VO1nhTdFl4H/qTCw==
Received: from quack2.suse.cz (unknown [10.163.28.18])
        by relay2.suse.de (Postfix) with ESMTP id 4EA69A3B89;
        Thu, 23 Dec 2021 17:32:10 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 244661F2BB6; Thu, 23 Dec 2021 18:32:07 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     <linux-block@vger.kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Paolo Valente <paolo.valente@linaro.org>,
        "yukuai (C)" <yukuai3@huawei.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 3/3] bfq: Split shared queues on move between cgroups
Date:   Thu, 23 Dec 2021 18:31:59 +0100
Message-Id: <20211223173207.15388-3-jack@suse.cz>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211223171425.3551-1-jack@suse.cz>
References: <20211223171425.3551-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1386; h=from:subject; bh=TGBjtt0Grb1Fs/1iAI39LWcQyjfnAr/HP/ZQxo/mPQw=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBhxLKOGMtYejmo8KCKQGoP/YL7qSr3m0V8J4bziX39 GJO/H3OJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYcSyjgAKCRCcnaoHP2RA2eDCB/ 0dFwPJoP3LEhfO7/cT2HwG6W0Spt/GeFpDckwZfCli+CxFVVgqZOrj23KW8mKb+/ORT81+6PGZ8Zjt jBBfl/qDjj+BGlQOVj1AZhzh+N8ZwRFzUhrBf3X5i1X/Wb1i8trx9fetuqO/sSNAo5KpPgA15fBqO9 UOJNL7/je/e0cf3JdhvosD9TM7m6dvzyiono4K/kEHib3gXrz93J9sCsUv3GHt9bIrsZE5kT8+TLEq FUDkvYpbRUiqWau4OWstVNd9AEBQk8vM5L+SVKtvpf89DLMDm4LFz0jEUc6gjKJjobitGHQQpH1hC3 g1qyuRM9SE2qr4HQiSx3fw4A8+Nkf9
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

CC: stable@vger.kernel.org
Fixes: e21b7a0b9887 ("block, bfq: add full hierarchical scheduling and cgroups support")
Signed-off-by: Jan Kara <jack@suse.cz>
---
 block/bfq-cgroup.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 24a5c5329bcd..1f5fb723bed7 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -730,8 +730,18 @@ static struct bfq_group *__bfq_bic_change_cgroup(struct bfq_data *bfqd,
 
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
 			bfq_bfqq_move(bfqd, sync_bfqq, bfqg);
+		}
 	}
 
 	return bfqg;
-- 
2.26.2

