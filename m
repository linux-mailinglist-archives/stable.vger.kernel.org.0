Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7DD420E7E
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236938AbhJDNZa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:25:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:38132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237018AbhJDNXs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:23:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AE9E61BF9;
        Mon,  4 Oct 2021 13:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353024;
        bh=f/shuwPzVil5WND4olXrU970I4Zk1shVQ9/tYXPC+uU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fs2a30yp7yH9bRV+1LmtW0EJ3o48+ejJfamTMD5BztMm7fKiJ217BlldwyTP2z0B9
         jA0TLjsza+84veA1ni4n+LQIPfx5H5H6pz9ZlSrrdgc/8b1jwrzdFn1v9wTXRDC/qN
         fWa6KxcSFdUVWkKz7xG+W536Jyrk62/YNUUzpG6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Lameter <cl@linux.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 27/93] IB/cma: Do not send IGMP leaves for sendonly Multicast groups
Date:   Mon,  4 Oct 2021 14:52:25 +0200
Message-Id: <20211004125035.472636900@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125034.579439135@linuxfoundation.org>
References: <20211004125034.579439135@linuxfoundation.org>
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
index a4962b499b61..3029e96161b5 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1814,6 +1814,8 @@ static void cma_release_port(struct rdma_id_private *id_priv)
 static void destroy_mc(struct rdma_id_private *id_priv,
 		       struct cma_multicast *mc)
 {
+	bool send_only = mc->join_state == BIT(SENDONLY_FULLMEMBER_JOIN);
+
 	if (rdma_cap_ib_mcast(id_priv->id.device, id_priv->id.port_num))
 		ib_sa_free_multicast(mc->sa_mc);
 
@@ -1830,7 +1832,10 @@ static void destroy_mc(struct rdma_id_private *id_priv,
 
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



