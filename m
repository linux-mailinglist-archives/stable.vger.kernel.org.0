Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34CD3348F37
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbhCYL0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:26:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:34218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230350AbhCYLZw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:25:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF00F61A2E;
        Thu, 25 Mar 2021 11:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671551;
        bh=hr/+gkGBj/uQZNi8ZyyGs/rsPjt2/D6F9uCb8FTE3Wg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ce/tEGIEv2slSbfhKbql7ea3B0tVbcV+H3rul5NiwLw4b/9ZUd2j3FGWSTiBm2Jqa
         liw6jrnZigO5QG90TpwNj2KTtzpJ9atAPMbe1jxcFpZrY6etyNVOR3zKDXo0SbZq2v
         FZxyzu5ohNRlND1GFsuGMoUirRfDADkNwjpfXG5B6MWda2RlMo0vZ1FL7zF4E10NRa
         WA86P6uFJ6gtEiLiEAJ6Eo+l8IzHblHjOMwLLybqMuUySNtY1X7r1Q5jfdq7aNK5WG
         wemvCOLyNPk+owPZSG55u9Kpt/9CLId2qwSSV3GFOJ7OcO4R2kFBbvs/j3ArE3xT6o
         3QboqGuJO4Amg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Sumit Garg <sumit.garg@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.11 40/44] static_call: Align static_call_is_init() patching condition
Date:   Thu, 25 Mar 2021 07:24:55 -0400
Message-Id: <20210325112459.1926846-40-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112459.1926846-1-sashal@kernel.org>
References: <20210325112459.1926846-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 84565c2a41b8..781ff0fd031d 100644
--- a/kernel/static_call.c
+++ b/kernel/static_call.c
@@ -144,6 +144,7 @@ void __static_call_update(struct static_call_key *key, void *tramp, void *func)
 	};
 
 	for (site_mod = &first; site_mod; site_mod = site_mod->next) {
+		bool init = system_state < SYSTEM_RUNNING;
 		struct module *mod = site_mod->mod;
 
 		if (!site_mod->sites) {
@@ -163,6 +164,7 @@ void __static_call_update(struct static_call_key *key, void *tramp, void *func)
 		if (mod) {
 			stop = mod->static_call_sites +
 			       mod->num_static_call_sites;
+			init = mod->state == MODULE_STATE_COMING;
 		}
 #endif
 
@@ -170,16 +172,8 @@ void __static_call_update(struct static_call_key *key, void *tramp, void *func)
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
 				WARN_ONCE(1, "can't patch static call site at %pS",
-- 
2.30.1

