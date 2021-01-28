Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6094307C12
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 18:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232996AbhA1RSU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 12:18:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:51670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232994AbhA1RP7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Jan 2021 12:15:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 990B164E20;
        Thu, 28 Jan 2021 17:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611853980;
        bh=BpgxukqbD9gAV3nEQ4ClabYS76IIoIJIwPF77MSmo/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rk6/4TKti39SPq3prNw23YFWb7Sf6G3DloZNav6CptkXRsfbPmOxbZ4+dFdKQ0Oea
         0ky573BkYTDkwXO8VrEbNZW+XbOoTQmRTv7p/ei38uloCdN7J3LWyIVmW2M/Evjs59
         fNaCGk8MR5Rf3Ew5GlVQFcVz7XaRI/GLgZ/oAq+RYEwg19DKge0ENt9WsISlUyDodK
         rYUtO/icaXk5rvUIImd5v3GDoI8T+YRew4U+/o3QIzVeTIyqe99lIRvW0Dy9i9ee3T
         0L6jVGD3bppnuVvQeho26Y58HwJoAqLjaxsFADFXoJSXZqKkfgdi8DzfqqczajY2y+
         STXZvUMZ5tLmQ==
From:   Frederic Weisbecker <frederic@kernel.org>
To:     "Paul E . McKenney" <paulmck@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Stable <stable@vger.kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: [PATCH 13/16] rcu/nocb: Delete bypass_timer upon nocb_gp wakeup
Date:   Thu, 28 Jan 2021 18:12:19 +0100
Message-Id: <20210128171222.131380-14-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210128171222.131380-1-frederic@kernel.org>
References: <20210128171222.131380-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A NOCB-gp wake up can safely delete the nocb_bypass_timer. nocb_gp_wait()
is going to check again the bypass state and rearm the bypass timer if
necessary.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
---
 kernel/rcu/tree_plugin.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 39fb792704ed..eb8614577a2c 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1703,6 +1703,7 @@ static bool __wake_nocb_gp(struct rcu_data *rdp_gp,
 
 	rdp_gp->nocb_defer_wakeup = RCU_NOCB_WAKE_NOT;
 	del_timer(&rdp_gp->nocb_timer);
+	del_timer(&rdp_gp->nocb_bypass_timer);
 
 	if (force || READ_ONCE(rdp_gp->nocb_gp_sleep)) {
 		WRITE_ONCE(rdp_gp->nocb_gp_sleep, false);
-- 
2.25.1

