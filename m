Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDE69499FDB
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1842264AbiAXXB1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:01:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1838031AbiAXWps (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:45:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02417C0550E7;
        Mon, 24 Jan 2022 13:06:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9582561320;
        Mon, 24 Jan 2022 21:06:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 717B8C340E7;
        Mon, 24 Jan 2022 21:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058377;
        bh=sN1MrGINuCa0tfGr5vuPfsGYIsd6lo6Uw1MmiQI9n8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zbLhdQmf2voHYFudctaja4CgnvAKC2uGO1x1/01ueEFpuxlbIKZFMXoByHbnp5dZL
         YXh9kA6Ui7ijtCudQNJojXo6dXv5EW2dP7qKENXx4O9Ekhfr/AcLBcZXMJEVEn7HQB
         nbl1j5yNJHGSE87cLKaOEH4+lcqo4zyAL0iYjkMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neeraj Upadhyay <quic_neeraju@quicinc.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0262/1039] rcu/exp: Mark current CPU as exp-QS in IPI loop second pass
Date:   Mon, 24 Jan 2022 19:34:11 +0100
Message-Id: <20220124184134.113150459@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frederic Weisbecker <frederic@kernel.org>

[ Upstream commit 81f6d49cce2d2fe507e3fddcc4a6db021d9c2e7b ]

Expedited RCU grace periods invoke sync_rcu_exp_select_node_cpus(), which
takes two passes over the leaf rcu_node structure's CPUs.  The first
pass gathers up the current CPU and CPUs that are in dynticks idle mode.
The workqueue will report a quiescent state on their behalf later.
The second pass sends IPIs to the rest of the CPUs, but excludes the
current CPU, incorrectly assuming it has been included in the first
pass's list of CPUs.

Unfortunately the current CPU may have changed between the first and
second pass, due to the fact that the various rcu_node structures'
->lock fields have been dropped, thus momentarily enabling preemption.
This means that if the second pass's CPU was not on the first pass's
list, it will be ignored completely.  There will be no IPI sent to
it, and there will be no reporting of quiescent states on its behalf.
Unfortunately, the expedited grace period will nevertheless be waiting
for that CPU to report a quiescent state, but with that CPU having no
reason to believe that such a report is needed.

The result will be an expedited grace period stall.

Fix this by no longer excluding the current CPU from consideration during
the second pass.

Fixes: b9ad4d6ed18e ("rcu: Avoid self-IPI in sync_rcu_exp_select_node_cpus()")
Reviewed-by: Neeraj Upadhyay <quic_neeraju@quicinc.com>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Neeraj Upadhyay <quic_neeraju@quicinc.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Joel Fernandes <joel@joelfernandes.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree_exp.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/rcu/tree_exp.h b/kernel/rcu/tree_exp.h
index f3947c49eee71..9e58e77b992ed 100644
--- a/kernel/rcu/tree_exp.h
+++ b/kernel/rcu/tree_exp.h
@@ -387,6 +387,7 @@ retry_ipi:
 			continue;
 		}
 		if (get_cpu() == cpu) {
+			mask_ofl_test |= mask;
 			put_cpu();
 			continue;
 		}
-- 
2.34.1



