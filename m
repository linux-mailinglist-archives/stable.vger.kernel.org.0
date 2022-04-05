Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 781DA4F353F
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347669AbiDEJ2H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244747AbiDEIwh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:52:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B1F140E9;
        Tue,  5 Apr 2022 01:43:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D92BBB81BC5;
        Tue,  5 Apr 2022 08:43:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AFC0C385A1;
        Tue,  5 Apr 2022 08:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148191;
        bh=fCtaAU0Jwkpe5VJXjEJlmk4GWzEwU3EnMdsNKAGNJQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gaUwhU7iKrxipl9v8vCnau38AGrJJh+f9EDnfs+zqafj6P7K6D19NzAs992uegMC5
         VvGFW9uZEbXFLmTfssduyfD98LKBBRZgXOVXe6y6D3z21TGej+GZKxAY0lgAs9rGRl
         jAPToL3TKMUzhf67eQTe5vDAb1neibES8jrqKU8o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chengming Zhou <zhouchengming@bytedance.com>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0218/1017] blk-cgroup: set blkg iostat after percpu stat aggregation
Date:   Tue,  5 Apr 2022 09:18:51 +0200
Message-Id: <20220405070400.722250723@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chengming Zhou <zhouchengming@bytedance.com>

[ Upstream commit f122d103b564e5fb7c82de902c6f8f6cbdf50ec9 ]

Don't need to do blkg_iostat_set for top blkg iostat on each CPU,
so move it after percpu stat aggregation.

Fixes: ef45fe470e1e ("blk-cgroup: show global disk stats in root cgroup io.stat")
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20220213085902.88884-1-zhouchengming@bytedance.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 663aabfeba18..f896f4982665 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -856,11 +856,11 @@ static void blkcg_fill_root_iostats(void)
 			blk_queue_root_blkg(bdev_get_queue(bdev));
 		struct blkg_iostat tmp;
 		int cpu;
+		unsigned long flags;
 
 		memset(&tmp, 0, sizeof(tmp));
 		for_each_possible_cpu(cpu) {
 			struct disk_stats *cpu_dkstats;
-			unsigned long flags;
 
 			cpu_dkstats = per_cpu_ptr(bdev->bd_stats, cpu);
 			tmp.ios[BLKG_IOSTAT_READ] +=
@@ -876,11 +876,11 @@ static void blkcg_fill_root_iostats(void)
 				cpu_dkstats->sectors[STAT_WRITE] << 9;
 			tmp.bytes[BLKG_IOSTAT_DISCARD] +=
 				cpu_dkstats->sectors[STAT_DISCARD] << 9;
-
-			flags = u64_stats_update_begin_irqsave(&blkg->iostat.sync);
-			blkg_iostat_set(&blkg->iostat.cur, &tmp);
-			u64_stats_update_end_irqrestore(&blkg->iostat.sync, flags);
 		}
+
+		flags = u64_stats_update_begin_irqsave(&blkg->iostat.sync);
+		blkg_iostat_set(&blkg->iostat.cur, &tmp);
+		u64_stats_update_end_irqrestore(&blkg->iostat.sync, flags);
 	}
 }
 
-- 
2.34.1



