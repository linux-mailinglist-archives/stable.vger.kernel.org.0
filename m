Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7974EC4CB
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 14:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345385AbiC3MrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 08:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345327AbiC3Mqk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 08:46:40 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E347DE17;
        Wed, 30 Mar 2022 05:43:02 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 2E0AC1F38C;
        Wed, 30 Mar 2022 12:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1648644181; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vLbXYHxIS9+MRxNXnLg56MB0MlJ/8dPXaZ7nAX5+HvE=;
        b=nSRGpGh1Os+Uv34BDMGUSUMsLXwq1Pw83aaeCbaEljTIqam6Na/4GzPRMsLoeeR+1v9M1L
        Qcf4ncfsayrcRoymZafGv6xOEE6LXbQnO04K3zZIFXEVALQDnsJ4sXxQGuzIuGz2M2xBEG
        i46MiTQF3TIpcTNGr7OV23sd9p4X3QM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1648644181;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vLbXYHxIS9+MRxNXnLg56MB0MlJ/8dPXaZ7nAX5+HvE=;
        b=oIMjBwwUpMJ8Zv5bH2C0iC7zL6t72WRs7o/fyyiTtgBwah44F2mcA7gINHIm0Lc70vX6yI
        emK3fAp5fbbI00AQ==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 1EA50A3B96;
        Wed, 30 Mar 2022 12:43:01 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 678C7A0615; Wed, 30 Mar 2022 14:42:56 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     <linux-block@vger.kernel.org>
Cc:     Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>,
        "yukuai (C)" <yukuai3@huawei.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 1/9] bfq: Avoid false marking of bic as stably merged
Date:   Wed, 30 Mar 2022 14:42:44 +0200
Message-Id: <20220330124255.24581-1-jack@suse.cz>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330123438.32719-1-jack@suse.cz>
References: <20220330123438.32719-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1119; h=from:subject; bh=y0+aE+PP4MGA/7TmenAivQcOtrdcGD/YLmt5dn84/Js=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBiRFBEyII0Q8DmSosqFkx2FseuyFwd22h1KoedIzeV 4ygRUqeJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYkRQRAAKCRCcnaoHP2RA2ZLuB/ 9/QQIouvPceN+2Ild6FwsBmpqRWWRfqZzTqWf8oJ5KFzDIMTewhGgS/gOv6MF/9tAWcQftGQl+Z9lV frfC9y6NZAocBTs8CpFS28y0O39kJDSuo0qwy9Ohycfzo4MkNu8Aoz1j6Ksz8FQdQgko2cgk8ybeMf Rgx9mQbpFyKHxWQEgezllQ7kpJUded8PkHXJoJ34OR9HuwvmAu4yv6UKEKNulUIWTvgw2ubeqCvpKu 827U0ZeVZoPUW8lWnJnI6ZGFnJ0lL/EM6FbAYL0OZWViiYTwUpeN3BVVWOyIQfMVxLCuqwZR2wJE/k B59ZWSn4u8J+xyM3QHHcGn4Ixz6D5g
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

bfq_setup_cooperator() can mark bic as stably merged even though it
decides to not merge its bfqqs (when bfq_setup_merge() returns NULL).
Make sure to mark bic as stably merged only if we are really going to
merge bfqqs.

CC: stable@vger.kernel.org
Fixes: 430a67f9d616 ("block, bfq: merge bursts of newly-created queues")
Signed-off-by: Jan Kara <jack@suse.cz>
---
 block/bfq-iosched.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 2e0dd68a3cbe..6d122c28086e 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2895,9 +2895,12 @@ bfq_setup_cooperator(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 				struct bfq_queue *new_bfqq =
 					bfq_setup_merge(bfqq, stable_merge_bfqq);
 
-				bic->stably_merged = true;
-				if (new_bfqq && new_bfqq->bic)
-					new_bfqq->bic->stably_merged = true;
+				if (new_bfqq) {
+					bic->stably_merged = true;
+					if (new_bfqq->bic)
+						new_bfqq->bic->stably_merged =
+									true;
+				}
 				return new_bfqq;
 			} else
 				return NULL;
-- 
2.34.1

