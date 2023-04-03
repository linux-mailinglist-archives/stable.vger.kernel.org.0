Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBD466D470D
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbjDCOQl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232943AbjDCOQk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:16:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD772C9D6
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:16:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1241DB81B81
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:16:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C660C433D2;
        Mon,  3 Apr 2023 14:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531394;
        bh=pIt2YjW4LjCyHu7GlwODLDd1ZFl1TLMnTafiZRmp8qk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jf28sPaPhJf8mAvZcFclIHeUaZcJprJcNXpiOI/IMDLmzCHyLYt74Z6As0THkCQQ8
         3ACRSwcxmPAzouo2bnaohVU2RfHQueEhuM0SW4GhJT33+6EsseR1uyWqbodOm3jNt+
         ZjRspB3+aPlo+K/KdTzKJW+v+Fp8vt//CkrTMa7M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhang Qiao <zhangqiao22@huawei.com>,
        Roman Kagan <rkagan@amazon.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 4.19 47/84] sched/fair: sanitize vruntime of entity being placed
Date:   Mon,  3 Apr 2023 16:08:48 +0200
Message-Id: <20230403140355.007537220@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140353.406927418@linuxfoundation.org>
References: <20230403140353.406927418@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qiao <zhangqiao22@huawei.com>

commit 829c1651e9c4a6f78398d3e67651cef9bb6b42cc upstream.

When a scheduling entity is placed onto cfs_rq, its vruntime is pulled
to the base level (around cfs_rq->min_vruntime), so that the entity
doesn't gain extra boost when placed backwards.

However, if the entity being placed wasn't executed for a long time, its
vruntime may get too far behind (e.g. while cfs_rq was executing a
low-weight hog), which can inverse the vruntime comparison due to s64
overflow.  This results in the entity being placed with its original
vruntime way forwards, so that it will effectively never get to the cpu.

To prevent that, ignore the vruntime of the entity being placed if it
didn't execute for much longer than the characteristic sheduler time
scale.

[rkagan: formatted, adjusted commit log, comments, cutoff value]
Signed-off-by: Zhang Qiao <zhangqiao22@huawei.com>
Co-developed-by: Roman Kagan <rkagan@amazon.de>
Signed-off-by: Roman Kagan <rkagan@amazon.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20230130122216.3555094-1-rkagan@amazon.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/fair.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3858,6 +3858,7 @@ static void
 place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 {
 	u64 vruntime = cfs_rq->min_vruntime;
+	u64 sleep_time;
 
 	/*
 	 * The 'current' period is already promised to the current tasks,
@@ -3882,8 +3883,18 @@ place_entity(struct cfs_rq *cfs_rq, stru
 		vruntime -= thresh;
 	}
 
-	/* ensure we never gain time by being placed backwards. */
-	se->vruntime = max_vruntime(se->vruntime, vruntime);
+	/*
+	 * Pull vruntime of the entity being placed to the base level of
+	 * cfs_rq, to prevent boosting it if placed backwards.  If the entity
+	 * slept for a long time, don't even try to compare its vruntime with
+	 * the base as it may be too far off and the comparison may get
+	 * inversed due to s64 overflow.
+	 */
+	sleep_time = rq_clock_task(rq_of(cfs_rq)) - se->exec_start;
+	if ((s64)sleep_time > 60LL * NSEC_PER_SEC)
+		se->vruntime = vruntime;
+	else
+		se->vruntime = max_vruntime(se->vruntime, vruntime);
 }
 
 static void check_enqueue_throttle(struct cfs_rq *cfs_rq);


