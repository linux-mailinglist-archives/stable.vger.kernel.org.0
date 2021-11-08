Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 566FA44A1DF
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236380AbhKIBM5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:12:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:40982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241792AbhKIBKw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:10:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6146B61A88;
        Tue,  9 Nov 2021 01:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419885;
        bh=aTWdgHCGfZpTL5f3BpDC0k5lCuUr3n6/EyanIOC7mZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S0Z9DDOeSGG4in9kEG3xQzkdxpEZWZmGCpj8PtPxfy7CJz0ShkA0v7RdmG/5W/OhE
         utfGxftAI7UC6aBBFjsXljr6IfqZ5fD/bRXsyzOLwePE1igwz171Ek3ATU53p8n2Ds
         sgrxYWboRZoMg9Q9h4K4W5bk1tEbqq5WnPRIE65cTFlmMCPt/BZ5XvVTDRmrOkYR+A
         rJ4PCNYQAoNZ+/pN4TAWgEbagXXo4mM8MoDfpTPTAJ8kQB1tYwH4yuEpZ3cIGz7C83
         /c1JRgGoLMofJYBzE4yQyhiuyyQ0WBJ3uXbpZ18GkvGqx9hR/boyK6qYaAzWNsR23d
         QFR9prDak13eQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        will@kernel.org
Subject: [PATCH AUTOSEL 5.4 11/74] locking/lockdep: Avoid RCU-induced noinstr fail
Date:   Mon,  8 Nov 2021 12:48:38 -0500
Message-Id: <20211108174942.1189927-11-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174942.1189927-1-sashal@kernel.org>
References: <20211108174942.1189927-1-sashal@kernel.org>
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

