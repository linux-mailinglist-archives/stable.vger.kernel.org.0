Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8744E940B
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 13:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233742AbiC1L0K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 07:26:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241708AbiC1LYI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 07:24:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F9055BFB;
        Mon, 28 Mar 2022 04:21:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54458611B5;
        Mon, 28 Mar 2022 11:21:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C3F6C34112;
        Mon, 28 Mar 2022 11:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648466503;
        bh=Ho2phXuAtWLZ+sQ5jklOkkrTmMsQa1r7GS6WxYIvvEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LyCjFEmoinZSvBOYO+TvDVI3W4CCg33cxO590W2Nd/3UekArBaPaecJloTkDQnAl+
         70TZmlJTUzKarDEA8HwCjl0utBKBF9JkmK3w2SdtL++c6nbUpo+Xkk/3zK/eucsfU6
         Ou1N9uJY4QHrAkw8br1Yfx3aboHZ+grlMmKmuYfCFslOA+dccxSxDYlYRYgQ0g7bnv
         UOcDoERdijrioO9tRhd01iAvNe0yJ8xcqVnY4NcKiPPgi3iaqEqsI3JNaeqERcqKBz
         Ys0ntH6+QOiQwlzDndPqoE+mxUsZz42z/RFIjaEL5HCJBQejcWtkkpOtZNqUcPOzys
         7zkMvl/zPxEag==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Zhouyi Zhou <zhouzhouyi@gmail.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Sasha Levin <sashal@kernel.org>, quic_neeraju@quicinc.com,
        josh@joshtriplett.org, rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 06/29] rcu: Mark writes to the rcu_segcblist structure's ->flags field
Date:   Mon, 28 Mar 2022 07:21:08 -0400
Message-Id: <20220328112132.1555683-6-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328112132.1555683-1-sashal@kernel.org>
References: <20220328112132.1555683-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: "Paul E. McKenney" <paulmck@kernel.org>

[ Upstream commit c09929031018913b5783872a8b8cdddef4a543c7 ]

KCSAN reports data races between the rcu_segcblist_clear_flags() and
rcu_segcblist_set_flags() functions, though misreporting the latter
as a call to rcu_segcblist_is_enabled() from call_rcu().  This commit
converts the updates of this field to WRITE_ONCE(), relying on the
resulting unmarked reads to continue to detect buggy concurrent writes
to this field.

Reported-by: Zhouyi Zhou <zhouzhouyi@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/rcu_segcblist.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/rcu_segcblist.h b/kernel/rcu/rcu_segcblist.h
index 9a19328ff251..5d405943823e 100644
--- a/kernel/rcu/rcu_segcblist.h
+++ b/kernel/rcu/rcu_segcblist.h
@@ -56,13 +56,13 @@ static inline long rcu_segcblist_n_cbs(struct rcu_segcblist *rsclp)
 static inline void rcu_segcblist_set_flags(struct rcu_segcblist *rsclp,
 					   int flags)
 {
-	rsclp->flags |= flags;
+	WRITE_ONCE(rsclp->flags, rsclp->flags | flags);
 }
 
 static inline void rcu_segcblist_clear_flags(struct rcu_segcblist *rsclp,
 					     int flags)
 {
-	rsclp->flags &= ~flags;
+	WRITE_ONCE(rsclp->flags, rsclp->flags & ~flags);
 }
 
 static inline bool rcu_segcblist_test_flags(struct rcu_segcblist *rsclp,
-- 
2.34.1

