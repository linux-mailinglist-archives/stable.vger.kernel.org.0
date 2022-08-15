Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07BF8593DF8
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345546AbiHOUdi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347148AbiHOUbC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:31:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF985A4B08;
        Mon, 15 Aug 2022 12:04:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4B8DB8110B;
        Mon, 15 Aug 2022 19:04:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 162A8C43143;
        Mon, 15 Aug 2022 19:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590265;
        bh=rx8tBdlS4PuAi21PIO2gDMc5pLYpRji2eOvSJm4wlIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z/m7xuqwdVqt/GuWUUdrckuIKkmB+39e+szujyx1l/o5mZQVZrYvIn+Ov6kLjOMhT
         Ed3VetFhJMeGmno86DzdCpqsG5rKHLTGRtCVJgVFmpeZSp8povM586lEzl+oo7vIMF
         IhJ/jZRmqidqHACHBWsTmer7cIw2NytPqXZsYwGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0206/1095] locking/lockdep: Fix lockdep_init_map_*() confusion
Date:   Mon, 15 Aug 2022 19:53:25 +0200
Message-Id: <20220815180438.193194149@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit eae6d58d67d9739be5f7ae2dbead1d0ef6528243 ]

Commit dfd5e3f5fe27 ("locking/lockdep: Mark local_lock_t") added yet
another lockdep_init_map_*() variant, but forgot to update all the
existing users of the most complicated version.

This could lead to a loss of lock_type and hence an incorrect report.
Given the relative rarity of both local_lock and these annotations,
this is unlikely to happen in practise, still, best fix things.

Fixes: dfd5e3f5fe27 ("locking/lockdep: Mark local_lock_t")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/YqyEDtoan20K0CVD@worktop.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/lockdep.h  | 30 +++++++++++++++++-------------
 kernel/locking/lockdep.c |  7 ++++---
 2 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 467b94257105..0a9afe84ea44 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -192,7 +192,7 @@ static inline void
 lockdep_init_map_waits(struct lockdep_map *lock, const char *name,
 		       struct lock_class_key *key, int subclass, u8 inner, u8 outer)
 {
-	lockdep_init_map_type(lock, name, key, subclass, inner, LD_WAIT_INV, LD_LOCK_NORMAL);
+	lockdep_init_map_type(lock, name, key, subclass, inner, outer, LD_LOCK_NORMAL);
 }
 
 static inline void
@@ -215,24 +215,28 @@ static inline void lockdep_init_map(struct lockdep_map *lock, const char *name,
  * or they are too narrow (they suffer from a false class-split):
  */
 #define lockdep_set_class(lock, key)				\
-	lockdep_init_map_waits(&(lock)->dep_map, #key, key, 0,	\
-			       (lock)->dep_map.wait_type_inner,	\
-			       (lock)->dep_map.wait_type_outer)
+	lockdep_init_map_type(&(lock)->dep_map, #key, key, 0,	\
+			      (lock)->dep_map.wait_type_inner,	\
+			      (lock)->dep_map.wait_type_outer,	\
+			      (lock)->dep_map.lock_type)
 
 #define lockdep_set_class_and_name(lock, key, name)		\
-	lockdep_init_map_waits(&(lock)->dep_map, name, key, 0,	\
-			       (lock)->dep_map.wait_type_inner,	\
-			       (lock)->dep_map.wait_type_outer)
+	lockdep_init_map_type(&(lock)->dep_map, name, key, 0,	\
+			      (lock)->dep_map.wait_type_inner,	\
+			      (lock)->dep_map.wait_type_outer,	\
+			      (lock)->dep_map.lock_type)
 
 #define lockdep_set_class_and_subclass(lock, key, sub)		\
-	lockdep_init_map_waits(&(lock)->dep_map, #key, key, sub,\
-			       (lock)->dep_map.wait_type_inner,	\
-			       (lock)->dep_map.wait_type_outer)
+	lockdep_init_map_type(&(lock)->dep_map, #key, key, sub,	\
+			      (lock)->dep_map.wait_type_inner,	\
+			      (lock)->dep_map.wait_type_outer,	\
+			      (lock)->dep_map.lock_type)
 
 #define lockdep_set_subclass(lock, sub)					\
-	lockdep_init_map_waits(&(lock)->dep_map, #lock, (lock)->dep_map.key, sub,\
-			       (lock)->dep_map.wait_type_inner,		\
-			       (lock)->dep_map.wait_type_outer)
+	lockdep_init_map_type(&(lock)->dep_map, #lock, (lock)->dep_map.key, sub,\
+			      (lock)->dep_map.wait_type_inner,		\
+			      (lock)->dep_map.wait_type_outer,		\
+			      (lock)->dep_map.lock_type)
 
 #define lockdep_set_novalidate_class(lock) \
 	lockdep_set_class_and_name(lock, &__lockdep_no_validate__, #lock)
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index c06cab6546ed..e45ec82b42e6 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -5214,9 +5214,10 @@ __lock_set_class(struct lockdep_map *lock, const char *name,
 		return 0;
 	}
 
-	lockdep_init_map_waits(lock, name, key, 0,
-			       lock->wait_type_inner,
-			       lock->wait_type_outer);
+	lockdep_init_map_type(lock, name, key, 0,
+			      lock->wait_type_inner,
+			      lock->wait_type_outer,
+			      lock->lock_type);
 	class = register_lock_class(lock, subclass, 0);
 	hlock->class_idx = class - lock_classes;
 
-- 
2.35.1



