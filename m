Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D19312F105
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbgABW53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:57:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:59114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727228AbgABWQy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:16:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35D6522314;
        Thu,  2 Jan 2020 22:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003413;
        bh=BqX7q04+FN+mZ1t824BNPAXjx17/+bgB/b3nPi663bg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YcJVoj2+7xSCN3KiBomGdMq+t9bXPsQJPRgygLSLHQeofYAdXypToMUb0gp9FB/YW
         4wFILAfLJe8/XGUfznAPMhEsqYQu758LVXPd3AE+h5b+nDcCDtLtWvNo/IKxjf1tWA
         URTaKe0AJecvNAURXFyRVDVAZLEV0YRXSQNAIEZk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shmulik Ladkani <sladkani@proofpoint.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 151/191] net/sched: act_mirred: Pull mac prior redir to non mac_header_xmit device
Date:   Thu,  2 Jan 2020 23:07:13 +0100
Message-Id: <20200102215845.650407157@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shmulik Ladkani <sladkani@proofpoint.com>

[ Upstream commit 70cf3dc7313207816255b9acb0dffb19dae78144 ]

There's no skb_pull performed when a mirred action is set at egress of a
mac device, with a target device/action that expects skb->data to point
at the network header.

As a result, either the target device is errornously given an skb with
data pointing to the mac (egress case), or the net stack receives the
skb with data pointing to the mac (ingress case).

E.g:
 # tc qdisc add dev eth9 root handle 1: prio
 # tc filter add dev eth9 parent 1: prio 9 protocol ip handle 9 basic \
   action mirred egress redirect dev tun0

 (tun0 is a tun device. result: tun0 errornously gets the eth header
  instead of the iph)

Revise the push/pull logic of tcf_mirred_act() to not rely on the
skb_at_tc_ingress() vs tcf_mirred_act_wants_ingress() comparison, as it
does not cover all "pull" cases.

Instead, calculate whether the required action on the target device
requires the data to point at the network header, and compare this to
whether skb->data points to network header - and make the push/pull
adjustments as necessary.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Shmulik Ladkani <sladkani@proofpoint.com>
Tested-by: Jamal Hadi Salim <jhs@mojatatu.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_mirred.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -219,8 +219,10 @@ static int tcf_mirred_act(struct sk_buff
 	bool use_reinsert;
 	bool want_ingress;
 	bool is_redirect;
+	bool expects_nh;
 	int m_eaction;
 	int mac_len;
+	bool at_nh;
 
 	rec_level = __this_cpu_inc_return(mirred_rec_level);
 	if (unlikely(rec_level > MIRRED_RECURSION_LIMIT)) {
@@ -261,19 +263,19 @@ static int tcf_mirred_act(struct sk_buff
 			goto out;
 	}
 
-	/* If action's target direction differs than filter's direction,
-	 * and devices expect a mac header on xmit, then mac push/pull is
-	 * needed.
-	 */
 	want_ingress = tcf_mirred_act_wants_ingress(m_eaction);
-	if (skb_at_tc_ingress(skb) != want_ingress && m_mac_header_xmit) {
-		if (!skb_at_tc_ingress(skb)) {
-			/* caught at egress, act ingress: pull mac */
-			mac_len = skb_network_header(skb) - skb_mac_header(skb);
+
+	expects_nh = want_ingress || !m_mac_header_xmit;
+	at_nh = skb->data == skb_network_header(skb);
+	if (at_nh != expects_nh) {
+		mac_len = skb_at_tc_ingress(skb) ? skb->mac_len :
+			  skb_network_header(skb) - skb_mac_header(skb);
+		if (expects_nh) {
+			/* target device/action expect data at nh */
 			skb_pull_rcsum(skb2, mac_len);
 		} else {
-			/* caught at ingress, act egress: push mac */
-			skb_push_rcsum(skb2, skb->mac_len);
+			/* target device/action expect data at mac */
+			skb_push_rcsum(skb2, mac_len);
 		}
 	}
 


