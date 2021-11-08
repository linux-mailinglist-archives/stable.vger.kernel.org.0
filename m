Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A610544A172
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239667AbhKIBJr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:09:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:60366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241891AbhKIBI2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:08:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80E0461A4F;
        Tue,  9 Nov 2021 01:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419817;
        bh=zFEpjY7esjWBn4hY9dtx0BbP9Q2n7doe4eAJkl0M51o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q4f8NrkQMFXYNdkZwFtq5kGzaLQasb7zfTcQRHFv0fkZtpU1mkG7HKL0mcbnxLN4h
         b+CJBGGFqOVa7klVt/NYbJ/TP70I0+LsMXCj2AvpCMY9k0WEXaui7Vb82c02jchpnu
         D1ZS+UoyBIBdwfudpr9ctITGPgEnUKqyz310z/tjyQNZzVwg/xdRtGR5XPNh8WG5X7
         Uum6I8RHFTw+h7vTKReSQATy/KYwDOiL8y5MctE5d+W7mQh3+suu1UBG4N+zsNJf6+
         q1R2WDHstaPyVDhSFS6UHgnozTFAl4oAq3SXi8zYpP65FCFKYF3iNuQsdi4xR7k/S+
         KYc/ZC582AeMQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        will@kernel.org
Subject: [PATCH AUTOSEL 5.10 012/101] locking/lockdep: Avoid RCU-induced noinstr fail
Date:   Mon,  8 Nov 2021 12:47:02 -0500
Message-Id: <20211108174832.1189312-12-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174832.1189312-1-sashal@kernel.org>
References: <20211108174832.1189312-1-sashal@kernel.org>
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
index 5184f68968158..2823329143503 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -887,7 +887,7 @@ look_up_lock_class(const struct lockdep_map *lock, unsigned int subclass)
 	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
 		return NULL;
 
-	hlist_for_each_entry_rcu(class, hash_head, hash_entry) {
+	hlist_for_each_entry_rcu_notrace(class, hash_head, hash_entry) {
 		if (class->key == key) {
 			/*
 			 * Huh! same key, different name? Did someone trample
-- 
2.33.0

