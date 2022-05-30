Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6BEF537BBB
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 15:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236735AbiE3N1N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236710AbiE3N0L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:26:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60ED88723C;
        Mon, 30 May 2022 06:25:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 476BDB80D84;
        Mon, 30 May 2022 13:25:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2565BC3411E;
        Mon, 30 May 2022 13:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917129;
        bh=SCDCIZmqB3nm/ipXO8beYFU6tiAVwY/0EnmeQDXTIbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AaFFNOdAwxil1BT47JB4/3xHO+fSbGzXsaRLJur9grJ+NFQd50Kn1muSvt8iGyt7O
         fW+sBQEdXvIZ2A1MyJ+eXrxoc7hFGE2KppwJSL4isU9lDX13rxn0gpayAgWXSZ0axY
         Y4WgwR5kVdfuxmwzM9h5rwJq6MfibvDqGW9j7yLFvRVya4nXWCD331zPZhrgczkLDo
         g8ETxg4SnK+Ls9tNHS39BCio/avr2r7BIf1NVuutgDrFQWZAJXlyp+B70Z3s5xCprT
         bmMy3riKdCn90tGNrTnaIHp1NJmnXrAtnojJWxy/ji3uqcl986T6wPsovk6olKnGRN
         31caF2Ly0dl7A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Sasha Levin <sashal@kernel.org>, frederic@kernel.org,
        quic_neeraju@quicinc.com, josh@joshtriplett.org,
        rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 025/159] rcu-tasks: Handle sparse cpu_possible_mask in rcu_tasks_invoke_cbs()
Date:   Mon, 30 May 2022 09:22:10 -0400
Message-Id: <20220530132425.1929512-25-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Paul E. McKenney" <paulmck@kernel.org>

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

