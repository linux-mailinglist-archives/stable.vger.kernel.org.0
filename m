Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 841CC4F2D40
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354156AbiDEKMJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344351AbiDEJTe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:19:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 956AA2A1;
        Tue,  5 Apr 2022 02:07:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9466614E4;
        Tue,  5 Apr 2022 09:07:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029A9C385A1;
        Tue,  5 Apr 2022 09:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149663;
        bh=aHqT1HFZ5CvSbqfy/C/L/NOwod6STlMUwvXPGsSKQro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2gTgpYkSEGPPLWsbv8mYgCYWIKpy1on72Zaavmc9yslEegKPvzwODsO//xZQDOwyj
         T3iSPy6dfQbvpiW3esawNarHAb6iu2UzFcEknO00Ccy+mz0XiDVjLdj+AsASMdLIeA
         xJq8Z2JuRWOClJNxYZDjfeXt7tseXiJMBTW5GUc8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhouyi Zhou <zhouzhouyi@gmail.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0757/1017] rcu: Mark writes to the rcu_segcblist structures ->flags field
Date:   Tue,  5 Apr 2022 09:27:50 +0200
Message-Id: <20220405070416.729358398@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Paul E. McKenney <paulmck@kernel.org>

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



