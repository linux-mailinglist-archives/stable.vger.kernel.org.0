Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2DAA1D0E6F
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387798AbgEMKAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 06:00:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:53458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387754AbgEMJwL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:52:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB6CA20575;
        Wed, 13 May 2020 09:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363531;
        bh=dHuJGjr6XK/FSo+1wCO++KttMGGK+sidM+ctbYH9GKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zL7ZuXN38cuT978NATvXog5/+M0HVGI6ntNB66AMjtg1A4u4yQdenHkmNmEJgt8rO
         1wrBvG5tO3J9igyU0i7Cd1QL3pOMpM3gmo0pVR/WTW4r0e34Xq56jSyEFK9hEq1p9P
         GqDqm0yb2EtTXb7mhLPNJs7kzLq9iwdX48RQ3aNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@mellanox.com>,
        Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 021/118] net: bridge: vlan: Add a schedule point during VLAN processing
Date:   Wed, 13 May 2020 11:44:00 +0200
Message-Id: <20200513094419.579670715@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

[ Upstream commit 7979457b1d3a069cd857f5bd69e070e30223dd0c ]

User space can request to delete a range of VLANs from a bridge slave in
one netlink request. For each deleted VLAN the FDB needs to be traversed
in order to flush all the affected entries.

If a large range of VLANs is deleted and the number of FDB entries is
large or the FDB lock is contented, it is possible for the kernel to
loop through the deleted VLANs for a long time. In case preemption is
disabled, this can result in a soft lockup.

Fix this by adding a schedule point after each VLAN is deleted to yield
the CPU, if needed. This is safe because the VLANs are traversed in
process context.

Fixes: bdced7ef7838 ("bridge: support for multiple vlans and vlan ranges in setlink and dellink requests")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reported-by: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Tested-by: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_netlink.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -612,6 +612,7 @@ int br_process_vlan_info(struct net_brid
 					       v - 1, rtm_cmd);
 				v_change_start = 0;
 			}
+			cond_resched();
 		}
 		/* v_change_start is set only if the last/whole range changed */
 		if (v_change_start)


