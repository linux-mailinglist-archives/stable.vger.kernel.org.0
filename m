Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3ED5417D5
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358022AbiFGVGm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378993AbiFGVEe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:04:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 800C0703D1;
        Tue,  7 Jun 2022 11:49:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63E9A612F2;
        Tue,  7 Jun 2022 18:49:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 697D5C385A2;
        Tue,  7 Jun 2022 18:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627743;
        bh=8n4OgktZlvppTMNUSoL4V5FRUeTebTWR5ynJTOiyTVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Aa1vBW9hbSbaoU3mCjIITOledednbXshrn8pH85VolWwWoq3tBM51PE2XZZ6JL8bL
         S5MV9yMVHbqXKX0PljFBL/8IY9dmW4UZvMSnBhc6DdA8GlvsUx8AtBrIvhAloU7FOs
         YEVH1TTcK0IniqgNcY/JEl8aRgjIuWha9dSduIW4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 078/879] rcu-tasks: Handle sparse cpu_possible_mask in rcu_tasks_invoke_cbs()
Date:   Tue,  7 Jun 2022 18:53:16 +0200
Message-Id: <20220607165004.954494734@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit ab2756ea6b74987849b44ad0e33c3cfec159033b ]

If the cpu_possible_mask is sparse (for example, if bits are set only for
CPUs 0, 4, 8, ...), then rcu_tasks_invoke_cbs() will access per-CPU data
for a CPU not in cpu_possible_mask.  It makes these accesses while doing
a workqueue-based binary search for non-empty callback lists.  Although
this search must pass through CPUs not represented in cpu_possible_mask,
it has no need to check the callback list for such CPUs.

This commit therefore changes the rcu_tasks_invoke_cbs() function's
binary search so as to only check callback lists for CPUs present in
cpu_possible_mask.

Reported-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tasks.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index b43320b149d2..00ff0896fb00 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -460,7 +460,7 @@ static void rcu_tasks_invoke_cbs(struct rcu_tasks *rtp, struct rcu_tasks_percpu
 		}
 	}
 
-	if (rcu_segcblist_empty(&rtpcp->cblist))
+	if (rcu_segcblist_empty(&rtpcp->cblist) || !cpu_possible(cpu))
 		return;
 	raw_spin_lock_irqsave_rcu_node(rtpcp, flags);
 	rcu_segcblist_advance(&rtpcp->cblist, rcu_seq_current(&rtp->tasks_gp_seq));
-- 
2.35.1



