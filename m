Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03CB33A0297
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236168AbhFHTG6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:06:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:40012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237121AbhFHTEO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:04:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F04D461352;
        Tue,  8 Jun 2021 18:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177959;
        bh=e7tfVzAIhSE1lqXwp9d2grNhkhxH/7cdTqBQYWGu11Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qaQBvovUwPgW5E4jTI5HxkqqVTDWZqvebVwRJakkEyOLy+WQk5dza7wYCCWFsyw1J
         pTS/oMj1LwnvvgyGL08tBuYFIxz8yCV/4qKv0oPtrxkrA1bAXM3agtwhm9qkRLFVNt
         tjC1vqFbtf3AorXBZMt/XFdXpGNECwFCR6e6BnNc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 025/161] mptcp: always parse mptcp options for MPC reqsk
Date:   Tue,  8 Jun 2021 20:25:55 +0200
Message-Id: <20210608175946.301772230@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
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
index 1936db3574d2..8878317b4386 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -608,21 +608,20 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 
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



