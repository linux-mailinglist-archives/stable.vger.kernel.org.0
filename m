Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED065937E0
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239227AbiHOSrH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243886AbiHOSp7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:45:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8204E3134B;
        Mon, 15 Aug 2022 11:27:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C388AB8107E;
        Mon, 15 Aug 2022 18:27:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14AD3C43470;
        Mon, 15 Aug 2022 18:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588062;
        bh=TsSpg9xei03B3IEjwmKrEgwfTR9D4NPgnrc2GqCzx+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x+L7JPq+7teDBwzkuMYF6FP6i22KmbCaZJW0I1SrO4j0A6QFhNeeqVd/3WaXKA9H5
         bsaTlmZRvB8C4pdFaoXbUN7aF+UWvzyS0ChHk4iRqOO67Dyi8ULBBYuL08fYBB+HzM
         1vZyz3GRwvP1tFyMhOfiaqNGN+U+1YLAR9RyVrvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 283/779] rcutorture: Dont cpuhp_remove_state() if cpuhp_setup_state() failed
Date:   Mon, 15 Aug 2022 19:58:47 +0200
Message-Id: <20220815180349.403405923@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit fd13fe16db0d82612b260640f4e26f6d9d1e11fd ]

Currently, in CONFIG_RCU_BOOST kernels, if the rcu_torture_init()
function's call to cpuhp_setup_state() fails, rcu_torture_cleanup()
gamely passes nonsense to cpuhp_remove_state().  This results in
strange and misleading splats.  This commit therefore ensures that if
the rcu_torture_init() function's call to cpuhp_setup_state() fails,
rcu_torture_cleanup() avoids invoking cpuhp_remove_state().

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/rcutorture.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index c1b36c52e896..3262330d1679 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -2848,7 +2848,7 @@ rcu_torture_cleanup(void)
 		 rcutorture_seq_diff(gp_seq, start_gp_seq));
 	torture_stop_kthread(rcu_torture_stats, stats_task);
 	torture_stop_kthread(rcu_torture_fqs, fqs_task);
-	if (rcu_torture_can_boost())
+	if (rcu_torture_can_boost() && rcutor_hp >= 0)
 		cpuhp_remove_state(rcutor_hp);
 
 	/*
@@ -3161,9 +3161,9 @@ rcu_torture_init(void)
 		firsterr = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "RCU_TORTURE",
 					     rcutorture_booster_init,
 					     rcutorture_booster_cleanup);
+		rcutor_hp = firsterr;
 		if (torture_init_error(firsterr))
 			goto unwind;
-		rcutor_hp = firsterr;
 
 		// Testing RCU priority boosting requires rcutorture do
 		// some serious abuse.  Counter this by running ksoftirqd
-- 
2.35.1



