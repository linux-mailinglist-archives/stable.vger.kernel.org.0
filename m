Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01757604259
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 13:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbiJSLAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 07:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234778AbiJSK6z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:58:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4D932EE8;
        Wed, 19 Oct 2022 03:28:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47D80B824A0;
        Wed, 19 Oct 2022 09:07:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7613C433D7;
        Wed, 19 Oct 2022 09:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170465;
        bh=+6glP5M4U/7tjSVd6yGESzZeKOqk1AlOfccyrLxid58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cZvymSGNM6aRXwGqQuQVZ8V1YQcUw3OgQbRHWDcmSZ4vhQ1QswrJ/d96n8rX0Cfz4
         OFmyeGOR12HoALsakWtKsGYqIsFko5PLUJcJGcOHN/F+Kd1rdjTXgeM7sLhy+I9hM4
         O/xepoN9ks2XSb4vgwZ5b60SxuaNpSCcVkSZVhBc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 665/862] rcu-tasks: Ensure RCU Tasks Trace loops have quiescent states
Date:   Wed, 19 Oct 2022 10:32:32 +0200
Message-Id: <20221019083319.352145512@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit d6ad60635cafe900bcd11ad588d8accb36c36b1b ]

The RCU Tasks Trace grace-period kthread loops across all CPUs, and
there can be quite a few CPUs, with some commercially available systems
sporting well over a thousand of them.  Some of these loops can feature
IPIs, which can take some time.  This commit therefore places a call to
cond_resched_tasks_rcu_qs() in each such loop.

Link: https://docs.google.com/document/d/1V0YnG1HTWMt9WHJjroiJL9lf-hMrud4v8Fn3fhyY0cI/edit?usp=sharing
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tasks.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index 469bf2a3b505..f5bf6fb430da 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -1500,6 +1500,7 @@ static void rcu_tasks_trace_pregp_step(struct list_head *hop)
 		if (rcu_tasks_trace_pertask_prep(t, true))
 			trc_add_holdout(t, hop);
 		rcu_read_unlock();
+		cond_resched_tasks_rcu_qs();
 	}
 
 	// Only after all running tasks have been accounted for is it
@@ -1520,6 +1521,7 @@ static void rcu_tasks_trace_pregp_step(struct list_head *hop)
 			raw_spin_lock_irqsave_rcu_node(rtpcp, flags);
 		}
 		raw_spin_unlock_irqrestore_rcu_node(rtpcp, flags);
+		cond_resched_tasks_rcu_qs();
 	}
 
 	// Re-enable CPU hotplug now that the holdout list is populated.
@@ -1619,6 +1621,7 @@ static void check_all_holdout_tasks_trace(struct list_head *hop,
 			trc_del_holdout(t);
 		else if (needreport)
 			show_stalled_task_trace(t, firstreport);
+		cond_resched_tasks_rcu_qs();
 	}
 
 	// Re-enable CPU hotplug now that the holdout list scan has completed.
-- 
2.35.1



