Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA7949A33C
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365087AbiAXXuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:50:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1455588AbiAXVfl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:35:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71388C05A18C;
        Mon, 24 Jan 2022 12:22:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 103D06091A;
        Mon, 24 Jan 2022 20:22:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75BDC340E5;
        Mon, 24 Jan 2022 20:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055758;
        bh=JBWxrTbYq5/vugCZArNJ5V02e0/pViZqPOffIdrvTGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hcqBJlPnnLqeUp4jLTTv3QwZ6sElrUXSETp0Jf7PN5jjSiX1BNzmruuLIkpAun764
         UjyYrRGgczgrbj0RXiaWrEdydNch1eL06Ol7ceiSqOam1reai0OEekxaADNKeYDTLz
         IWDXIH37z16FscoZXd+5DoEL8i+8cwd8Za+IPWT4=
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
Subject: [PATCH 5.15 223/846] rcu/exp: Mark current CPU as exp-QS in IPI loop second pass
Date:   Mon, 24 Jan 2022 19:35:40 +0100
Message-Id: <20220124184108.619065865@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
index 454b516ea566e..16f94118ca34b 100644
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



