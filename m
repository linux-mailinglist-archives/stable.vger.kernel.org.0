Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3B4D63DF94
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbiK3Ssu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:48:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbiK3Ssc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:48:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2EC2FA53
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:48:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BB1D61D85
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:48:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B039C433C1;
        Wed, 30 Nov 2022 18:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834110;
        bh=rtudHmHhc01+/aPmQNfd0ptQQKzu93QwJRAILq+diAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vkHl33BDKHc0nWOM3WF4r41pMf0EzahONq2+zb/b5/+q6m5GShwupSL2rVGxGq5kw
         VCBSNj7av+ljaLxHhSzXzNzZD13RWUV2Vef8QA6kUPt0Fn7ExWvt+9lqBT1hnY/E3w
         JrbHudkR9mBS6mQeY4akMXVhuKfT0y78E+nG4mu4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 132/289] blk-mq: fix queue reference leak on blk_mq_alloc_disk_for_queue failure
Date:   Wed, 30 Nov 2022 19:21:57 +0100
Message-Id: <20221130180547.131336154@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 22c17e279a1b03bad7987e4a4192b289b890f293 ]

Drop the request queue reference just acquired when __alloc_disk_node
failed.

Fixes: 6f8191fdf41d ("block: simplify disk shutdown")
Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Link: https://lore.kernel.org/r/20221122072753.426077-1-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 4402e4ecb8b1..3f1f5e3e0951 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3956,9 +3956,14 @@ EXPORT_SYMBOL(__blk_mq_alloc_disk);
 struct gendisk *blk_mq_alloc_disk_for_queue(struct request_queue *q,
 		struct lock_class_key *lkclass)
 {
+	struct gendisk *disk;
+
 	if (!blk_get_queue(q))
 		return NULL;
-	return __alloc_disk_node(q, NUMA_NO_NODE, lkclass);
+	disk = __alloc_disk_node(q, NUMA_NO_NODE, lkclass);
+	if (!disk)
+		blk_put_queue(q);
+	return disk;
 }
 EXPORT_SYMBOL(blk_mq_alloc_disk_for_queue);
 
-- 
2.35.1



