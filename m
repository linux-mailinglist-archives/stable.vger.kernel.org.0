Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCFAC35445F
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 18:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242203AbhDEQFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 12:05:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242150AbhDEQE5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 12:04:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8F1E613CA;
        Mon,  5 Apr 2021 16:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617638691;
        bh=x+Svm0SX+1xQ/rUF6gcp89sOYiGv9YEe11FyeB6GAww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tl2hJssIt+xkW1KQga7lXOq7sxhc+Ve3rxurc5dh2oaff7U/vPZ2CXmQWt+r8cQzR
         AIs32Kc5PmWAUM1A80Sw9MmVctjVxFzdy3XnekvKkMh/THNeWoNMH+murUhqPglXux
         Um901GaDPk/TxyizQUbNx1E07x4sEMXvFuKpUvaeYTRWzHqBvhvLyieEr84Q79Ppdy
         UGg89UMdWGqBRJEYUjOrZb3AkToPWHBjqpV4MX6MWv6+h6N5GBDfFxHJCZC4hy7hQG
         qyS0v5gUPGyfpUKmxEgsARR/vPezPZfvhZPz6FMTLlthUWuaLwttXxwuX2K6Cn9Fhz
         XY2BNoS54EtMw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Chris von Recklinghausen <crecklin@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 16/22] idr test suite: Take RCU read lock in idr_find_test_1
Date:   Mon,  5 Apr 2021 12:04:25 -0400
Message-Id: <20210405160432.268374-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405160432.268374-1-sashal@kernel.org>
References: <20210405160432.268374-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

[ Upstream commit 703586410da69eb40062e64d413ca33bd735917a ]

When run on a single CPU, this test would frequently access already-freed
memory.  Due to timing, this bug never showed up on multi-CPU tests.

Reported-by: Chris von Recklinghausen <crecklin@redhat.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/radix-tree/idr-test.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/radix-tree/idr-test.c b/tools/testing/radix-tree/idr-test.c
index 44ceff95a9b3..4a9b451b7ba0 100644
--- a/tools/testing/radix-tree/idr-test.c
+++ b/tools/testing/radix-tree/idr-test.c
@@ -306,11 +306,15 @@ void idr_find_test_1(int anchor_id, int throbber_id)
 	BUG_ON(idr_alloc(&find_idr, xa_mk_value(anchor_id), anchor_id,
 				anchor_id + 1, GFP_KERNEL) != anchor_id);
 
+	rcu_read_lock();
 	do {
 		int id = 0;
 		void *entry = idr_get_next(&find_idr, &id);
+		rcu_read_unlock();
 		BUG_ON(entry != xa_mk_value(id));
+		rcu_read_lock();
 	} while (time(NULL) < start + 11);
+	rcu_read_unlock();
 
 	pthread_join(throbber, NULL);
 
-- 
2.30.2

