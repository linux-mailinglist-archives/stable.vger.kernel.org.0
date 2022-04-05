Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 957BE4F3B32
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245216AbiDELvi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356500AbiDEKX5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:23:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB2DBBE18;
        Tue,  5 Apr 2022 03:08:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04DFA6167E;
        Tue,  5 Apr 2022 10:08:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 188C2C385A1;
        Tue,  5 Apr 2022 10:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153304;
        bh=ZZFJ3N/7ABkWzB2CNvgPVXmykXAcG3EzZixoiC8QAyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jnW61ahd4TDrpDf4yZsPGDyxQgnYa0j/9Rc2MlGQV96zdHWpdPL9r3Lsv0Dphwv7q
         kyebCsp2vaKpEbF1mw1atuZKl3j6BWKWn2Gf0r7EDThWRnXHW1+WO/hLoDyWxNTega
         IdnEs8p1mSl6OmWOSqf889fULU8nxJEJO61iCTq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 176/599] rseq: Remove broken uapi field layout on 32-bit little endian
Date:   Tue,  5 Apr 2022 09:27:50 +0200
Message-Id: <20220405070304.080018580@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

[ Upstream commit bfdf4e6208051ed7165b2e92035b4bf11f43eb63 ]

The rseq rseq_cs.ptr.{ptr32,padding} uapi endianness handling is
entirely wrong on 32-bit little endian: a preprocessor logic mistake
wrongly uses the big endian field layout on 32-bit little endian
architectures.

Fortunately, those ptr32 accessors were never used within the kernel,
and only meant as a convenience for user-space.

Remove those and replace the whole rseq_cs union by a __u64 type, as
this is the only thing really needed to express the ABI. Document how
32-bit architectures are meant to interact with this field.

Fixes: ec9c82e03a74 ("rseq: uapi: Declare rseq_cs field as union, update includes")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20220127152720.25898-1-mathieu.desnoyers@efficios.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/rseq.h | 20 ++++----------------
 kernel/rseq.c             |  8 ++++----
 2 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/include/uapi/linux/rseq.h b/include/uapi/linux/rseq.h
index 9a402fdb60e9..77ee207623a9 100644
--- a/include/uapi/linux/rseq.h
+++ b/include/uapi/linux/rseq.h
@@ -105,23 +105,11 @@ struct rseq {
 	 * Read and set by the kernel. Set by user-space with single-copy
 	 * atomicity semantics. This field should only be updated by the
 	 * thread which registered this data structure. Aligned on 64-bit.
+	 *
+	 * 32-bit architectures should update the low order bits of the
+	 * rseq_cs field, leaving the high order bits initialized to 0.
 	 */
-	union {
-		__u64 ptr64;
-#ifdef __LP64__
-		__u64 ptr;
-#else
-		struct {
-#if (defined(__BYTE_ORDER) && (__BYTE_ORDER == __BIG_ENDIAN)) || defined(__BIG_ENDIAN)
-			__u32 padding;		/* Initialized to zero. */
-			__u32 ptr32;
-#else /* LITTLE */
-			__u32 ptr32;
-			__u32 padding;		/* Initialized to zero. */
-#endif /* ENDIAN */
-		} ptr;
-#endif
-	} rseq_cs;
+	__u64 rseq_cs;
 
 	/*
 	 * Restartable sequences flags field.
diff --git a/kernel/rseq.c b/kernel/rseq.c
index 1b4547e0d841..6ca29dddceab 100644
--- a/kernel/rseq.c
+++ b/kernel/rseq.c
@@ -121,10 +121,10 @@ static int rseq_get_rseq_cs(struct task_struct *t, struct rseq_cs *rseq_cs)
 	int ret;
 
 #ifdef CONFIG_64BIT
-	if (get_user(ptr, &t->rseq->rseq_cs.ptr64))
+	if (get_user(ptr, &t->rseq->rseq_cs))
 		return -EFAULT;
 #else
-	if (copy_from_user(&ptr, &t->rseq->rseq_cs.ptr64, sizeof(ptr)))
+	if (copy_from_user(&ptr, &t->rseq->rseq_cs, sizeof(ptr)))
 		return -EFAULT;
 #endif
 	if (!ptr) {
@@ -210,9 +210,9 @@ static int clear_rseq_cs(struct task_struct *t)
 	 * Set rseq_cs to NULL.
 	 */
 #ifdef CONFIG_64BIT
-	return put_user(0UL, &t->rseq->rseq_cs.ptr64);
+	return put_user(0UL, &t->rseq->rseq_cs);
 #else
-	if (clear_user(&t->rseq->rseq_cs.ptr64, sizeof(t->rseq->rseq_cs.ptr64)))
+	if (clear_user(&t->rseq->rseq_cs, sizeof(t->rseq->rseq_cs)))
 		return -EFAULT;
 	return 0;
 #endif
-- 
2.34.1



