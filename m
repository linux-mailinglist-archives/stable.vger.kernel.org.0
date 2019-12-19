Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 942FB126A94
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727725AbfLSSsw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:48:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:42096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729686AbfLSSsu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:48:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B69FC24690;
        Thu, 19 Dec 2019 18:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781330;
        bh=zSDRHGnRAzteyStvXmpIAh0EN7aT9mvH8k+qItKb0QA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AViG5wSsHk3hZvvBwbqPW3VfT9UApOZP275xpi6jvcV8NKRP7ATf/Wa/M724/dR6y
         jIKKkX+VRJj20eK7LzzGzW1lyQj7g57NJG860mPNAnf1QvRaHkHRqwFJh4tzu4wtfV
         QNhROSsu+nZV8FGgmKEe1fn1u7Bkk5HJqXua+5KM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaron Conole <aconole@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 178/199] openvswitch: support asymmetric conntrack
Date:   Thu, 19 Dec 2019 19:34:20 +0100
Message-Id: <20191219183225.446166098@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
References: <20191219183214.629503389@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaron Conole <aconole@redhat.com>

[ Upstream commit 5d50aa83e2c8e91ced2cca77c198b468ca9210f4 ]

The openvswitch module shares a common conntrack and NAT infrastructure
exposed via netfilter.  It's possible that a packet needs both SNAT and
DNAT manipulation, due to e.g. tuple collision.  Netfilter can support
this because it runs through the NAT table twice - once on ingress and
again after egress.  The openvswitch module doesn't have such capability.

Like netfilter hook infrastructure, we should run through NAT twice to
keep the symmetry.

Fixes: 05752523e565 ("openvswitch: Interface with NAT.")
Signed-off-by: Aaron Conole <aconole@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/openvswitch/conntrack.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -709,6 +709,17 @@ static int ovs_ct_nat(struct net *net, s
 	}
 	err = ovs_ct_nat_execute(skb, ct, ctinfo, &info->range, maniptype);
 
+	if (err == NF_ACCEPT &&
+	    ct->status & IPS_SRC_NAT && ct->status & IPS_DST_NAT) {
+		if (maniptype == NF_NAT_MANIP_SRC)
+			maniptype = NF_NAT_MANIP_DST;
+		else
+			maniptype = NF_NAT_MANIP_SRC;
+
+		err = ovs_ct_nat_execute(skb, ct, ctinfo, &info->range,
+					 maniptype);
+	}
+
 	/* Mark NAT done if successful and update the flow key. */
 	if (err == NF_ACCEPT)
 		ovs_nat_update_key(key, skb, maniptype);


