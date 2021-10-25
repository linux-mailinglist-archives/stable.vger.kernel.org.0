Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0178443A2A4
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238635AbhJYTur (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:50:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:35986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238421AbhJYTsp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:48:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE5FC610C8;
        Mon, 25 Oct 2021 19:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190865;
        bh=5XFnG306azwqx4MbsIVUGXhO5EWPbqCPcdWNB2mf9GE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u0I64mY6PvpaSG7zMKqbkYYK1iuFdIHVIgjVpjiV8lqIgoeYHjwrE4QEY5Cm5WIwB
         4f/HFtBETyJ+b/6l4SyR4fSLj2M0chzirWqB3SfUNZpoJ37FpaxPApBhSL9dherJqV
         fGdtn6RmbbIBs9EJQsHwW0ET1gJX6dRWweZGHcvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+9738c8815b375ce482a1@syzkaller.appspotmail.com,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.14 090/169] blk-cgroup: blk_cgroup_bio_start() should use irq-safe operations on blkg->iostat_cpu
Date:   Mon, 25 Oct 2021 21:14:31 +0200
Message-Id: <20211025191028.594066010@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

commit 5370b0f49078203acf3c064b634a09707167a864 upstream.

c3df5fb57fe8 ("cgroup: rstat: fix A-A deadlock on 32bit around
u64_stats_sync") made u64_stats updates irq-safe to avoid A-A deadlocks.
Unfortunately, the conversion missed one in blk_cgroup_bio_start(). Fix it.

Fixes: 2d146aa3aa84 ("mm: memcontrol: switch to rstat")
Cc: stable@vger.kernel.org # v5.13+
Reported-by: syzbot+9738c8815b375ce482a1@syzkaller.appspotmail.com
Signed-off-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/YWi7NrQdVlxD6J9W@slm.duckdns.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-cgroup.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1916,10 +1916,11 @@ void blk_cgroup_bio_start(struct bio *bi
 {
 	int rwd = blk_cgroup_io_type(bio), cpu;
 	struct blkg_iostat_set *bis;
+	unsigned long flags;
 
 	cpu = get_cpu();
 	bis = per_cpu_ptr(bio->bi_blkg->iostat_cpu, cpu);
-	u64_stats_update_begin(&bis->sync);
+	flags = u64_stats_update_begin_irqsave(&bis->sync);
 
 	/*
 	 * If the bio is flagged with BIO_CGROUP_ACCT it means this is a split
@@ -1931,7 +1932,7 @@ void blk_cgroup_bio_start(struct bio *bi
 	}
 	bis->cur.ios[rwd]++;
 
-	u64_stats_update_end(&bis->sync);
+	u64_stats_update_end_irqrestore(&bis->sync, flags);
 	if (cgroup_subsys_on_dfl(io_cgrp_subsys))
 		cgroup_rstat_updated(bio->bi_blkg->blkcg->css.cgroup, cpu);
 	put_cpu();


