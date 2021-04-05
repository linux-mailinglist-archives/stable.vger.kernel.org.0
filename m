Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B62C3544A6
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 18:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242011AbhDEQFt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 12:05:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:57960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238646AbhDEQFR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 12:05:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6B3A613DC;
        Mon,  5 Apr 2021 16:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617638711;
        bh=x+Svm0SX+1xQ/rUF6gcp89sOYiGv9YEe11FyeB6GAww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hc4afGb1Ans9Vi2THPrNrFmgh/SCbeKyshhiR2qw9KbTBe/T90Bf4vYm+EjvAFHKQ
         LIfbnjpsbL5kHd0+qLk5FnoEdA3reQ54K5D6Jr1oixZ33KK89TdSjddXKSuRTALHhz
         o8Z2ry+L5YErQG2hORLo5S0i0/oT4gpRspW0zTAhHqQMGJAYxLIx2HzfqJKMvHOUYF
         VPibc182EQAekxfkWCW6g7cmx4rJ9XAdz5Lk/FSr/Vt/Q2Dc87Df2X1bKTYjnJrnhx
         1QIcYxdkNrJeS/VUGzpSiKL0f3fTZ6Grnfh8GODM2xcKlj6xdFS4dOREBQ2nXDewHh
         aaS+Mz80cS8og==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Chris von Recklinghausen <crecklin@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 10/13] idr test suite: Take RCU read lock in idr_find_test_1
Date:   Mon,  5 Apr 2021 12:04:55 -0400
Message-Id: <20210405160459.268794-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405160459.268794-1-sashal@kernel.org>
References: <20210405160459.268794-1-sashal@kernel.org>
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

