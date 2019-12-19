Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0774126C1F
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729974AbfLSSuY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:50:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:44226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729970AbfLSSuX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:50:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CBFB2064B;
        Thu, 19 Dec 2019 18:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781422;
        bh=HHdoDJ7rmZglhmmXVeqvhm7b+Zk+loPFJUyB8Ox7+cg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c8fGXNobPaa7H6Zt8WGJfFOr4JEUxaIQ+Z0ULJ/LxF4T7iuZx8H9h85weHRQ+kuUZ
         5GyfaVoHrEe5RLupVZRXURDnc6fIsoOrFtA61bVnk/6adjuu4Ipobzkahm9ETfRBjl
         KLwKdVyKhKilVwprmpihJtp6ibqaURTyZsN2phSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaron Conole <aconole@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 05/36] openvswitch: support asymmetric conntrack
Date:   Thu, 19 Dec 2019 19:34:22 +0100
Message-Id: <20191219182855.197824990@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219182848.708141124@linuxfoundation.org>
References: <20191219182848.708141124@linuxfoundation.org>
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
@@ -879,6 +879,17 @@ static int ovs_ct_nat(struct net *net, s
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


