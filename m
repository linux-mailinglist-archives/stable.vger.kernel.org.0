Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED4B83CE33D
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235882AbhGSPhB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:37:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:46396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239677AbhGSPcQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:32:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDC756141C;
        Mon, 19 Jul 2021 16:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711025;
        bh=EayQJH41HGe9eO8a/AV/J7oH9DzSjk/fgRTLlqVfSI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vylTQSlIXXusVyWUkEa7ZvVqXv6irPTzFo5W4nZ+YxOZtHQjg9nFdt2db+tpmWVc4
         9tGaqiRhFC+XPBaEBDW2Uw1g0aBQNyHDxgA3934aZKBYFDBYs/J7L+LX+w4nQRnHwk
         gsUN7DHeJbEiEr+WkhExNFv/0qbm59WqyM/y22yA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunguang Xu <brookxu@tencent.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 198/351] block: fix the problem of io_ticks becoming smaller
Date:   Mon, 19 Jul 2021 16:52:24 +0200
Message-Id: <20210719144951.514220664@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
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
index 9bcdae93f6d4..ce0125efbaa7 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1253,7 +1253,7 @@ static void update_io_ticks(struct block_device *part, unsigned long now,
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



