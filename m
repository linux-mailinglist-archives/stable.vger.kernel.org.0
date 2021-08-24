Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFA353F642A
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234334AbhHXRBb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:01:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:38844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239155AbhHXQ75 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:59:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A938861526;
        Tue, 24 Aug 2021 16:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824259;
        bh=t9PR/H7wvG4e7/Fr0tXfCJv5YNn3aDJuvhOk40BNd9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kM7xaFPGES+3jKcgXntOtcvfjLP2tMtjTDWV/Px2ptCZvM5Zwit2WodRYx6s8wgww
         Tm7uBAIiwaMmXLN1iiPdy07SDmURQ+5GvuNlRcrsMQiDkXyT0FaDu6To2lDaZqJ5HL
         tDfY7e6I7T2ZW6vSjh0SZyk/2K0llBoIAOzef+W9HAf/HUSGAdWMgwRMMZa3jr5G5W
         Bfc0AILdNegVXdwG/oSAglJfXXuZWDwI7o6Pn/VAC2Q4cGm590cdnuT3R8zPTFsrIz
         WWemfpK00YHe9RQUP+qHcONMU9+yXQ4LBywQ2okPdnk22Rn9tOb1x0fd1A7OfsLr5j
         vXVc7A5vOJ5tg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Elliot Berman <quic_eberman@quicinc.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 092/127] cfi: Use rcu_read_{un}lock_sched_notrace
Date:   Tue, 24 Aug 2021 12:55:32 -0400
Message-Id: <20210824165607.709387-93-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Elliot Berman <quic_eberman@quicinc.com>

[ Upstream commit 14c4c8e41511aa8fba7fb239b20b6539b5bce201 ]

If rcu_read_lock_sched tracing is enabled, the tracing subsystem can
perform a jump which needs to be checked by CFI. For example, stm_ftrace
source is enabled as a module and hooks into enabled ftrace events. This
can cause an recursive loop where find_shadow_check_fn ->
rcu_read_lock_sched -> (call to stm_ftrace generates cfi slowpath) ->
find_shadow_check_fn -> rcu_read_lock_sched -> ...

To avoid the recursion, either the ftrace codes needs to be marked with
__no_cfi or CFI should not trace. Use the "_notrace" in CFI to avoid
tracing so that CFI can guard ftrace.

Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Cc: stable@vger.kernel.org
Fixes: cf68fffb66d6 ("add support for Clang CFI")
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20210811155914.19550-1-quic_eberman@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cfi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/cfi.c b/kernel/cfi.c
index e17a56639766..9594cfd1cf2c 100644
--- a/kernel/cfi.c
+++ b/kernel/cfi.c
@@ -248,9 +248,9 @@ static inline cfi_check_fn find_shadow_check_fn(unsigned long ptr)
 {
 	cfi_check_fn fn;
 
-	rcu_read_lock_sched();
+	rcu_read_lock_sched_notrace();
 	fn = ptr_to_check_fn(rcu_dereference_sched(cfi_shadow), ptr);
-	rcu_read_unlock_sched();
+	rcu_read_unlock_sched_notrace();
 
 	return fn;
 }
@@ -269,11 +269,11 @@ static inline cfi_check_fn find_module_check_fn(unsigned long ptr)
 	cfi_check_fn fn = NULL;
 	struct module *mod;
 
-	rcu_read_lock_sched();
+	rcu_read_lock_sched_notrace();
 	mod = __module_address(ptr);
 	if (mod)
 		fn = mod->cfi_check;
-	rcu_read_unlock_sched();
+	rcu_read_unlock_sched_notrace();
 
 	return fn;
 }
-- 
2.30.2

