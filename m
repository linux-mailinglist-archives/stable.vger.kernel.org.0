Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDC96AE87B
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbjCGRQH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:16:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbjCGRPm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:15:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 432FB94A61
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:11:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2D4BB8199A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:11:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45BFBC433EF;
        Tue,  7 Mar 2023 17:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209085;
        bh=x615Eig+2u2KTTZ4IJAVCKtXMpVU2WTJvZyHG95cn0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yi7vxUwleJ7xMFzsju6NPx4ZEAGl/gqGeBdqpjgpTRfJ1FeK3X2jze89ioTEvu7lL
         GITBHuGSMiV11U+0+G1fsnY5Rn60oFNifusU8QF7tGeZuUESqZlbWLeZ+zwwE5dDWA
         K7Jfk6sDuo7DAtYUi++0uYD81av3YZlyVbuWurBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Kemeng Shi <shikemeng@huaweicloud.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0106/1001] blk-mq: avoid sleep in blk_mq_alloc_request_hctx
Date:   Tue,  7 Mar 2023 17:47:58 +0100
Message-Id: <20230307170026.733142946@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit 6ee858a3d3270a68902d66bb47c151a83622535c ]

Commit 1f5bd336b9150 ("blk-mq: add blk_mq_alloc_request_hctx") add
blk_mq_alloc_request_hctx to send commands to a specific queue. If
BLK_MQ_REQ_NOWAIT is not set in tag allocation, we may change to different
hctx after sleep and get tag from unexpected hctx. So BLK_MQ_REQ_NOWAIT
must be set in flags for blk_mq_alloc_request_hctx.
After commit 600c3b0cea784 ("blk-mq: open code __blk_mq_alloc_request in
blk_mq_alloc_request_hctx"), blk_mq_alloc_request_hctx return -EINVAL
if both BLK_MQ_REQ_NOWAIT and BLK_MQ_REQ_RESERVED are not set instead of
if BLK_MQ_REQ_NOWAIT is not set. So if BLK_MQ_REQ_NOWAIT is not set and
BLK_MQ_REQ_RESERVED is set, blk_mq_alloc_request_hctx could alloc tag
from unexpected hctx. I guess what we need here is that return -EINVAL
if either BLK_MQ_REQ_NOWAIT or BLK_MQ_REQ_RESERVED is not set.

Currently both BLK_MQ_REQ_NOWAIT and BLK_MQ_REQ_RESERVED will be set if
specific hctx is needed in nvme_auth_submit, nvmf_connect_io_queue
and nvmf_connect_admin_queue. Fix the potential BLK_MQ_REQ_NOWAIT missed
case in future.

Fixes: 600c3b0cea78 ("blk-mq: open code __blk_mq_alloc_request in blk_mq_alloc_request_hctx")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 9c8dc70020bc9..dc29a7c82bb82 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -658,7 +658,8 @@ struct request *blk_mq_alloc_request_hctx(struct request_queue *q,
 	 * allocator for this for the rare use case of a command tied to
 	 * a specific queue.
 	 */
-	if (WARN_ON_ONCE(!(flags & (BLK_MQ_REQ_NOWAIT | BLK_MQ_REQ_RESERVED))))
+	if (WARN_ON_ONCE(!(flags & BLK_MQ_REQ_NOWAIT)) ||
+	    WARN_ON_ONCE(!(flags & BLK_MQ_REQ_RESERVED)))
 		return ERR_PTR(-EINVAL);
 
 	if (hctx_idx >= q->nr_hw_queues)
-- 
2.39.2



