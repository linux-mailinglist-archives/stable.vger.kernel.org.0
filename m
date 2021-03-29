Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D86D134C9D8
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233271AbhC2IeA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:34:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:53566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234445AbhC2IdJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:33:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CB89619A7;
        Mon, 29 Mar 2021 08:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006718;
        bh=B22kD/XnsYNocZglVpNcOJIKq0At9U2B2UD0+lqKMmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0u8ySnYR0eM4tanMK8+//cCnDHIZUctto5aMndafsqV26Qa/OBjpn/tGnz0d+YWL2
         5v07d4Q2yeRO6GVjKNAeeahiQdwGsnTW49KiRIWEWBNzdqFlvb+ptIEudOlspq2v5o
         AvPHIR9Fuywi3757QXyE1fu2qMP3esOkCR/KTRGw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sumit Garg <sumit.garg@linaro.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 065/254] static_call: Fix static_call_set_init()
Date:   Mon, 29 Mar 2021 09:56:21 +0200
Message-Id: <20210329075635.297211248@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 68b1eddd421d2b16c6655eceb48918a1e896bbbc ]

It turns out that static_call_set_init() does not preserve the other
flags; IOW. it clears TAIL if it was set.

Fixes: 9183c3f9ed710 ("static_call: Add inline static call infrastructure")
Reported-by: Sumit Garg <sumit.garg@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
Tested-by: Sumit Garg <sumit.garg@linaro.org>
Link: https://lkml.kernel.org/r/20210318113610.519406371@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/static_call.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/kernel/static_call.c b/kernel/static_call.c
index 5d53c354fbe7..49efbdc5b480 100644
--- a/kernel/static_call.c
+++ b/kernel/static_call.c
@@ -35,27 +35,30 @@ static inline void *static_call_addr(struct static_call_site *site)
 	return (void *)((long)site->addr + (long)&site->addr);
 }
 
+static inline unsigned long __static_call_key(const struct static_call_site *site)
+{
+	return (long)site->key + (long)&site->key;
+}
 
 static inline struct static_call_key *static_call_key(const struct static_call_site *site)
 {
-	return (struct static_call_key *)
-		(((long)site->key + (long)&site->key) & ~STATIC_CALL_SITE_FLAGS);
+	return (void *)(__static_call_key(site) & ~STATIC_CALL_SITE_FLAGS);
 }
 
 /* These assume the key is word-aligned. */
 static inline bool static_call_is_init(struct static_call_site *site)
 {
-	return ((long)site->key + (long)&site->key) & STATIC_CALL_SITE_INIT;
+	return __static_call_key(site) & STATIC_CALL_SITE_INIT;
 }
 
 static inline bool static_call_is_tail(struct static_call_site *site)
 {
-	return ((long)site->key + (long)&site->key) & STATIC_CALL_SITE_TAIL;
+	return __static_call_key(site) & STATIC_CALL_SITE_TAIL;
 }
 
 static inline void static_call_set_init(struct static_call_site *site)
 {
-	site->key = ((long)static_call_key(site) | STATIC_CALL_SITE_INIT) -
+	site->key = (__static_call_key(site) | STATIC_CALL_SITE_INIT) -
 		    (long)&site->key;
 }
 
@@ -199,7 +202,7 @@ void __static_call_update(struct static_call_key *key, void *tramp, void *func)
 			}
 
 			arch_static_call_transform(site_addr, NULL, func,
-				static_call_is_tail(site));
+						   static_call_is_tail(site));
 		}
 	}
 
@@ -358,7 +361,7 @@ static int static_call_add_module(struct module *mod)
 	struct static_call_site *site;
 
 	for (site = start; site != stop; site++) {
-		unsigned long s_key = (long)site->key + (long)&site->key;
+		unsigned long s_key = __static_call_key(site);
 		unsigned long addr = s_key & ~STATIC_CALL_SITE_FLAGS;
 		unsigned long key;
 
-- 
2.30.1



