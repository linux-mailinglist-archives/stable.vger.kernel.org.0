Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39C6D57609
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 02:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727570AbfF0Ae4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 20:34:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728123AbfF0Ae4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 20:34:56 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C45D21738;
        Thu, 27 Jun 2019 00:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595694;
        bh=QGR4ZKaPSguYuNsvWs7ETt2GAziORssafGaFuyb9SPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PyLRZHJ91xMKpvsj/bifrogOmPiZ4XE0pKJ7QH8E9kSaLV6ctsPLOKBpPUn0BskdT
         2EkQ/Jddy20SfvUDWSOKKaFUpdduljgcthFUUb1Ghpz9yWp45lV9bcTzT0R//n6HZ2
         Rgpt1tPACiK7MGVIoJ+mKV7l/cBjTBIwhjtIToBg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 82/95] IB/hfi1: Handle port down properly in pio
Date:   Wed, 26 Jun 2019 20:30:07 -0400
Message-Id: <20190627003021.19867-82-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

[ Upstream commit 942a899335707fc9cfc97cb382a60734b2ff4e03 ]

The call to sc_buffer_alloc currently returns NULL (no buffer) or
a buffer descriptor.

There is a third case when the port is down.  Currently that
returns NULL and this prevents the caller from properly handling the
sc_buffer_alloc() failure.  A verbs code link test after the call is
racy so the indication needs to come from the state check inside the allocation
routine to be valid.

Fix by encoding the ECOMM failure like SDMA.   IS_ERR_OR_NULL() tests
are added at all call sites.  For verbs send, this needs to treat any
error by returning a completion without any MMIO copy.

Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/pio.c   | 5 +++--
 drivers/infiniband/hw/hfi1/rc.c    | 2 +-
 drivers/infiniband/hw/hfi1/ud.c    | 4 ++--
 drivers/infiniband/hw/hfi1/verbs.c | 4 ++--
 4 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/pio.c b/drivers/infiniband/hw/hfi1/pio.c
index 1ee47838d4de..17ea224fbecb 100644
--- a/drivers/infiniband/hw/hfi1/pio.c
+++ b/drivers/infiniband/hw/hfi1/pio.c
@@ -1443,7 +1443,8 @@ void sc_stop(struct send_context *sc, int flag)
  * @cb: optional callback to call when the buffer is finished sending
  * @arg: argument for cb
  *
- * Return a pointer to a PIO buffer if successful, NULL if not enough room.
+ * Return a pointer to a PIO buffer, NULL if not enough room, -ECOMM
+ * when link is down.
  */
 struct pio_buf *sc_buffer_alloc(struct send_context *sc, u32 dw_len,
 				pio_release_cb cb, void *arg)
@@ -1459,7 +1460,7 @@ struct pio_buf *sc_buffer_alloc(struct send_context *sc, u32 dw_len,
 	spin_lock_irqsave(&sc->alloc_lock, flags);
 	if (!(sc->flags & SCF_ENABLED)) {
 		spin_unlock_irqrestore(&sc->alloc_lock, flags);
-		goto done;
+		return ERR_PTR(-ECOMM);
 	}
 
 retry:
diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index 24cbac277bf0..b7b74222eaf0 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -1434,7 +1434,7 @@ void hfi1_send_rc_ack(struct hfi1_packet *packet, bool is_fecn)
 	pbc = create_pbc(ppd, pbc_flags, qp->srate_mbps,
 			 sc_to_vlt(ppd->dd, sc5), plen);
 	pbuf = sc_buffer_alloc(rcd->sc, plen, NULL, NULL);
-	if (!pbuf) {
+	if (IS_ERR_OR_NULL(pbuf)) {
 		/*
 		 * We have no room to send at the moment.  Pass
 		 * responsibility for sending the ACK to the send engine
diff --git a/drivers/infiniband/hw/hfi1/ud.c b/drivers/infiniband/hw/hfi1/ud.c
index f88ad425664a..4cb0fce5c096 100644
--- a/drivers/infiniband/hw/hfi1/ud.c
+++ b/drivers/infiniband/hw/hfi1/ud.c
@@ -683,7 +683,7 @@ void return_cnp_16B(struct hfi1_ibport *ibp, struct rvt_qp *qp,
 	pbc = create_pbc(ppd, pbc_flags, qp->srate_mbps, vl, plen);
 	if (ctxt) {
 		pbuf = sc_buffer_alloc(ctxt, plen, NULL, NULL);
-		if (pbuf) {
+		if (!IS_ERR_OR_NULL(pbuf)) {
 			trace_pio_output_ibhdr(ppd->dd, &hdr, sc5);
 			ppd->dd->pio_inline_send(ppd->dd, pbuf, pbc,
 						 &hdr, hwords);
@@ -738,7 +738,7 @@ void return_cnp(struct hfi1_ibport *ibp, struct rvt_qp *qp, u32 remote_qpn,
 	pbc = create_pbc(ppd, pbc_flags, qp->srate_mbps, vl, plen);
 	if (ctxt) {
 		pbuf = sc_buffer_alloc(ctxt, plen, NULL, NULL);
-		if (pbuf) {
+		if (!IS_ERR_OR_NULL(pbuf)) {
 			trace_pio_output_ibhdr(ppd->dd, &hdr, sc5);
 			ppd->dd->pio_inline_send(ppd->dd, pbuf, pbc,
 						 &hdr, hwords);
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 8d64972c6226..ef290f1fdf63 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1039,10 +1039,10 @@ int hfi1_verbs_send_pio(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 	if (cb)
 		iowait_pio_inc(&priv->s_iowait);
 	pbuf = sc_buffer_alloc(sc, plen, cb, qp);
-	if (unlikely(!pbuf)) {
+	if (unlikely(IS_ERR_OR_NULL(pbuf))) {
 		if (cb)
 			verbs_pio_complete(qp, 0);
-		if (ppd->host_link_state != HLS_UP_ACTIVE) {
+		if (IS_ERR(pbuf)) {
 			/*
 			 * If we have filled the PIO buffers to capacity and are
 			 * not in an active state this request is not going to
-- 
2.20.1

