Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A30D44A0F8
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239554AbhKIBGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:06:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:60234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235467AbhKIBEr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:04:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D001A61361;
        Tue,  9 Nov 2021 01:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419709;
        bh=YIDfyMe4cUL93m/SuX3dbGQJGasKYmJkLMRxBkNVSQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iDeUEsXgG23CXf6uT5jRahujpOYlddPTsfoPe0e2zrgMj8yE8gwCeBpxbENvRSjyc
         QHlhIdkMgZqm/yOIj6Pic4j79cnbfxPXf1XpddwQKNj8OGqtMNC5h+oNZAkidRZ0fc
         shBltXOwu7Tnv2eE1lqZtETPqRqL6CFrofI+FV14QsjLFQyYFVGqnDKxY6PKZNqxrp
         hBDVeJuiOog4CTKLItGNKdurdpKyWmf6m1w0TdCuq6V+Ly9DQFFnjOnZEYff7iALOw
         FQ6HqB8xg0Ukk8SNbmJd/H4peePZk3HRCfiX9nBL9L2Q8fVJi5dH5LNYbS/+pDCB0/
         N+bO+qWnhIWDA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        will@kernel.org
Subject: [PATCH AUTOSEL 5.14 012/138] locking/lockdep: Avoid RCU-induced noinstr fail
Date:   Mon,  8 Nov 2021 12:44:38 -0500
Message-Id: <20211108174644.1187889-12-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174644.1187889-1-sashal@kernel.org>
References: <20211108174644.1187889-1-sashal@kernel.org>
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
index bf1c00c881e48..8a509672a4cc9 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -888,7 +888,7 @@ look_up_lock_class(const struct lockdep_map *lock, unsigned int subclass)
 	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
 		return NULL;
 
-	hlist_for_each_entry_rcu(class, hash_head, hash_entry) {
+	hlist_for_each_entry_rcu_notrace(class, hash_head, hash_entry) {
 		if (class->key == key) {
 			/*
 			 * Huh! same key, different name? Did someone trample
-- 
2.33.0

