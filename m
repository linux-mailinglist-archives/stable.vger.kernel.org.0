Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 158C428BA1D
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 16:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391080AbgJLOGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 10:06:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:36796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730709AbgJLNeo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:34:44 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4036215A4;
        Mon, 12 Oct 2020 13:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509684;
        bh=8eEq4KYRpIi3cl/1hrvJIiVsf5tQ2gQ54ewuc+GUgO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KLm82e86TI5Hk1ciDigXJT6GkTC9JB1BEIrDcRrAMQ+OXTNfTOPjsfpd6g+ozZegi
         o/K5whPdjaPeSfAgYzvrCXO9RxlbPSfyBg0GVFy2TMzhlU7nyh+yLuyZ4PRYpoA6Hk
         FiMBKkSwRdNgrwVk7yzQA82J/7X+9LY9faBnWaBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Dumitru Ceara <dceara@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.9 40/54] openvswitch: handle DNAT tuple collision
Date:   Mon, 12 Oct 2020 15:27:02 +0200
Message-Id: <20201012132631.436683076@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132629.585664421@linuxfoundation.org>
References: <20201012132629.585664421@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dumitru Ceara <dceara@redhat.com>

commit 8aa7b526dc0b5dbf40c1b834d76a667ad672a410 upstream.

With multiple DNAT rules it's possible that after destination
translation the resulting tuples collide.

For example, two openvswitch flows:
nw_dst=10.0.0.10,tp_dst=10, actions=ct(commit,table=2,nat(dst=20.0.0.1:20))
nw_dst=10.0.0.20,tp_dst=10, actions=ct(commit,table=2,nat(dst=20.0.0.1:20))

Assuming two TCP clients initiating the following connections:
10.0.0.10:5000->10.0.0.10:10
10.0.0.10:5000->10.0.0.20:10

Both tuples would translate to 10.0.0.10:5000->20.0.0.1:20 causing
nf_conntrack_confirm() to fail because of tuple collision.

Netfilter handles this case by allocating a null binding for SNAT at
egress by default.  Perform the same operation in openvswitch for DNAT
if no explicit SNAT is requested by the user and allocate a null binding
for SNAT for packets in the "original" direction.

Reported-at: https://bugzilla.redhat.com/1877128
Suggested-by: Florian Westphal <fw@strlen.de>
Fixes: 05752523e565 ("openvswitch: Interface with NAT.")
Signed-off-by: Dumitru Ceara <dceara@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/openvswitch/conntrack.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -709,15 +709,19 @@ static int ovs_ct_nat(struct net *net, s
 	}
 	err = ovs_ct_nat_execute(skb, ct, ctinfo, &info->range, maniptype);
 
-	if (err == NF_ACCEPT &&
-	    ct->status & IPS_SRC_NAT && ct->status & IPS_DST_NAT) {
-		if (maniptype == NF_NAT_MANIP_SRC)
-			maniptype = NF_NAT_MANIP_DST;
-		else
-			maniptype = NF_NAT_MANIP_SRC;
+	if (err == NF_ACCEPT && ct->status & IPS_DST_NAT) {
+		if (ct->status & IPS_SRC_NAT) {
+			if (maniptype == NF_NAT_MANIP_SRC)
+				maniptype = NF_NAT_MANIP_DST;
+			else
+				maniptype = NF_NAT_MANIP_SRC;
 
-		err = ovs_ct_nat_execute(skb, ct, ctinfo, &info->range,
-					 maniptype);
+			err = ovs_ct_nat_execute(skb, ct, ctinfo, &info->range,
+						 maniptype);
+		} else if (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL) {
+			err = ovs_ct_nat_execute(skb, ct, ctinfo, NULL,
+						 NF_NAT_MANIP_SRC);
+		}
 	}
 
 	/* Mark NAT done if successful and update the flow key. */


