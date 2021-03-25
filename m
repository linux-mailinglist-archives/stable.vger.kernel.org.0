Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6CF5348F8F
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbhCYL2D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:28:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:36054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231249AbhCYL0p (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:26:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F27C61A51;
        Thu, 25 Mar 2021 11:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671605;
        bh=hr/+gkGBj/uQZNi8ZyyGs/rsPjt2/D6F9uCb8FTE3Wg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DWogvAgJOZ747Y0RmeC1ZFMMVLiW8ZH+qqOAB9DFRwlgzkH08mhnE2RkSHVuRcPe0
         DkGvp1HqIRoxRNI5eElEBcPyYL9y8NLvewxtCeSoqmi2D9uapu6o1WXcBrdIp37LP0
         bsBJp7fX13kOdtn65hstmARE+gfLi/rWqxoXcKMSGBopL4Ce5xdYOBKYVdbmDDATWl
         eqS3s24oI50qzOft3FYlU4O54YAAvQfo2DCFhL7U1JlwOx4LzrdZjmYVwoHIU9095/
         cp7VdmtC8YTvp8LkFAE1yEia2gM0ilVG5QntqJWxtgRxfMpHl+YX8H83HIl0loqEiE
         SqaWEmf/svD8g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Sumit Garg <sumit.garg@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 35/39] static_call: Align static_call_is_init() patching condition
Date:   Thu, 25 Mar 2021 07:25:54 -0400
Message-Id: <20210325112558.1927423-35-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112558.1927423-1-sashal@kernel.org>
References: <20210325112558.1927423-1-sashal@kernel.org>
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

