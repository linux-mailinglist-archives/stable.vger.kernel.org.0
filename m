Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36FB62E41B4
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441036AbgL1PLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:11:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:41682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391671AbgL1OHV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:07:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF6C0205CB;
        Mon, 28 Dec 2020 14:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164401;
        bh=5A1YHev4yUttaWboyuOAyuUP3ydJqYVIcaxoTAd7aqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jwfa7M23S/zz913j599p6f7gwmY4qR5cvqGfkEssABiclYYmlt9x+u8UC8+8J/blS
         PRgMlJ6+hYbHuKzzNPThoikLeS5I+MbdYdSXoOmxf+bTjyJfe7GDrYXN1SxefSTCjw
         1dfJd1NPztc4CkqA1X4vm2xONkefg2ZTP8YoUM7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eupm90@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 167/717] rcu: Allow rcu_irq_enter_check_tick() from NMI
Date:   Mon, 28 Dec 2020 13:42:45 +0100
Message-Id: <20201228125028.958686596@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 6dbce04d8417ae706596366e16841d77c454ba52 ]

Eugenio managed to tickle #PF from NMI context which resulted in
hitting a WARN in RCU through irqentry_enter() ->
__rcu_irq_enter_check_tick().

However, this situation is perfectly sane and does not warrant an
WARN. The #PF will (necessarily) be atomic and not require messing
with the tick state, so early return is correct.  This commit
therefore removes the WARN.

Fixes: aaf2bc50df1f ("rcu: Abstract out rcu_irq_enter_check_tick() from rcu_nmi_enter()")
Reported-by: "Eugenio Pérez" <eupm90@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index bd04b09b84b32..655ade095e043 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -928,8 +928,8 @@ void __rcu_irq_enter_check_tick(void)
 {
 	struct rcu_data *rdp = this_cpu_ptr(&rcu_data);
 
-	 // Enabling the tick is unsafe in NMI handlers.
-	if (WARN_ON_ONCE(in_nmi()))
+	// If we're here from NMI there's nothing to do.
+	if (in_nmi())
 		return;
 
 	RCU_LOCKDEP_WARN(rcu_dynticks_curr_cpu_in_eqs(),
-- 
2.27.0



