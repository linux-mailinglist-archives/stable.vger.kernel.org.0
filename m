Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4D5420F85
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235058AbhJDNfn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:35:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:48650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237915AbhJDNd1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:33:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B7D461AFB;
        Mon,  4 Oct 2021 13:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353312;
        bh=6LI1YIgDj93n3QpB3bBhQyuMdgSbIaQMZm7vvdiDFWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1orxzTpad8ZWN843Ak+RT2gOr0TObH6x2Pv6ZtPTR2krdcyRO6VnzRI2K9bRGb1ma
         uhBl04C8unZoTZ4Y5WiMjf98dO5cm9g6CXI9HiwyUikSMMiE2jfbeHF7pqs7P1yoHu
         +DHsh8x3iIwhgROuqEumlLRB5N6tmSAAZlkgZuI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Lameter <cl@linux.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 078/172] IB/cma: Do not send IGMP leaves for sendonly Multicast groups
Date:   Mon,  4 Oct 2021 14:52:08 +0200
Message-Id: <20211004125047.517377919@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Lameter <cl@gentwo.de>

[ Upstream commit 2cc74e1ee31d00393b6698ec80b322fd26523da4 ]

ROCE uses IGMP for Multicast instead of the native Infiniband system where
joins are required in order to post messages on the Multicast group.  On
Ethernet one can send Multicast messages to arbitrary addresses without
the need to subscribe to a group.

So ROCE correctly does not send IGMP joins during rdma_join_multicast().

F.e. in cma_iboe_join_multicast() we see:

   if (addr->sa_family == AF_INET) {
                if (gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP) {
                        ib.rec.hop_limit = IPV6_DEFAULT_HOPLIMIT;
                        if (!send_only) {
                                err = cma_igmp_send(ndev, &ib.rec.mgid,
                                                    true);
                        }
                }
        } else {

So the IGMP join is suppressed as it is unnecessary.

However no such check is done in destroy_mc(). And therefore leaving a
sendonly multicast group will send an IGMP leave.

This means that the following scenario can lead to a multicast receiver
unexpectedly being unsubscribed from a MC group:

1. Sender thread does a sendonly join on MC group X. No IGMP join
   is sent.

2. Receiver thread does a regular join on the same MC Group x.
   IGMP join is sent and the receiver begins to get messages.

3. Sender thread terminates and destroys MC group X.
   IGMP leave is sent and the receiver no longer receives data.

This patch adds the same logic for sendonly joins to destroy_mc() that is
also used in cma_iboe_join_multicast().

Fixes: ab15c95a17b3 ("IB/core: Support for CMA multicast join flags")
Link: https://lore.kernel.org/r/alpine.DEB.2.22.394.2109081340540.668072@gentwo.de
Signed-off-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cma.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 36ab9da70932..107462905b21 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1818,6 +1818,8 @@ static void cma_release_port(struct rdma_id_private *id_priv)
 static void destroy_mc(struct rdma_id_private *id_priv,
 		       struct cma_multicast *mc)
 {
+	bool send_only = mc->join_state == BIT(SENDONLY_FULLMEMBER_JOIN);
+
 	if (rdma_cap_ib_mcast(id_priv->id.device, id_priv->id.port_num))
 		ib_sa_free_multicast(mc->sa_mc);
 
@@ -1834,7 +1836,10 @@ static void destroy_mc(struct rdma_id_private *id_priv,
 
 			cma_set_mgid(id_priv, (struct sockaddr *)&mc->addr,
 				     &mgid);
-			cma_igmp_send(ndev, &mgid, false);
+
+			if (!send_only)
+				cma_igmp_send(ndev, &mgid, false);
+
 			dev_put(ndev);
 		}
 
-- 
2.33.0



