Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F786353F9E
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239478AbhDEJNW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:13:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:60310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239346AbhDEJNC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:13:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 130A461394;
        Mon,  5 Apr 2021 09:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613973;
        bh=jJEBhcO/vA4oZutc7Isaeq+TqEhLLnKnc+/Jmo7DM34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dhER7hNzKVSDSS8hHD9/lq77rcMG3dA5F9MFaAZIhwzLvqGdffFC/RvEpdn3O4/c8
         IYzygXKSYwHGO+fJ5FfE5m1ClcXx9prik6RjWuiRA7bJlC9QAU95vwDIunuHqk0yvq
         g+bk/JUeN5iXfJymeFvI6QTqjDz/w3ItdiSH86Uc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Sumit Garg <sumit.garg@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 037/152] static_call: Align static_call_is_init() patching condition
Date:   Mon,  5 Apr 2021 10:53:06 +0200
Message-Id: <20210405085035.476176403@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 698bacefe993ad2922c9d3b1380591ad489355e9 ]

The intent is to avoid writing init code after init (because the text
might have been freed). The code is needlessly different between
jump_label and static_call and not obviously correct.

The existing code relies on the fact that the module loader clears the
init layout, such that within_module_init() always fails, while
jump_label relies on the module state which is more obvious and
matches the kernel logic.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
Tested-by: Sumit Garg <sumit.garg@linaro.org>
Link: https://lkml.kernel.org/r/20210318113610.636651340@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/static_call.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/kernel/static_call.c b/kernel/static_call.c
index 49efbdc5b480..f59089a12231 100644
--- a/kernel/static_call.c
+++ b/kernel/static_call.c
@@ -149,6 +149,7 @@ void __static_call_update(struct static_call_key *key, void *tramp, void *func)
 	};
 
 	for (site_mod = &first; site_mod; site_mod = site_mod->next) {
+		bool init = system_state < SYSTEM_RUNNING;
 		struct module *mod = site_mod->mod;
 
 		if (!site_mod->sites) {
@@ -168,6 +169,7 @@ void __static_call_update(struct static_call_key *key, void *tramp, void *func)
 		if (mod) {
 			stop = mod->static_call_sites +
 			       mod->num_static_call_sites;
+			init = mod->state == MODULE_STATE_COMING;
 		}
 #endif
 
@@ -175,16 +177,8 @@ void __static_call_update(struct static_call_key *key, void *tramp, void *func)
 		     site < stop && static_call_key(site) == key; site++) {
 			void *site_addr = static_call_addr(site);
 
-			if (static_call_is_init(site)) {
-				/*
-				 * Don't write to call sites which were in
-				 * initmem and have since been freed.
-				 */
-				if (!mod && system_state >= SYSTEM_RUNNING)
-					continue;
-				if (mod && !within_module_init((unsigned long)site_addr, mod))
-					continue;
-			}
+			if (!init && static_call_is_init(site))
+				continue;
 
 			if (!kernel_text_address((unsigned long)site_addr)) {
 				/*
-- 
2.30.1



