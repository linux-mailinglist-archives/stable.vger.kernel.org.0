Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76DE8551E74
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 16:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350482AbiFTODR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 10:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352630AbiFTN4r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:56:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A487A36B5E;
        Mon, 20 Jun 2022 06:22:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85EAA61269;
        Mon, 20 Jun 2022 13:22:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788EEC3411B;
        Mon, 20 Jun 2022 13:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655731365;
        bh=TunpWO37x+LD44jsChogmbb+G/gizFMI8x8e4aE54WY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XM40F8pyP9ioqN5E6hh+FpCWC4cOtVokoLRMGov29/DAmY8GBmf9LKF0s6c2CPelo
         leGyUlweGvEM5UCKOqos82nrgakiOsZDNVpDjTTf9vSaSyr0PxLUo+xfQ+7oNWnzHi
         UP4hoOLYOIwzC+Z4DHF0oXAJjo7b9XZevyTqCoiE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Davide Caratti <dcaratti@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 234/240] net/sched: act_police: more accurate MTU policing
Date:   Mon, 20 Jun 2022 14:52:15 +0200
Message-Id: <20220620124745.735247247@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
References: <20220620124737.799371052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

commit 4ddc844eb81da59bfb816d8d52089aba4e59e269 upstream.

in current Linux, MTU policing does not take into account that packets at
the TC ingress have the L2 header pulled. Thus, the same TC police action
(with the same value of tcfp_mtu) behaves differently for ingress/egress.
In addition, the full GSO size is compared to tcfp_mtu: as a consequence,
the policer drops GSO packets even when individual segments have the L2 +
L3 + L4 + payload length below the configured valued of tcfp_mtu.

Improve the accuracy of MTU policing as follows:
 - account for mac_len for non-GSO packets at TC ingress.
 - compare MTU threshold with the segmented size for GSO packets.
Also, add a kselftest that verifies the correct behavior.

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[dcaratti: fix conflicts due to lack of the following commits:
 - commit 2ffe0395288a ("net/sched: act_police: add support for
   packet-per-second policing")
 - commit afe231d32eb5 ("selftests: forwarding: Add tc-police tests")
 - commit 53b61f29367d ("selftests: forwarding: Add tc-police tests for
   packets per second")]
Link: https://lore.kernel.org/netdev/876d597a0ff55f6ba786f73c5a9fd9eb8d597a03.1644514748.git.dcaratti@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_police.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -213,6 +213,20 @@ release_idr:
 	return err;
 }
 
+static bool tcf_police_mtu_check(struct sk_buff *skb, u32 limit)
+{
+	u32 len;
+
+	if (skb_is_gso(skb))
+		return skb_gso_validate_mac_len(skb, limit);
+
+	len = qdisc_pkt_len(skb);
+	if (skb_at_tc_ingress(skb))
+		len += skb->mac_len;
+
+	return len <= limit;
+}
+
 static int tcf_police_act(struct sk_buff *skb, const struct tc_action *a,
 			  struct tcf_result *res)
 {
@@ -235,7 +249,7 @@ static int tcf_police_act(struct sk_buff
 			goto inc_overlimits;
 	}
 
-	if (qdisc_pkt_len(skb) <= p->tcfp_mtu) {
+	if (tcf_police_mtu_check(skb, p->tcfp_mtu)) {
 		if (!p->rate_present) {
 			ret = p->tcfp_result;
 			goto end;


