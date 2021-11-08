Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A87E44A211
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240884AbhKIBQT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:16:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:38260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242444AbhKIBNY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:13:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5539F61AAC;
        Tue,  9 Nov 2021 01:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419927;
        bh=qiKfiHU3jLJFyBGmDprA/UxBtTZXpr7xegM0qZFqK8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CIlSIg32h56rL2tZls+VQtOIjmge8tSocEHvU53h12rIA3diBlO5pj8oIl7kq2+VZ
         L6AaZY0f4yhyeLgT59zZOKaRUunWtk8u/42Vn1bZsAh1w+Y/y8RtwNp/H839t1srjC
         ybA4RA/hEPJV4y5+cVRyTgMW7XXYE2Ps/mGb+Ka5pw8AhWoHrUuseDSDah3j2LD2Tl
         Q2HWFREt/FABYEvqaI0x/azM361Foy/BIHKVKFslADNgS+VftiuAvZ76ZUYONYLeQA
         pzjvRwBSQtd1wa2Qv7uY4fdojqxvrnO529HqLjZxQXW53vjacD+spR/e4uavntriqV
         j6cDwHvxL/2EQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        will@kernel.org
Subject: [PATCH AUTOSEL 4.19 07/47] locking/lockdep: Avoid RCU-induced noinstr fail
Date:   Mon,  8 Nov 2021 12:49:51 -0500
Message-Id: <20211108175031.1190422-7-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108175031.1190422-1-sashal@kernel.org>
References: <20211108175031.1190422-1-sashal@kernel.org>
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
index 126c6d524a0f2..4dc79f57af827 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -689,7 +689,7 @@ look_up_lock_class(const struct lockdep_map *lock, unsigned int subclass)
 	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
 		return NULL;
 
-	hlist_for_each_entry_rcu(class, hash_head, hash_entry) {
+	hlist_for_each_entry_rcu_notrace(class, hash_head, hash_entry) {
 		if (class->key == key) {
 			/*
 			 * Huh! same key, different name? Did someone trample
-- 
2.33.0

