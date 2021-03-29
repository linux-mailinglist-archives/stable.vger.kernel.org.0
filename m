Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E33334CA80
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234558AbhC2Iip (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:38:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:56368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234759AbhC2IhT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:37:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35DE6619BD;
        Mon, 29 Mar 2021 08:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006994;
        bh=Hy4x0bw+r59JBIaZWpkaP3g5ChE2bRAVSysQzuZG3tE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aHUFlnODz/U6UyXC++Fo/eEF2On4sb6T9PrFS3i7OPDMgJTm3ecENqD6vetPA5WVw
         G7cWXIT6HntoN5gjWIAWYdG2+L/LVRVvgYMUhxXyqDI+jNsP9s0rLhGCbrW7LvvkBq
         HMRpAz2n2PE/GqwZU2NMvQIe/PH7Q6MuNsQWPT98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Yi <yiche@redhat.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 181/254] sctp: move sk_route_caps check and set into sctp_outq_flush_transports
Date:   Mon, 29 Mar 2021 09:58:17 +0200
Message-Id: <20210329075639.089482341@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 8ff0b1f08ea73e5c08f5addd23481e76a60e741c ]

The sk's sk_route_caps is set in sctp_packet_config, and later it
only needs to change when traversing the transport_list in a loop,
as the dst might be changed in the tx path.

So move sk_route_caps check and set into sctp_outq_flush_transports
from sctp_packet_transmit. This also fixes a dst leak reported by
Chen Yi:

  https://bugzilla.kernel.org/show_bug.cgi?id=212227

As calling sk_setup_caps() in sctp_packet_transmit may also set the
sk_route_caps for the ctrl sock in a netns. When the netns is being
deleted, the ctrl sock's releasing is later than dst dev's deleting,
which will cause this dev's deleting to hang and dmesg error occurs:

  unregister_netdevice: waiting for xxx to become free. Usage count = 1

Reported-by: Chen Yi <yiche@redhat.com>
Fixes: bcd623d8e9fa ("sctp: call sk_setup_caps in sctp_packet_transmit instead")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/output.c   | 7 -------
 net/sctp/outqueue.c | 7 +++++++
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/sctp/output.c b/net/sctp/output.c
index 6614c9fdc51e..a6aa17df09ef 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -584,13 +584,6 @@ int sctp_packet_transmit(struct sctp_packet *packet, gfp_t gfp)
 		goto out;
 	}
 
-	rcu_read_lock();
-	if (__sk_dst_get(sk) != tp->dst) {
-		dst_hold(tp->dst);
-		sk_setup_caps(sk, tp->dst);
-	}
-	rcu_read_unlock();
-
 	/* pack up chunks */
 	pkt_count = sctp_packet_pack(packet, head, gso, gfp);
 	if (!pkt_count) {
diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index 3fd06a27105d..5cb1aa5f067b 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -1135,6 +1135,7 @@ static void sctp_outq_flush_data(struct sctp_flush_ctx *ctx,
 
 static void sctp_outq_flush_transports(struct sctp_flush_ctx *ctx)
 {
+	struct sock *sk = ctx->asoc->base.sk;
 	struct list_head *ltransport;
 	struct sctp_packet *packet;
 	struct sctp_transport *t;
@@ -1144,6 +1145,12 @@ static void sctp_outq_flush_transports(struct sctp_flush_ctx *ctx)
 		t = list_entry(ltransport, struct sctp_transport, send_ready);
 		packet = &t->packet;
 		if (!sctp_packet_empty(packet)) {
+			rcu_read_lock();
+			if (t->dst && __sk_dst_get(sk) != t->dst) {
+				dst_hold(t->dst);
+				sk_setup_caps(sk, t->dst);
+			}
+			rcu_read_unlock();
 			error = sctp_packet_transmit(packet, ctx->gfp);
 			if (error < 0)
 				ctx->q->asoc->base.sk->sk_err = -error;
-- 
2.30.1



