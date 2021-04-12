Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7769735CB18
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 18:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243312AbhDLQXc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 12:23:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243317AbhDLQX0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 12:23:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D281A611AD;
        Mon, 12 Apr 2021 16:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244588;
        bh=zlUJt9l/h4JPiJ48pdCoxS4qkmyE5K2cm4gi3WXnfrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DttWufBX8ShHMtiuxvJkcGuzeSb80XodbiVdaAp5mJP+rEajFrgVf3e6PDQ0X1E+T
         hyF7HpyLJhpMMNGFl+aZBRg7fICOmke38SLUhDgv/Q0AjP/IPjcgO5tvm/fAaHzp89
         q7U3kNhgbqn+IfUZQ1dlLCRSIUz4k9xhoX26ikmn83EE7QYtWWX+G6LuoIb8VsxZ7s
         Rexf5/Z/VR55DtsWZVoxnKD6moY35hNhyXntSVOY/SMxKzeqj3Ymo4vJ97aclxKKVL
         F0ZI/CZOiEp0JdBuqmTLLxr/PvIsvQqe8FUG7HGozlhoERIAuKvVF4VErJQy6NzF+P
         Kl4CGLTx+ei+g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.11 09/51] lockdep: Add a missing initialization hint to the "INFO: Trying to register non-static key" message
Date:   Mon, 12 Apr 2021 12:22:14 -0400
Message-Id: <20210412162256.313524-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162256.313524-1-sashal@kernel.org>
References: <20210412162256.313524-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 3a85969e9d912d5dd85362ee37b5f81266e00e77 ]

Since this message is printed when dynamically allocated spinlocks (e.g.
kzalloc()) are used without initialization (e.g. spin_lock_init()),
suggest to developers to check whether initialization functions for objects
were called, before making developers wonder what annotation is missing.

[ mingo: Minor tweaks to the message. ]

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20210321064913.4619-1-penguin-kernel@I-love.SAKURA.ne.jp
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/lockdep.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 780012eb2f3f..9b30f16d8241 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -930,7 +930,8 @@ static bool assign_lock_key(struct lockdep_map *lock)
 		/* Debug-check: all keys must be persistent! */
 		debug_locks_off();
 		pr_err("INFO: trying to register non-static key.\n");
-		pr_err("the code is fine but needs lockdep annotation.\n");
+		pr_err("The code is fine but needs lockdep annotation, or maybe\n");
+		pr_err("you didn't initialize this object before use?\n");
 		pr_err("turning off the locking correctness validator.\n");
 		dump_stack();
 		return false;
-- 
2.30.2

