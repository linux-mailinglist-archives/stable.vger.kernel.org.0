Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA0AA45BD54
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243810AbhKXMh1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:37:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:35696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344120AbhKXMfX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:35:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F1F861175;
        Wed, 24 Nov 2021 12:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756494;
        bh=MONHKaE1Shr4/p9mTgmL0HzssTSE32eQycoFwXU3yW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pOVnJmDOuNjbwQlJcou4MMVzjMf65VTL9ckPMA/0qgEbvkzoKx3jiqgoF2f1J5WBt
         jZCND2tkGl4En5EMyE3ty+6anDMZu9eipeQzsJm/TOgjmqg6eSy/GwWcp4sBkRAQQ9
         6fr/bSeaUjtinxRLHE2M6RoZNSUpWYccaVHYjIE4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 073/251] locking/lockdep: Avoid RCU-induced noinstr fail
Date:   Wed, 24 Nov 2021 12:55:15 +0100
Message-Id: <20211124115712.788823441@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
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



