Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12BF544A32C
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242131AbhKIB0R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:26:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:50180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243376AbhKIBVS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:21:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EE9C61B23;
        Tue,  9 Nov 2021 01:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636420099;
        bh=vt/kUNrq1/PKDVlv0B4kdHte0XI2Dw16MpAuLTNk32c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P17ruOj4WToKZqHYBUzPQJSgakMzFtITUVXPjtjGg2J8o9z9AtUrqkUc1e7kkdra7
         xfA54vNvd/aCW+yuX2+lCdTxjPtjvD996FlcviYJbVgBYGR9XGOZmDfWZsEM9Or4zt
         G+KMMDjKY0JVPpyFAQtQ9XVyCWuVJVEUn0ejTLus+RIc/mVgGIUSU4sAcrzLRSEc2N
         AhjFTcK1UzdXOnaJYsKW9syqJo215vmolmi++V47eGJygkIVLal4jvGobnqobdv3K/
         hHVBArU7HyDh2dlQX0B0xdtQNIimPZk3J3CF0rGynaL3+valg5+wlYS1rOSE0Aa4SC
         AmYYOsNS3Hu6Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        will@kernel.org
Subject: [PATCH AUTOSEL 4.9 06/33] locking/lockdep: Avoid RCU-induced noinstr fail
Date:   Mon,  8 Nov 2021 20:07:40 -0500
Message-Id: <20211109010807.1191567-6-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109010807.1191567-1-sashal@kernel.org>
References: <20211109010807.1191567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit ce0b9c805dd66d5e49fd53ec5415ae398f4c56e6 ]

vmlinux.o: warning: objtool: look_up_lock_class()+0xc7: call to rcu_read_lock_any_held() leaves .noinstr.text section

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20210624095148.311980536@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/lockdep.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 9f56e3fac795a..05dd765e2cbca 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -695,7 +695,7 @@ look_up_lock_class(struct lockdep_map *lock, unsigned int subclass)
 	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
 		return NULL;
 
-	hlist_for_each_entry_rcu(class, hash_head, hash_entry) {
+	hlist_for_each_entry_rcu_notrace(class, hash_head, hash_entry) {
 		if (class->key == key) {
 			/*
 			 * Huh! same key, different name? Did someone trample
-- 
2.33.0

