Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5493344A2A5
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242655AbhKIBTv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:19:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:44370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236838AbhKIBRR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:17:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F02C161AEE;
        Tue,  9 Nov 2021 01:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636420021;
        bh=MONHKaE1Shr4/p9mTgmL0HzssTSE32eQycoFwXU3yW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fjj9+0/AFhOP2iPp2RelD7NAglbN3rR4GgQPOQdkUwstOg0LNum5HSPJCjDlzgsxD
         eVI3XzNpsrciXl7N2iN7dIyKNjh5QP2wOFkZ4dJSTBhMqRSa7Sg+81t4/S1Y2eiS4o
         OM+blgTCuIjG6HyMO0Ps9mTRNXkuBc3EdKTVboHmAu8e4ysn8UyfqQ4P+8052YagO5
         Hiqwq2SHxqhOa66pZmNY/T26EC1vsNoHmYcK/dD9urHIyaX9Mn95fk4qBZ8LKLxKaw
         v7fqAp1fZY5IrlURdnzFfYKXneIwY+sCkvOZsrCS3uVHb/4+yuAlKEbzyqqmz5NgYw
         j+v11dHVWRa6A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        will@kernel.org
Subject: [PATCH AUTOSEL 4.14 06/39] locking/lockdep: Avoid RCU-induced noinstr fail
Date:   Mon,  8 Nov 2021 20:06:16 -0500
Message-Id: <20211109010649.1191041-6-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109010649.1191041-1-sashal@kernel.org>
References: <20211109010649.1191041-1-sashal@kernel.org>
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
index 03e3ab61a2edd..ac0725b1ada75 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -713,7 +713,7 @@ look_up_lock_class(struct lockdep_map *lock, unsigned int subclass)
 	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
 		return NULL;
 
-	hlist_for_each_entry_rcu(class, hash_head, hash_entry) {
+	hlist_for_each_entry_rcu_notrace(class, hash_head, hash_entry) {
 		if (class->key == key) {
 			/*
 			 * Huh! same key, different name? Did someone trample
-- 
2.33.0

