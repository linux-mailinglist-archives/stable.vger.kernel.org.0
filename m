Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4DB44EEB37
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 12:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245696AbiDAK3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 06:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241970AbiDAK3p (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 06:29:45 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E176526E56B;
        Fri,  1 Apr 2022 03:27:55 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 9501C21A9A;
        Fri,  1 Apr 2022 10:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1648808874; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YFpkNPF3uJRlZQSWVGOFjXkVj/UMJKrQUqJzQPtsgKw=;
        b=l+q74p/8d7Bia3xg3pZeot8GChd6NY7lIGHIiIUNRMGNv+tQwk++e0EsIyYRsMt2OPPaHi
        YeWHCTs42xZRJTJDNFXKa7w7LuWKJYM/ABU71r2i/1EITKAPQWpQiycrJg3G5L2crATXIi
        Q/LmmcYeYzQG7M4lQXYdIEViHX0c384=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1648808874;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YFpkNPF3uJRlZQSWVGOFjXkVj/UMJKrQUqJzQPtsgKw=;
        b=y0gzdMO1dnTh8nqlLYdGqwMRK2aaMjSYXJzfGLo4fNpyFKwRwkYS0vZNwwdCrpVsYyuZUm
        HHF2Gz5JcsNc+6Aw==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 7BD0AA3B83;
        Fri,  1 Apr 2022 10:27:54 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 99E5AA061D; Fri,  1 Apr 2022 12:27:52 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Paolo Valente <paolo.valente@linaro.org>
Cc:     <linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        "yukuai (C)" <yukuai3@huawei.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 7/9] bfq: Track whether bfq_group is still online
Date:   Fri,  1 Apr 2022 12:27:48 +0200
Message-Id: <20220401102752.8599-7-jack@suse.cz>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401102325.17617-1-jack@suse.cz>
References: <20220401102325.17617-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1771; h=from:subject; bh=cGpLXMZhgvdpvOg/vhc4Y6xKtjjgG1ZtO8E3+AAlxnQ=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBiRtOkm5+xlSK7pmV2/cdmILjXlk+jzRsKtERV+D1k ZI9PNWaJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYkbTpAAKCRCcnaoHP2RA2RJeCA DnT+9KPHzYEdE+yW007cB8jin8dzLU6NATqIGWtk0sCkzkJJfhDV/JK0kytrSRSrSpjsWTCDbM3hV8 Uqn27kCIhEEqRggXLHk7TXbwhuIUXRSUT1ZT6Q9RgLIZyeWBWbx8EqH76bUqIhdBHh2raPud8mgRjG SCc7yT3VBGzpA1NysS5VUmMP5yI1a7RGh4Amvypzh1Xv2MBYuBtrnqNZDXSqsKw7XFUOzimOzqd4Rc 1HOxLiAx5y3mR/SRWPvaUfn28qt0C/2ksF3EuoaysXL27CIM7xGEoUgd66nwZkKLvHfgT6rE+Z09GO HSnTJ8CO6U3XmJfx1rDVdfeMQJuKUb
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Track whether bfq_group is still online. We cannot rely on
blkcg_gq->online because that gets cleared only after all policies are
offlined and we need something that gets updated already under
bfqd->lock when we are cleaning up our bfq_group to be able to guarantee
that when we see online bfq_group, it will stay online while we are
holding bfqd->lock lock.

CC: stable@vger.kernel.org
Tested-by: "yukuai (C)" <yukuai3@huawei.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 block/bfq-cgroup.c  | 3 ++-
 block/bfq-iosched.h | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 9352f3cc2377..879380c2bc7e 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -557,6 +557,7 @@ static void bfq_pd_init(struct blkg_policy_data *pd)
 				   */
 	bfqg->bfqd = bfqd;
 	bfqg->active_entities = 0;
+	bfqg->online = true;
 	bfqg->rq_pos_tree = RB_ROOT;
 }
 
@@ -603,7 +604,6 @@ struct bfq_group *bfq_find_set_group(struct bfq_data *bfqd,
 	struct bfq_entity *entity;
 
 	bfqg = bfq_lookup_bfqg(bfqd, blkcg);
-
 	if (unlikely(!bfqg))
 		return NULL;
 
@@ -979,6 +979,7 @@ static void bfq_pd_offline(struct blkg_policy_data *pd)
 
 put_async_queues:
 	bfq_put_async_queues(bfqd, bfqg);
+	bfqg->online = false;
 
 	spin_unlock_irqrestore(&bfqd->lock, flags);
 	/*
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index a56763045d19..4664e2f3e828 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -928,6 +928,8 @@ struct bfq_group {
 
 	/* reference counter (see comments in bfq_bic_update_cgroup) */
 	int ref;
+	/* Is bfq_group still online? */
+	bool online;
 
 	struct bfq_entity entity;
 	struct bfq_sched_data sched_data;
-- 
2.34.1

