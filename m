Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0DDC20C57
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbfEPP6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 11:58:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42416 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726645AbfEPP6l (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:41 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImD-0006z3-HA; Thu, 16 May 2019 16:58:37 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImD-0001Nw-0m; Thu, 16 May 2019 16:58:37 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Tejun Heo" <tj@kernel.org>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.853826899@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 20/86] jump_label: make static_key_enabled() work on
 static_key_true/false types too
In-Reply-To: <lsq.1558022132.52852998@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.68-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit fa128fd735bd236b6b04d3fedfed7a784137c185 upstream.

static_key_enabled() can be used on struct static_key but not on its
wrapper types static_key_true and static_key_false.  The function is
useful for debugging and management of static keys.  Update it so that
it can be used for the wrapper types too.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/jump_label.h | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -214,11 +214,6 @@ static inline int jump_label_apply_nops(
 #define STATIC_KEY_INIT STATIC_KEY_INIT_FALSE
 #define jump_label_enabled static_key_enabled
 
-static inline bool static_key_enabled(struct static_key *key)
-{
-	return static_key_count(key) > 0;
-}
-
 static inline void static_key_enable(struct static_key *key)
 {
 	int count = static_key_count(key);
@@ -265,6 +260,17 @@ struct static_key_false {
 #define DEFINE_STATIC_KEY_FALSE(name)	\
 	struct static_key_false name = STATIC_KEY_FALSE_INIT
 
+extern bool ____wrong_branch_error(void);
+
+#define static_key_enabled(x)							\
+({										\
+	if (!__builtin_types_compatible_p(typeof(*x), struct static_key) &&	\
+	    !__builtin_types_compatible_p(typeof(*x), struct static_key_true) &&\
+	    !__builtin_types_compatible_p(typeof(*x), struct static_key_false))	\
+		____wrong_branch_error();					\
+	static_key_count((struct static_key *)x) > 0;				\
+})
+
 #ifdef HAVE_JUMP_LABEL
 
 /*
@@ -323,8 +329,6 @@ struct static_key_false {
  * See jump_label_type() / jump_label_init_type().
  */
 
-extern bool ____wrong_branch_error(void);
-
 #define static_branch_likely(x)							\
 ({										\
 	bool branch;								\

