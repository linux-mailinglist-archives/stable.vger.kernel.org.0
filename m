Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A83943A0176
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236057AbhFHSwQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:52:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:49558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236288AbhFHSuV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:50:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 880B061468;
        Tue,  8 Jun 2021 18:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177570;
        bh=AaMwDixglMavB87jzoisnzjLq4r1/dPWSqnVRebWmBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dcgmOj8ZcGrHAHb/FFKNnLmEXQ6CRQQ2yMzGBpQMCkuMhpu96r7K8QcqbRBRayoak
         AW37Owsw5YXzvzU6Gs8Buu4m++C4UHXSJ31Ri+QNXgvkb8mM0gi+Q0VYyupXbLMem3
         i1fe78P82XfRtVaUx029YLGsDA89/D++EYkNhxE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 021/137] mptcp: always parse mptcp options for MPC reqsk
Date:   Tue,  8 Jun 2021 20:26:01 +0200
Message-Id: <20210608175943.135195458@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 06f9a435b3aa12f4de6da91f11fdce8ce7b46205 ]

In subflow_syn_recv_sock() we currently skip options parsing
for OoO packet, given that such packets may not carry the relevant
MPC option.

If the peer generates an MPC+data TSO packet and some of the early
segments are lost or get reorder, we server will ignore the peer key,
causing transient, unexpected fallback to TCP.

The solution is always parsing the incoming MPTCP options, and
do the fallback only for in-order packets. This actually cleans
the existing code a bit.

Fixes: d22f4988ffec ("mptcp: process MP_CAPABLE data option")
Reported-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/subflow.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index bdd6af38a9ae..96b6aca9d0ae 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -527,21 +527,20 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 
 	/* if the sk is MP_CAPABLE, we try to fetch the client key */
 	if (subflow_req->mp_capable) {
-		if (TCP_SKB_CB(skb)->seq != subflow_req->ssn_offset + 1) {
-			/* here we can receive and accept an in-window,
-			 * out-of-order pkt, which will not carry the MP_CAPABLE
-			 * opt even on mptcp enabled paths
-			 */
-			goto create_msk;
-		}
-
+		/* we can receive and accept an in-window, out-of-order pkt,
+		 * which may not carry the MP_CAPABLE opt even on mptcp enabled
+		 * paths: always try to extract the peer key, and fallback
+		 * for packets missing it.
+		 * Even OoO DSS packets coming legitly after dropped or
+		 * reordered MPC will cause fallback, but we don't have other
+		 * options.
+		 */
 		mptcp_get_options(skb, &mp_opt);
 		if (!mp_opt.mp_capable) {
 			fallback = true;
 			goto create_child;
 		}
 
-create_msk:
 		new_msk = mptcp_sk_clone(listener->conn, &mp_opt, req);
 		if (!new_msk)
 			fallback = true;
-- 
2.30.2



