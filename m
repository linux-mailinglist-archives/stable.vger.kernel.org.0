Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2394E774A
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:26:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376558AbiCYP1r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378017AbiCYPYs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:24:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1296CEBAF0;
        Fri, 25 Mar 2022 08:19:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B22560AD0;
        Fri, 25 Mar 2022 15:19:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D656C340E9;
        Fri, 25 Mar 2022 15:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648221575;
        bh=UPNROQtk0dXHRt+2fLHL00m2kNA2Kl3lXWE12qjfXE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y2HWJodcHeLS9kqlC87/G09cbwThcgsHV7DNobHo5ahLoGPmxIXjIS5t1DKqekmNX
         AC3QNH5tVMJWddHRXs/Q/gZKC5PT4JV3wwEqCEBq6IexVzs4ud90Zttj9t6aXJULQz
         wXkTPGfpFit1UGJUpz0yxiU8Br+FiCrqf1a+9cIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tim Murray <timmurray@google.com>,
        Joel Fernandes <joelaf@google.com>,
        Neeraj Upadhyay <quic_neeraju@quicinc.com>,
        "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
        Todd Kjos <tkjos@google.com>,
        Sandeep Patil <sspatil@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 5.17 32/39] rcu: Dont deboost before reporting expedited quiescent state
Date:   Fri, 25 Mar 2022 16:14:47 +0100
Message-Id: <20220325150421.162631784@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150420.245733653@linuxfoundation.org>
References: <20220325150420.245733653@linuxfoundation.org>
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

commit 10c535787436d62ea28156a4b91365fd89b5a432 upstream.

Currently rcu_preempt_deferred_qs_irqrestore() releases rnp->boost_mtx
before reporting the expedited quiescent state.  Under heavy real-time
load, this can result in this function being preempted before the
quiescent state is reported, which can in turn prevent the expedited grace
period from completing.  Tim Murray reports that the resulting expedited
grace periods can take hundreds of milliseconds and even more than one
second, when they should normally complete in less than a millisecond.

This was fine given that there were no particular response-time
constraints for synchronize_rcu_expedited(), as it was designed
for throughput rather than latency.  However, some users now need
sub-100-millisecond response-time constratints.

This patch therefore follows Neeraj's suggestion (seconded by Tim and
by Uladzislau Rezki) of simply reversing the two operations.

Reported-by: Tim Murray <timmurray@google.com>
Reported-by: Joel Fernandes <joelaf@google.com>
Reported-by: Neeraj Upadhyay <quic_neeraju@quicinc.com>
Reviewed-by: Neeraj Upadhyay <quic_neeraju@quicinc.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Tested-by: Tim Murray <timmurray@google.com>
Cc: Todd Kjos <tkjos@google.com>
Cc: Sandeep Patil <sspatil@google.com>
Cc: <stable@vger.kernel.org> # 5.4.x
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/rcu/tree_plugin.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -556,16 +556,16 @@ rcu_preempt_deferred_qs_irqrestore(struc
 			raw_spin_unlock_irqrestore_rcu_node(rnp, flags);
 		}
 
-		/* Unboost if we were boosted. */
-		if (IS_ENABLED(CONFIG_RCU_BOOST) && drop_boost_mutex)
-			rt_mutex_futex_unlock(&rnp->boost_mtx.rtmutex);
-
 		/*
 		 * If this was the last task on the expedited lists,
 		 * then we need to report up the rcu_node hierarchy.
 		 */
 		if (!empty_exp && empty_exp_now)
 			rcu_report_exp_rnp(rnp, true);
+
+		/* Unboost if we were boosted. */
+		if (IS_ENABLED(CONFIG_RCU_BOOST) && drop_boost_mutex)
+			rt_mutex_futex_unlock(&rnp->boost_mtx.rtmutex);
 	} else {
 		local_irq_restore(flags);
 	}


