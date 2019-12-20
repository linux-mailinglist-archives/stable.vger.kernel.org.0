Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E940E127DCF
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 15:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727756AbfLTOgl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 09:36:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:39060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728305AbfLTOev (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Dec 2019 09:34:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 205402465E;
        Fri, 20 Dec 2019 14:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576852490;
        bh=W9zbRmuy6oxxYdUeD2QHIDLLTPNGatBeVljSEgekXjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xrp4ynRjHCIT5Jj2iumv7CBDg+PeEtS1OrUtyK6ex6KOO8YLsYEDO4IcR+LBbim0R
         /Bk0TqQ7s2j6DCCcysxc+4HwOaB6BUPOoe+5EhAwYgD9MZiZPMaITTF3+49cjE48qa
         3Zx5lIJB4+adK/sS+G9caS/YVcvWRj5DaVmoiBbk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve Wise <larrystevenwise@gmail.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 13/34] rxe: correctly calculate iCRC for unaligned payloads
Date:   Fri, 20 Dec 2019 09:34:12 -0500
Message-Id: <20191220143433.9922-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191220143433.9922-1-sashal@kernel.org>
References: <20191220143433.9922-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index d30dbac24583a..695a607e2d14c 100644
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
index f7dd8de799415..1c1eae0ef8c28 100644
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
index 681d8e0913d06..9078cfd3b8bdd 100644
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

