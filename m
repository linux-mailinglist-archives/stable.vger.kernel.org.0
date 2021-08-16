Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B73A93ED615
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240346AbhHPNQq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:16:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:39370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236886AbhHPNPM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:15:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB49E610E8;
        Mon, 16 Aug 2021 13:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119552;
        bh=ZQ44esQOrh47uWKSMo/KRQusiG5PKVTa9PYCN9+m8aU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jghX0yarn0oRda7cGUxhug89XpU7RaGY8MGbs3qq7vY6yR5cUTxaV5Yhn2zohdQGg
         RE8hJCZSc7ZsmKWz/1QnSPBvl/Pllb6kwxIBMNMe63m3pGmJQmqUfYKgn13MzBvJut
         /uKNvepe9Tf61ugLfZZtI9/fb5Bx/5DK6Q69nAm8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 071/151] net: sched: act_mirred: Reset ct info when mirror/redirect skb
Date:   Mon, 16 Aug 2021 15:01:41 +0200
Message-Id: <20210816125446.419659530@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit d09c548dbf3b31cb07bba562e0f452edfa01efe3 ]

When mirror/redirect a skb to a different port, the ct info should be reset
for reclassification. Or the pkts will match unexpected rules. For example,
with following topology and commands:

    -----------
              |
       veth0 -+-------
              |
       veth1 -+-------
              |
   ------------

 tc qdisc add dev veth0 clsact
 # The same with "action mirred egress mirror dev veth1" or "action mirred ingress redirect dev veth1"
 tc filter add dev veth0 egress chain 1 protocol ip flower ct_state +trk action mirred ingress mirror dev veth1
 tc filter add dev veth0 egress chain 0 protocol ip flower ct_state -inv action ct commit action goto chain 1
 tc qdisc add dev veth1 clsact
 tc filter add dev veth1 ingress chain 0 protocol ip flower ct_state +trk action drop

 ping <remove ip via veth0> &
 tc -s filter show dev veth1 ingress

With command 'tc -s filter show', we can find the pkts were dropped on
veth1.

Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_mirred.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 7153c67f641e..2ef4cd2c848b 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -273,6 +273,9 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 			goto out;
 	}
 
+	/* All mirred/redirected skbs should clear previous ct info */
+	nf_reset_ct(skb2);
+
 	want_ingress = tcf_mirred_act_wants_ingress(m_eaction);
 
 	expects_nh = want_ingress || !m_mac_header_xmit;
-- 
2.30.2



