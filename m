Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9AF417504
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346003AbhIXNOI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:14:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:38152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346575AbhIXNLA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:11:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D9886124D;
        Fri, 24 Sep 2021 12:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488301;
        bh=b0/oDv20ftYzb0FTC6s+Eeyu7r6/ampOJ6XBdVGYDtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UeWOXVEE17j7Svrt8d6RkBbqF7QVTn0QL7UX/P71nAEMzxom21BVvaO3EFT+efmzZ
         Ls6MNSAq5e1jjTeHw9HZgZQP6IcpCqHNZPrmJsP4H2q74l7M91lTk1Q2GwMzVCoD92
         yudugn2zJwgNBbw4OIAxj/ffGTycCsZS7CCWVQ/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marcin Wanat <marcin.wanat@gmail.com>,
        Song Liu <songliubraving@fb.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 60/63] blk-mq: allow 4x BLK_MAX_REQUEST_COUNT at blk_plug for multiple_queues
Date:   Fri, 24 Sep 2021 14:45:00 +0200
Message-Id: <20210924124336.327864479@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124334.228235870@linuxfoundation.org>
References: <20210924124334.228235870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Song Liu <songliubraving@fb.com>

[ Upstream commit 7f2a6a69f7ced6db8220298e0497cf60482a9d4b ]

Limiting number of request to BLK_MAX_REQUEST_COUNT at blk_plug hurts
performance for large md arrays. [1] shows resync speed of md array drops
for md array with more than 16 HDDs.

Fix this by allowing more request at plug queue. The multiple_queue flag
is used to only apply higher limit to multiple queue cases.

[1] https://lore.kernel.org/linux-raid/CAFDAVznS71BXW8Jxv6k9dXc2iR3ysX3iZRBww_rzA8WifBFxGg@mail.gmail.com/
Tested-by: Marcin Wanat <marcin.wanat@gmail.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 9e3fedbaa644..6dcb86c1c985 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2109,6 +2109,18 @@ static void blk_add_rq_to_plug(struct blk_plug *plug, struct request *rq)
 	}
 }
 
+/*
+ * Allow 4x BLK_MAX_REQUEST_COUNT requests on plug queue for multiple
+ * queues. This is important for md arrays to benefit from merging
+ * requests.
+ */
+static inline unsigned short blk_plug_max_rq_count(struct blk_plug *plug)
+{
+	if (plug->multiple_queues)
+		return BLK_MAX_REQUEST_COUNT * 4;
+	return BLK_MAX_REQUEST_COUNT;
+}
+
 /**
  * blk_mq_submit_bio - Create and send a request to block device.
  * @bio: Bio pointer.
@@ -2202,7 +2214,7 @@ blk_qc_t blk_mq_submit_bio(struct bio *bio)
 		else
 			last = list_entry_rq(plug->mq_list.prev);
 
-		if (request_count >= BLK_MAX_REQUEST_COUNT || (last &&
+		if (request_count >= blk_plug_max_rq_count(plug) || (last &&
 		    blk_rq_bytes(last) >= BLK_PLUG_FLUSH_SIZE)) {
 			blk_flush_plug_list(plug, false);
 			trace_block_plug(q);
-- 
2.33.0



