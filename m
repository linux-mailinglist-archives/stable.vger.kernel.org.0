Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEE934F3B2F
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243799AbiDELvb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356467AbiDEKXz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:23:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1FE2BC87C;
        Tue,  5 Apr 2022 03:08:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 400726167E;
        Tue,  5 Apr 2022 10:08:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50916C385A1;
        Tue,  5 Apr 2022 10:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153301;
        bh=xLZ0g/VqrKpcqSVcW8pSHG+RRfkKMtUdbYig9w7nVn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EX7tuzCINvLe9TaTKfksA28nv11farQwWnVYCXCyEhrDbz5OW4qrKDzcEWFtw9jik
         yn/TleKcKpPJs3uWQi4756+HRu0j4U19AgYGPWMN9UMobBVAYd/d3M6CJKNJYK10dk
         mwDC8H7SPGgqjBDxC9wwuPxWn75wr5yrRAA331UI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 175/599] rseq: Optimise rseq_get_rseq_cs() and clear_rseq_cs()
Date:   Tue,  5 Apr 2022 09:27:49 +0200
Message-Id: <20220405070304.050051081@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 5e0ccd4a3b01c5a71732a13186ca110a138516ea ]

Commit ec9c82e03a74 ("rseq: uapi: Declare rseq_cs field as union,
update includes") added regressions for our servers.

Using copy_from_user() and clear_user() for 64bit values
is suboptimal.

We can use faster put_user() and get_user() on 64bit arches.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://lkml.kernel.org/r/20210413203352.71350-4-eric.dumazet@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rseq.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/rseq.c b/kernel/rseq.c
index 0077713bf240..1b4547e0d841 100644
--- a/kernel/rseq.c
+++ b/kernel/rseq.c
@@ -120,8 +120,13 @@ static int rseq_get_rseq_cs(struct task_struct *t, struct rseq_cs *rseq_cs)
 	u32 sig;
 	int ret;
 
+#ifdef CONFIG_64BIT
+	if (get_user(ptr, &t->rseq->rseq_cs.ptr64))
+		return -EFAULT;
+#else
 	if (copy_from_user(&ptr, &t->rseq->rseq_cs.ptr64, sizeof(ptr)))
 		return -EFAULT;
+#endif
 	if (!ptr) {
 		memset(rseq_cs, 0, sizeof(*rseq_cs));
 		return 0;
@@ -204,9 +209,13 @@ static int clear_rseq_cs(struct task_struct *t)
 	 *
 	 * Set rseq_cs to NULL.
 	 */
+#ifdef CONFIG_64BIT
+	return put_user(0UL, &t->rseq->rseq_cs.ptr64);
+#else
 	if (clear_user(&t->rseq->rseq_cs.ptr64, sizeof(t->rseq->rseq_cs.ptr64)))
 		return -EFAULT;
 	return 0;
+#endif
 }
 
 /*
-- 
2.34.1



