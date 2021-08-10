Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFC3A3E7EED
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbhHJRgI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:36:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:43252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232922AbhHJRfG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:35:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5461F61019;
        Tue, 10 Aug 2021 17:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616883;
        bh=QT8WDrtLTOazFFsZarpCkRObMPa0NPlyyOzmsPPAPrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O1300PzbVK//W8ZO8VNQbB1ZcAPd9q2lWu8rUE+N+fNKtvK18QFhYDWI5UcwMfE7O
         2jg6TvciQtvYeE/OYNIm3F1Us4NfHqzM6VOO3N6nBf/RXkX+zNQ2PLxS01nJVjwOuF
         BCEV2IcM4peOlnvFzjhQnnibWynsoGxkP1kbWA5U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 34/85] blk-iolatency: error out if blk_get_queue() failed in iolatency_set_limit()
Date:   Tue, 10 Aug 2021 19:30:07 +0200
Message-Id: <20210810172949.354530109@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172948.192298392@linuxfoundation.org>
References: <20210810172948.192298392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 8d75d0eff6887bcac7225e12b9c75595e523d92d ]

If queue is dying while iolatency_set_limit() is in progress,
blk_get_queue() won't increment the refcount of the queue. However,
blk_put_queue() will still decrement the refcount later, which will
cause the refcout to be unbalanced.

Thus error out in such case to fix the problem.

Fixes: 8c772a9bfc7c ("blk-iolatency: fix IO hang due to negative inflight counter")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20210805124645.543797-1-yukuai3@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iolatency.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index c128d50cb410..71a82528d4bf 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -832,7 +832,11 @@ static ssize_t iolatency_set_limit(struct kernfs_open_file *of, char *buf,
 
 	enable = iolatency_set_min_lat_nsec(blkg, lat_val);
 	if (enable) {
-		WARN_ON_ONCE(!blk_get_queue(blkg->q));
+		if (!blk_get_queue(blkg->q)) {
+			ret = -ENODEV;
+			goto out;
+		}
+
 		blkg_get(blkg);
 	}
 
-- 
2.30.2



