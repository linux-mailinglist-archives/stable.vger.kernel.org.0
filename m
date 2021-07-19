Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17E043CE54C
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347294AbhGSPsh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:48:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:46056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349411AbhGSPpE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:45:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE777613ED;
        Mon, 19 Jul 2021 16:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711896;
        bh=hN3qtU0dLgxD/1mxx142hFxbzrWbDbvSfmOPg1RvgpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eBDk0aUDx42skdXOATcJkh8IHFYJ2f1YlQoTrK2sQBBfs8tv99YKRBEDL/sFFz3nN
         20u3gm+NVYzMarZvvyEySLaM8t6NIgBQpCGqKo57ieerWu+eRQzMz9e04HfqTyJAQO
         05axpKjSjYGfObAX6Z2sbJ6svlYpTnAHlAahV6B4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunguang Xu <brookxu@tencent.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 172/292] block: fix the problem of io_ticks becoming smaller
Date:   Mon, 19 Jul 2021 16:53:54 +0200
Message-Id: <20210719144948.159839018@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunguang Xu <brookxu@tencent.com>

[ Upstream commit d80c228d44640f0b47b57a2ca4afa26ef87e16b0 ]

On the IO submission path, blk_account_io_start() may interrupt
the system interruption. When the interruption returns, the value
of part->stamp may have been updated by other cores, so the time
value collected before the interruption may be less than part->
stamp. So when this happens, we should do nothing to make io_ticks
more accurate? For kernels less than 5.0, this may cause io_ticks
to become smaller, which in turn may cause abnormal ioutil values.

Signed-off-by: Chunguang Xu <brookxu@tencent.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/1625521646-1069-1-git-send-email-brookxu.cn@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index fc60ff208497..e34dfa13b7bc 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1255,7 +1255,7 @@ static void update_io_ticks(struct block_device *part, unsigned long now,
 	unsigned long stamp;
 again:
 	stamp = READ_ONCE(part->bd_stamp);
-	if (unlikely(stamp != now)) {
+	if (unlikely(time_after(now, stamp))) {
 		if (likely(cmpxchg(&part->bd_stamp, stamp, now) == stamp))
 			__part_stat_add(part, io_ticks, end ? now - stamp : 1);
 	}
-- 
2.30.2



