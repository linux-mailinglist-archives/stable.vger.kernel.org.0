Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF4F1AED81
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 15:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgDRNsv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 09:48:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:55368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726575AbgDRNst (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Apr 2020 09:48:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98B0322202;
        Sat, 18 Apr 2020 13:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587217729;
        bh=no3knKj15K/kqw5BYs/rcA1+Ow+Jsr8lPJT0094hSSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1hawU1YCkLOUl6CsFQSxB5PvHLRV2oUr+qBq4ivcf8HtwKDoMfwe52cCQ4/ZWpsx5
         KpK1z7YBX40ivHQcyIao+mU3gLiJY1JhAegac1NNujMim+h0vSYhPgk4Xd06A+kAhq
         U2Rv1TYBoFkowvOwVqjgSX6+xEQ9SUg0x9PBbRE4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasily Averin <vvs@virtuozzo.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Ingo Molnar <mingo@redhat.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        NeilBrown <neilb@suse.com>, Steven Rostedt <rostedt@goodmis.org>,
        Waiman Long <longman@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.6 27/73] kernel/gcov/fs.c: gcov_seq_next() should increase position index
Date:   Sat, 18 Apr 2020 09:47:29 -0400
Message-Id: <20200418134815.6519-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418134815.6519-1-sashal@kernel.org>
References: <20200418134815.6519-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

[ Upstream commit f4d74ef6220c1eda0875da30457bef5c7111ab06 ]

If seq_file .next function does not change position index, read after
some lseek can generate unexpected output.

https://bugzilla.kernel.org/show_bug.cgi?id=206283
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: NeilBrown <neilb@suse.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Waiman Long <longman@redhat.com>
Link: http://lkml.kernel.org/r/f65c6ee7-bd00-f910-2f8a-37cc67e4ff88@virtuozzo.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/gcov/fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/gcov/fs.c b/kernel/gcov/fs.c
index e5eb5ea7ea598..cc4ee482d3fba 100644
--- a/kernel/gcov/fs.c
+++ b/kernel/gcov/fs.c
@@ -108,9 +108,9 @@ static void *gcov_seq_next(struct seq_file *seq, void *data, loff_t *pos)
 {
 	struct gcov_iterator *iter = data;
 
+	(*pos)++;
 	if (gcov_iter_next(iter))
 		return NULL;
-	(*pos)++;
 
 	return iter;
 }
-- 
2.20.1

