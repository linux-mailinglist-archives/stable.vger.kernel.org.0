Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A983B66D6A
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729029AbfGLM3p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:29:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:44838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728264AbfGLM3o (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:29:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D562521019;
        Fri, 12 Jul 2019 12:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934583;
        bh=l+gQSEoRDnqdO8m78BRffvFCVtI5c3S8E0DX7f9ql/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=degALWQoCupx3GVm7j5lFDlbu4G75iDjgKbd5G+tMt7d1sv0ca5UD9KQSMzc4oyoU
         J3KPiiMY2MAJHpz1KWSH6+0vOy1tv2gUyWkqw7/7k9NNf8FJ6wO2vOGdusbKZJXRvO
         4oC9YmKaBveEMcMTkJ3nkMkFdq8n7qI/9YlU4QVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 076/138] IB/hfi1: Handle port down properly in pio
Date:   Fri, 12 Jul 2019 14:19:00 +0200
Message-Id: <20190712121631.621836127@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
References: <20190712121628.731888964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 63d62ac7434a..117e73cd69d7 100644
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



