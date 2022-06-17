Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4C7554F856
	for <lists+stable@lfdr.de>; Fri, 17 Jun 2022 15:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234792AbiFQNd1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jun 2022 09:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381281AbiFQNdY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jun 2022 09:33:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9ACE62181E
        for <stable@vger.kernel.org>; Fri, 17 Jun 2022 06:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655472798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=WzahfMaPmnANRHPxxm6NQ/wV/0KKtFLMz1x3YRdqAFI=;
        b=OuUsOmSGMts+jicd/PXTYEWXRhWj/j5aFYRQHC/dvm9nbgEAW2h+Ok7gk6YzmJA1fy6Z7s
        dgPFm08/ghxWp0/c43OoEeFZdOQGcjXlOiWWomMhSAfg+JKaZLL6TXwgJk6ReIlE62e1EI
        q2t8BQpyyHI+QE0SA/azdLWLX7HWn/8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-138-OZRdQ-eiOLeO3235Q9-LCg-1; Fri, 17 Jun 2022 09:33:15 -0400
X-MC-Unique: OZRdQ-eiOLeO3235Q9-LCg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 291EB2A5955B;
        Fri, 17 Jun 2022 13:33:15 +0000 (UTC)
Received: from dcaratti.users.ipa.redhat.com (unknown [10.40.193.75])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 285151415106;
        Fri, 17 Jun 2022 13:33:14 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     stable@vger.kernel.org
Cc:     Greg KH <gregkh@linuxfoundation.org>, echaudro@redhat.com,
        i.maximets@ovn.org
Subject: [PATCH 5.4] net/sched: act_police: more accurate MTU policing
Date:   Fri, 17 Jun 2022 15:33:00 +0200
Message-Id: <ac9dcb41e5b94fd47e2e00dd1f0d3260dbdb597d.1655470562.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

[dcaratti: fix conflicts due to lack of the following commits:
 - commit 2ffe0395288a ("net/sched: act_police: add support for
   packet-per-second policing")
 - commit afe231d32eb5 ("selftests: forwarding: Add tc-police tests")
 - commit 53b61f29367d ("selftests: forwarding: Add tc-police tests for
   packets per second")]
Link: https://lore.kernel.org/netdev/876d597a0ff55f6ba786f73c5a9fd9eb8d597a03.1644514748.git.dcaratti@redhat.com
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/sched/act_police.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index 8fd23a8b88a5..a7660b602237 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -213,6 +213,20 @@ static int tcf_police_init(struct net *net, struct nlattr *nla,
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
@@ -235,7 +249,7 @@ static int tcf_police_act(struct sk_buff *skb, const struct tc_action *a,
 			goto inc_overlimits;
 	}
 
-	if (qdisc_pkt_len(skb) <= p->tcfp_mtu) {
+	if (tcf_police_mtu_check(skb, p->tcfp_mtu)) {
 		if (!p->rate_present) {
 			ret = p->tcfp_result;
 			goto end;
-- 
2.35.3

