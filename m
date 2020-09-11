Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 564BB26670D
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 19:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbgIKRg5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 13:36:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:48392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726031AbgIKMxc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 08:53:32 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 160DC22204;
        Fri, 11 Sep 2020 12:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599828798;
        bh=kiSrsTIrdXRGEnNSgk/vKpZvsLrP0+0TT4GLeyXZybI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m+y6z/N6hPCw1wft2z0IlWAMXPoOQVPlcWIbY9phU62EtffSqyQ9gv6B41LjPxtsW
         v9FQ5mRvVC6jiGhI8rj/50+S26rMCee4WyAps+nrgsCC02grQMXuTmaQDSOdwuLO8C
         1dpCPiTz13j7UeloOyy2Pv/AokJt3O+I+K8ZfpNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jussi Kivilinna <jussi.kivilinna@haltian.com>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 11/62] batman-adv: bla: use netif_rx_ni when not in interrupt context
Date:   Fri, 11 Sep 2020 14:45:54 +0200
Message-Id: <20200911122502.956523709@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122502.395450276@linuxfoundation.org>
References: <20200911122502.395450276@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jussi Kivilinna <jussi.kivilinna@haltian.com>

[ Upstream commit 279e89b2281af3b1a9f04906e157992c19c9f163 ]

batadv_bla_send_claim() gets called from worker thread context through
batadv_bla_periodic_work(), thus netif_rx_ni needs to be used in that
case. This fixes "NOHZ: local_softirq_pending 08" log messages seen
when batman-adv is enabled.

Fixes: 23721387c409 ("batman-adv: add basic bridge loop avoidance code")
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@haltian.com>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/bridge_loop_avoidance.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/batman-adv/bridge_loop_avoidance.c b/net/batman-adv/bridge_loop_avoidance.c
index cea7fdeac5aa2..9aa5daa551273 100644
--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -380,7 +380,10 @@ static void batadv_bla_send_claim(struct batadv_priv *bat_priv, u8 *mac,
 			   skb->len + ETH_HLEN);
 	soft_iface->last_rx = jiffies;
 
-	netif_rx(skb);
+	if (in_interrupt())
+		netif_rx(skb);
+	else
+		netif_rx_ni(skb);
 out:
 	if (primary_if)
 		batadv_hardif_free_ref(primary_if);
-- 
2.25.1



