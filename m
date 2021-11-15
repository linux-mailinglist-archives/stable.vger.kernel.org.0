Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD3C24527B3
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243452AbhKPCaG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:30:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:38928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236985AbhKORRX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:17:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 766CF63251;
        Mon, 15 Nov 2021 17:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996391;
        bh=aTWdgHCGfZpTL5f3BpDC0k5lCuUr3n6/EyanIOC7mZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hKHb3rb0P3CZ6f4edWOWnGIRYOFlxb9EvYzW2ImeDXHdMrx5RWKe6Qa5sNBcemVr4
         eZJrac6omVlgM+rEu8IAFS1tRzjFE6d3S8xzC72JZkdtGoZbu6xpz6BQVNJJnaaZg1
         fAEfCWG+iKCYFdU0RyyFiMxaJnwJQ/EPdmu+ixPU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 122/355] locking/lockdep: Avoid RCU-induced noinstr fail
Date:   Mon, 15 Nov 2021 18:00:46 +0100
Message-Id: <20211115165317.761237547@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 3ec8fd2e80e53..db109d38f301e 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -830,7 +830,7 @@ look_up_lock_class(const struct lockdep_map *lock, unsigned int subclass)
 	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
 		return NULL;
 
-	hlist_for_each_entry_rcu(class, hash_head, hash_entry) {
+	hlist_for_each_entry_rcu_notrace(class, hash_head, hash_entry) {
 		if (class->key == key) {
 			/*
 			 * Huh! same key, different name? Did someone trample
-- 
2.33.0



