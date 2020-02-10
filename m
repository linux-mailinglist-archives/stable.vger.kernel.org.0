Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 526E1157672
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728546AbgBJMwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:52:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:46368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729958AbgBJMmT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:42:19 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C48E2085B;
        Mon, 10 Feb 2020 12:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338539;
        bh=9a4kOFsJltgCdSoy24riEqC1fTZGjp5zyK8t7m2kL/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0jzdUvlzhzTE/x6gut31asc/VFyKxpuz6sppgJyeS4hkgSdfk97n9xIaulpAUdfcR
         XqXWYgRpxxLAIH2HpV9wvaqrBcSxy59BvbUUnLMxpZZzRKDgaMy/U2YKUz1sfpE7cs
         K5YkseRFN3Rm0cdx9LaLspGPoK66WDbnx0ArslUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 339/367] taprio: Fix dropping packets when using taprio + ETF offloading
Date:   Mon, 10 Feb 2020 04:34:12 -0800
Message-Id: <20200210122453.975739078@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

[ Upstream commit bfabd41da34180d05382312533a3adc2e012dee0 ]

When using taprio offloading together with ETF offloading, configured
like this, for example:

$ tc qdisc replace dev $IFACE parent root handle 100 taprio \
  	num_tc 4 \
        map 2 2 1 0 3 2 2 2 2 2 2 2 2 2 2 2 \
	queues 1@0 1@1 1@2 1@3 \
	base-time $BASE_TIME \
	sched-entry S 01 1000000 \
	sched-entry S 0e 1000000 \
	flags 0x2

$ tc qdisc replace dev $IFACE parent 100:1 etf \
     	offload delta 300000 clockid CLOCK_TAI

During enqueue, it works out that the verification added for the
"txtime" assisted mode is run when using taprio + ETF offloading, the
only thing missing is initializing the 'next_txtime' of all the cycle
entries. (if we don't set 'next_txtime' all packets from SO_TXTIME
sockets are dropped)

Fixes: 4cfd5779bd6e ("taprio: Add support for txtime-assist mode")
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_taprio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1522,9 +1522,9 @@ static int taprio_change(struct Qdisc *s
 		goto unlock;
 	}
 
-	if (TXTIME_ASSIST_IS_ENABLED(q->flags)) {
-		setup_txtime(q, new_admin, start);
+	setup_txtime(q, new_admin, start);
 
+	if (TXTIME_ASSIST_IS_ENABLED(q->flags)) {
 		if (!oper) {
 			rcu_assign_pointer(q->oper_sched, new_admin);
 			err = 0;


