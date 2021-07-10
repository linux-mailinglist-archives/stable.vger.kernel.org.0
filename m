Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1123C37ED
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232715AbhGJXxX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:53:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:39214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233049AbhGJXxA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:53:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B669613B0;
        Sat, 10 Jul 2021 23:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961014;
        bh=hN3qtU0dLgxD/1mxx142hFxbzrWbDbvSfmOPg1RvgpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=de250sT9U1Y5a3AL+V+fvdWHhwSijcMWmchVzAB8sNH1Cgc3zNVqKfzurnDpxy0m6
         20314aSfZjkxrbrCowH8CTQV3Qv+wHiEbi2uH/E5UXVGyV4/g26wizcPhQmMHp5EfJ
         pbRC5Y75i1d4EAWDQ6z5iYvYgw9FORmrnlySkZxhCj6ym6BdUNoNMWDsEWLBLNa99K
         qkdC4gQEDfjBPOmowYkIaRxeslQZlOxEgvsyceDgUA7IgsNp/rNyISPFZfNJXJCyMf
         +DZPPBlGoG0XiTnn/yGnUb9SDEKzNBFOjTDBc6j3pwsxBteC4nmk6Q7RT8rR6YT7Zn
         QZ5qWBkAKNVQw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chunguang Xu <brookxu@tencent.com>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 43/43] block: fix the problem of io_ticks becoming smaller
Date:   Sat, 10 Jul 2021 19:49:15 -0400
Message-Id: <20210710234915.3220342-43-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710234915.3220342-1-sashal@kernel.org>
References: <20210710234915.3220342-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

