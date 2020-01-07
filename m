Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23A87133349
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729284AbgAGVFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:05:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:52616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729279AbgAGVFj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:05:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 332E9208C4;
        Tue,  7 Jan 2020 21:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431138;
        bh=h78LiViRzEh6d+ijw9JkEE6khZZLjwesHoeCtKLHX88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hlpAi7vE1QDTDvWd2xO53PmnJtivkdMtdGONO/2lA+Z4+pNFahtFzDCWsordhbsTr
         zMoBMzWI9Q9WaOiGU9bpQPrTC+3aJiOWb1TJ89p39MCmWbw/pC5WPIfk9OZcad0W+/
         /sXN4OZBlHgJjbHk4eqg2Puwh4zfjotjtG+ifxTo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve Wise <larrystevenwise@gmail.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 013/115] rxe: correctly calculate iCRC for unaligned payloads
Date:   Tue,  7 Jan 2020 21:53:43 +0100
Message-Id: <20200107205248.080933189@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205240.283674026@linuxfoundation.org>
References: <20200107205240.283674026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve Wise <larrystevenwise@gmail.com>

[ Upstream commit 2030abddec6884aaf5892f5724c48fc340e6826f ]

If RoCE PDUs being sent or received contain pad bytes, then the iCRC
is miscalculated, resulting in PDUs being emitted by RXE with an incorrect
iCRC, as well as ingress PDUs being dropped due to erroneously detecting
a bad iCRC in the PDU.  The fix is to include the pad bytes, if any,
in iCRC computations.

Note: This bug has caused broken on-the-wire compatibility with actual
hardware RoCE devices since the soft-RoCE driver was first put into the
mainstream kernel.  Fixing it will create an incompatibility with the
original soft-RoCE devices, but is necessary to be compatible with real
hardware devices.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Steve Wise <larrystevenwise@gmail.com>
Link: https://lore.kernel.org/r/20191203020319.15036-2-larrystevenwise@gmail.com
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_recv.c | 2 +-
 drivers/infiniband/sw/rxe/rxe_req.c  | 6 ++++++
 drivers/infiniband/sw/rxe/rxe_resp.c | 7 +++++++
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_recv.c b/drivers/infiniband/sw/rxe/rxe_recv.c
index d30dbac24583..695a607e2d14 100644
--- a/drivers/infiniband/sw/rxe/rxe_recv.c
+++ b/drivers/infiniband/sw/rxe/rxe_recv.c
@@ -391,7 +391,7 @@ void rxe_rcv(struct sk_buff *skb)
 
 	calc_icrc = rxe_icrc_hdr(pkt, skb);
 	calc_icrc = rxe_crc32(rxe, calc_icrc, (u8 *)payload_addr(pkt),
-			      payload_size(pkt));
+			      payload_size(pkt) + bth_pad(pkt));
 	calc_icrc = (__force u32)cpu_to_be32(~calc_icrc);
 	if (unlikely(calc_icrc != pack_icrc)) {
 		if (skb->protocol == htons(ETH_P_IPV6))
diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index f7dd8de79941..1c1eae0ef8c2 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -500,6 +500,12 @@ static int fill_packet(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
 			if (err)
 				return err;
 		}
+		if (bth_pad(pkt)) {
+			u8 *pad = payload_addr(pkt) + paylen;
+
+			memset(pad, 0, bth_pad(pkt));
+			crc = rxe_crc32(rxe, crc, pad, bth_pad(pkt));
+		}
 	}
 	p = payload_addr(pkt) + paylen + bth_pad(pkt);
 
diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 681d8e0913d0..9078cfd3b8bd 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -737,6 +737,13 @@ static enum resp_states read_reply(struct rxe_qp *qp,
 	if (err)
 		pr_err("Failed copying memory\n");
 
+	if (bth_pad(&ack_pkt)) {
+		struct rxe_dev *rxe = to_rdev(qp->ibqp.device);
+		u8 *pad = payload_addr(&ack_pkt) + payload;
+
+		memset(pad, 0, bth_pad(&ack_pkt));
+		icrc = rxe_crc32(rxe, icrc, pad, bth_pad(&ack_pkt));
+	}
 	p = payload_addr(&ack_pkt) + payload + bth_pad(&ack_pkt);
 	*p = ~icrc;
 
-- 
2.20.1



