Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3528452380
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344979AbhKPB0y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:26:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:35164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243410AbhKOTCt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:02:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7DD063366;
        Mon, 15 Nov 2021 18:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000100;
        bh=26/YeTE97UOJ2PxTmcl8ka76U3or3foLfK8H16RiVvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gr6l99k1MOcP/p+fgaGOpXs2OkVT2tf1o6QXJuvAyYcRdvILEy92z5r3spzBuZl3D
         kiF2FNXBO+Bo4TAM6Xn5HG5NEByGRPH/BWXQGgoc6FI9hOVJCnAsoDXEp+PofdoQ7g
         bYX23ezrlpNg5KeTeHKthdhk6RuqXSFIaTEck6SU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ying Xu <yinxu@redhat.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 530/849] sctp: allow IP fragmentation when PLPMTUD enters Error state
Date:   Mon, 15 Nov 2021 18:00:13 +0100
Message-Id: <20211115165438.202535079@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 40171248bb8934537fec8fbaf718e57c8add187c ]

Currently when PLPMTUD enters Error state, transport pathmtu will be set
to MIN_PLPMTU(512) while probe is continuing with BASE_PLPMTU(1200). It
will cause pathmtu to stay in a very small value, even if the real pmtu
is some value like 1000.

RFC8899 doesn't clearly say how to set the value in Error state. But one
possibility could be keep using BASE_PLPMTU for the real pmtu, but allow
to do IP fragmentation when it's in Error state.

As it says in rfc8899#section-5.4:

   Some paths could be unable to sustain packets of the BASE_PLPMTU
   size.  The Error State could be implemented to provide robustness to
   such paths.  This allows fallback to a smaller than desired PLPMTU
   rather than suffer connectivity failure.  This could utilize methods
   such as endpoint IP fragmentation to enable the PL sender to
   communicate using packets smaller than the BASE_PLPMTU.

This patch is to set pmtu to BASE_PLPMTU instead of MIN_PLPMTU for Error
state in sctp_transport_pl_send/toobig(), and set packet ipfragok for
non-probe packets when it's in Error state.

Fixes: 1dc68c194571 ("sctp: do state transition when PROBE_COUNT == MAX_PROBES on HB send path")
Reported-by: Ying Xu <yinxu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/output.c    | 13 ++++++++-----
 net/sctp/transport.c |  4 ++--
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/net/sctp/output.c b/net/sctp/output.c
index 4dfb5ea82b05b..cdfdbd353c678 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -581,13 +581,16 @@ int sctp_packet_transmit(struct sctp_packet *packet, gfp_t gfp)
 	chunk = list_entry(packet->chunk_list.next, struct sctp_chunk, list);
 	sk = chunk->skb->sk;
 
-	/* check gso */
 	if (packet->size > tp->pathmtu && !packet->ipfragok && !chunk->pmtu_probe) {
-		if (!sk_can_gso(sk)) {
-			pr_err_once("Trying to GSO but underlying device doesn't support it.");
-			goto out;
+		if (tp->pl.state == SCTP_PL_ERROR) { /* do IP fragmentation if in Error state */
+			packet->ipfragok = 1;
+		} else {
+			if (!sk_can_gso(sk)) { /* check gso */
+				pr_err_once("Trying to GSO but underlying device doesn't support it.");
+				goto out;
+			}
+			gso = 1;
 		}
-		gso = 1;
 	}
 
 	/* alloc head skb */
diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index a3d3ca6dd63dd..1f2dfad768d52 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -269,7 +269,7 @@ bool sctp_transport_pl_send(struct sctp_transport *t)
 		if (t->pl.probe_size == SCTP_BASE_PLPMTU) { /* BASE_PLPMTU Confirmation Failed */
 			t->pl.state = SCTP_PL_ERROR; /* Base -> Error */
 
-			t->pl.pmtu = SCTP_MIN_PLPMTU;
+			t->pl.pmtu = SCTP_BASE_PLPMTU;
 			t->pathmtu = t->pl.pmtu + sctp_transport_pl_hlen(t);
 			sctp_assoc_sync_pmtu(t->asoc);
 		}
@@ -366,7 +366,7 @@ static bool sctp_transport_pl_toobig(struct sctp_transport *t, u32 pmtu)
 		if (pmtu >= SCTP_MIN_PLPMTU && pmtu < SCTP_BASE_PLPMTU) {
 			t->pl.state = SCTP_PL_ERROR; /* Base -> Error */
 
-			t->pl.pmtu = SCTP_MIN_PLPMTU;
+			t->pl.pmtu = SCTP_BASE_PLPMTU;
 			t->pathmtu = t->pl.pmtu + sctp_transport_pl_hlen(t);
 		}
 	} else if (t->pl.state == SCTP_PL_SEARCH) {
-- 
2.33.0



