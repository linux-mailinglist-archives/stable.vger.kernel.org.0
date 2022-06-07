Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D82C154116B
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353693AbiFGThK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355923AbiFGTe0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:34:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D2A41AA17E;
        Tue,  7 Jun 2022 11:13:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06CF060B3B;
        Tue,  7 Jun 2022 18:13:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF5FC385A2;
        Tue,  7 Jun 2022 18:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625585;
        bh=j8edraf78Gz65VYZ9nUIUzDh7hJEDVGQ5Xh3R5WcUCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GOeJwOT1WeEJ1syymSdTgEVvRZdkYhDYQiMiYB8b8b/QwoXF9Px3VnT6ZWEDKYYR8
         bu7KIlABArThNrz5dCQfa9S2Iv0SehQ1rWfej9gNLDR2zixcNzGK99RJAqp+pp5P+H
         Rk94vwo5HspzqJ8yiGtLFNaqjg7OAhIE4Gk/knTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 070/772] rcu-tasks: Handle sparse cpu_possible_mask in rcu_tasks_invoke_cbs()
Date:   Tue,  7 Jun 2022 18:54:22 +0200
Message-Id: <20220607164951.103939864@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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
index 30c42797f53b..1664e472524b 100644
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



