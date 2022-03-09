Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3885C4D2911
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 07:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbiCIGnu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 9 Mar 2022 01:43:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbiCIGnq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 01:43:46 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E190A88AB
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 22:42:45 -0800 (PST)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 228Iormc017320
        for <stable@vger.kernel.org>; Tue, 8 Mar 2022 22:42:45 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ep52tq76w-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 08 Mar 2022 22:42:44 -0800
Received: from twshared33837.14.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Mar 2022 22:42:43 -0800
Received: by devbig932.frc1.facebook.com (Postfix, from userid 4523)
        id 1FC6D1EBC0D9; Tue,  8 Mar 2022 22:42:40 -0800 (PST)
From:   Song Liu <song@kernel.org>
To:     <linux-block@vger.kernel.org>, <linux-raid@vger.kernel.org>
CC:     <axboe@kernel.dk>, Song Liu <song@kernel.org>,
        <stable@vger.kernel.org>,
        Larkin Lowrey <llowrey@nuclearwinter.com>,
        Wilson Jonathan <i400sjon@gmail.com>,
        Roger Heflin <rogerheflin@gmail.com>
Subject: [PATCH] block: check more requests for multiple_queues in blk_attempt_plug_merge
Date:   Tue, 8 Mar 2022 22:42:09 -0800
Message-ID: <20220309064209.4169303-1-song@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: KvP5pjHo3SCQT0eRVoTwftZzMgQIXkeH
X-Proofpoint-GUID: KvP5pjHo3SCQT0eRVoTwftZzMgQIXkeH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-09_02,2022-03-04_01,2022-02-23_01
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RAID arrays check/repair operations benefit a lot from merging requests.
If we only check the previous entry for merge attempt, many merge will be
missed. As a result, significant regression is observed for RAID check
and repair.

Fix this by checking more than just the previous entry when
plug->multiple_queues == true.

This improves the check/repair speed of a 20-HDD raid6 from 19 MB/s to
103 MB/s.

Fixes: d38a9c04c0d5 ("block: only check previous entry for plug merge attempt")
Cc: stable@vger.kernel.org # v5.16
Reported-by: Larkin Lowrey <llowrey@nuclearwinter.com>
Reported-by: Wilson Jonathan <i400sjon@gmail.com>
Reported-by: Roger Heflin <rogerheflin@gmail.com>
Signed-off-by: Song Liu <song@kernel.org>
---
 block/blk-merge.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 4de34a332c9f..57e2075fb2f4 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -1089,12 +1089,14 @@ bool blk_attempt_plug_merge(struct request_queue *q, struct bio *bio,
 	if (!plug || rq_list_empty(plug->mq_list))
 		return false;
 
-	/* check the previously added entry for a quick merge attempt */
-	rq = rq_list_peek(&plug->mq_list);
-	if (rq->q == q) {
-		if (blk_attempt_bio_merge(q, rq, bio, nr_segs, false) ==
-				BIO_MERGE_OK)
-			return true;
+	rq_list_for_each(&plug->mq_list, rq) {
+		if (rq->q == q) {
+			if (blk_attempt_bio_merge(q, rq, bio, nr_segs, false) ==
+			    BIO_MERGE_OK)
+				return true;
+		}
+		if (!plug->multiple_queues)
+			break;
 	}
 	return false;
 }
-- 
2.30.2

