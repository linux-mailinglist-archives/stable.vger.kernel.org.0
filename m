Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 486CB56FB5F
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbiGKJ3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbiGKJ2l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:28:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D15466BB5;
        Mon, 11 Jul 2022 02:16:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 693286122D;
        Mon, 11 Jul 2022 09:16:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DBCEC34115;
        Mon, 11 Jul 2022 09:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530960;
        bh=Mk2mPfafefPzBg8D/s3U0LXolpcBRBnONqnf4t85Qdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gD/Kk6tFyP63Z/I5hIMsz1vKDCD9bLbRMuhI9aDDJ5jDwaTZog8IYZrblfsAKPZcc
         J7pAclhKOQmGBgZCBy23VzQ4S672zCfNx1nWOMKxVQMrmm3VzpfSAK/KKNxKj1/TxE
         3o+IxKwk5Nof8rkP4hyNr8CCzfZhxiq0n9xp//oQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 047/112] srcu: Tighten cleanup_srcu_struct() GP checks
Date:   Mon, 11 Jul 2022 11:06:47 +0200
Message-Id: <20220711090550.908046442@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit 8ed00760203d8018bee042fbfe8e076579be2c2b ]

Currently, cleanup_srcu_struct() checks for a grace period in progress,
but it does not check for a grace period that has not yet started but
which might start at any time.  Such a situation could result in a
use-after-free bug, so this commit adds a check for a grace period that
is needed but not yet started to cleanup_srcu_struct().

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/srcutree.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/srcutree.c b/kernel/rcu/srcutree.c
index 6833d8887181..d30e4db04506 100644
--- a/kernel/rcu/srcutree.c
+++ b/kernel/rcu/srcutree.c
@@ -382,9 +382,11 @@ void cleanup_srcu_struct(struct srcu_struct *ssp)
 			return; /* Forgot srcu_barrier(), so just leak it! */
 	}
 	if (WARN_ON(rcu_seq_state(READ_ONCE(ssp->srcu_gp_seq)) != SRCU_STATE_IDLE) ||
+	    WARN_ON(rcu_seq_current(&ssp->srcu_gp_seq) != ssp->srcu_gp_seq_needed) ||
 	    WARN_ON(srcu_readers_active(ssp))) {
-		pr_info("%s: Active srcu_struct %p state: %d\n",
-			__func__, ssp, rcu_seq_state(READ_ONCE(ssp->srcu_gp_seq)));
+		pr_info("%s: Active srcu_struct %p read state: %d gp state: %lu/%lu\n",
+			__func__, ssp, rcu_seq_state(READ_ONCE(ssp->srcu_gp_seq)),
+			rcu_seq_current(&ssp->srcu_gp_seq), ssp->srcu_gp_seq_needed);
 		return; /* Caller forgot to stop doing call_srcu()? */
 	}
 	free_percpu(ssp->sda);
-- 
2.35.1



