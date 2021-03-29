Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B99234C9CF
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232512AbhC2Idx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:33:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233410AbhC2IbQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:31:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09B1361582;
        Mon, 29 Mar 2021 08:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006675;
        bh=O/0q2JjobzsUmuE+dvnraPV+i669n5v5EMZTYrRvoEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ePtLylfHFdCiIheo3IJ8lbEeFNgvayR1ZrXmg+XYcgDx3FfkiUCAgtczt6gxr27nQ
         ds7Bkv3u1cF1cexGxnVM6wtHUeRWWC9Z/6a8/zf0TlndVKB4Wx2w9lUZ+JYS288ddV
         jJj9oggW6wVk3cSKJl045+eIyvLO/po3xhI43hIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xunlei Pang <xlpang@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 012/254] blk-cgroup: Fix the recursive blkg rwstat
Date:   Mon, 29 Mar 2021 09:55:28 +0200
Message-Id: <20210329075633.554721977@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xunlei Pang <xlpang@linux.alibaba.com>

[ Upstream commit 4f44657d74873735e93a50eb25014721a66aac19 ]

The current blkio.throttle.io_service_bytes_recursive doesn't
work correctly.

As an example, for the following blkcg hierarchy:
 (Made 1GB READ in test1, 512MB READ in test2)
     test
    /    \
 test1   test2

$ head -n 1 test/test1/blkio.throttle.io_service_bytes_recursive
8:0 Read 1073684480
$ head -n 1 test/test2/blkio.throttle.io_service_bytes_recursive
8:0 Read 537448448
$ head -n 1 test/blkio.throttle.io_service_bytes_recursive
8:0 Read 537448448

Clearly, above data of "test" reflects "test2" not "test1"+"test2".

Do the correct summary in blkg_rwstat_recursive_sum().

Signed-off-by: Xunlei Pang <xlpang@linux.alibaba.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup-rwstat.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk-cgroup-rwstat.c b/block/blk-cgroup-rwstat.c
index 85d5790ac49b..3304e841df7c 100644
--- a/block/blk-cgroup-rwstat.c
+++ b/block/blk-cgroup-rwstat.c
@@ -109,6 +109,7 @@ void blkg_rwstat_recursive_sum(struct blkcg_gq *blkg, struct blkcg_policy *pol,
 
 	lockdep_assert_held(&blkg->q->queue_lock);
 
+	memset(sum, 0, sizeof(*sum));
 	rcu_read_lock();
 	blkg_for_each_descendant_pre(pos_blkg, pos_css, blkg) {
 		struct blkg_rwstat *rwstat;
@@ -122,7 +123,7 @@ void blkg_rwstat_recursive_sum(struct blkcg_gq *blkg, struct blkcg_policy *pol,
 			rwstat = (void *)pos_blkg + off;
 
 		for (i = 0; i < BLKG_RWSTAT_NR; i++)
-			sum->cnt[i] = blkg_rwstat_read_counter(rwstat, i);
+			sum->cnt[i] += blkg_rwstat_read_counter(rwstat, i);
 	}
 	rcu_read_unlock();
 }
-- 
2.30.1



