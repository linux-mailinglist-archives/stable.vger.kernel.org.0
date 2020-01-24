Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 058B4148203
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:24:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403788AbgAXLYh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:24:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:38116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403787AbgAXLYg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:24:36 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62DA320718;
        Fri, 24 Jan 2020 11:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865076;
        bh=Kh+0te2NeZyh5Ek5NTCf4Kp0XT5Mcc6gYjNxFNO6Nn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DuEzn0zlphoEa1umkKLWmQF3kM9OorQ/2FPqSZH0LcUvIF9C1GFWhXnwTvsREAyJW
         Ox0PGbj9BLZo7hRJ/7exzTPYiIftB6YqHmnpe4lIDs5Z6/YZLrfKL11ognjdLdfSoR
         dbZYhsR3jenPzXdSBwd2kbaTpMSKFWrj5ASJzFi8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 433/639] IB/hfi1: Handle port down properly in pio
Date:   Fri, 24 Jan 2020 10:30:03 +0100
Message-Id: <20200124093141.271914353@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 752057647f091..3fcbf56f8be23 100644
--- a/drivers/infiniband/hw/hfi1/pio.c
+++ b/drivers/infiniband/hw/hfi1/pio.c
@@ -1434,7 +1434,8 @@ void sc_stop(struct send_context *sc, int flag)
  * @cb: optional callback to call when the buffer is finished sending
  * @arg: argument for cb
  *
- * Return a pointer to a PIO buffer if successful, NULL if not enough room.
+ * Return a pointer to a PIO buffer, NULL if not enough room, -ECOMM
+ * when link is down.
  */
 struct pio_buf *sc_buffer_alloc(struct send_context *sc, u32 dw_len,
 				pio_release_cb cb, void *arg)
@@ -1450,7 +1451,7 @@ struct pio_buf *sc_buffer_alloc(struct send_context *sc, u32 dw_len,
 	spin_lock_irqsave(&sc->alloc_lock, flags);
 	if (!(sc->flags & SCF_ENABLED)) {
 		spin_unlock_irqrestore(&sc->alloc_lock, flags);
-		goto done;
+		return ERR_PTR(-ECOMM);
 	}
 
 retry:
diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index 980168a567071..7ed6fb407a689 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -914,7 +914,7 @@ void hfi1_send_rc_ack(struct hfi1_packet *packet, bool is_fecn)
 	pbc = create_pbc(ppd, pbc_flags, qp->srate_mbps,
 			 sc_to_vlt(ppd->dd, sc5), plen);
 	pbuf = sc_buffer_alloc(rcd->sc, plen, NULL, NULL);
-	if (!pbuf) {
+	if (IS_ERR_OR_NULL(pbuf)) {
 		/*
 		 * We have no room to send at the moment.  Pass
 		 * responsibility for sending the ACK to the send engine
diff --git a/drivers/infiniband/hw/hfi1/ud.c b/drivers/infiniband/hw/hfi1/ud.c
index ef5b3ffd3888b..839593641e3fd 100644
--- a/drivers/infiniband/hw/hfi1/ud.c
+++ b/drivers/infiniband/hw/hfi1/ud.c
@@ -703,7 +703,7 @@ void return_cnp_16B(struct hfi1_ibport *ibp, struct rvt_qp *qp,
 	pbc = create_pbc(ppd, pbc_flags, qp->srate_mbps, vl, plen);
 	if (ctxt) {
 		pbuf = sc_buffer_alloc(ctxt, plen, NULL, NULL);
-		if (pbuf) {
+		if (!IS_ERR_OR_NULL(pbuf)) {
 			trace_pio_output_ibhdr(ppd->dd, &hdr, sc5);
 			ppd->dd->pio_inline_send(ppd->dd, pbuf, pbc,
 						 &hdr, hwords);
@@ -758,7 +758,7 @@ void return_cnp(struct hfi1_ibport *ibp, struct rvt_qp *qp, u32 remote_qpn,
 	pbc = create_pbc(ppd, pbc_flags, qp->srate_mbps, vl, plen);
 	if (ctxt) {
 		pbuf = sc_buffer_alloc(ctxt, plen, NULL, NULL);
-		if (pbuf) {
+		if (!IS_ERR_OR_NULL(pbuf)) {
 			trace_pio_output_ibhdr(ppd->dd, &hdr, sc5);
 			ppd->dd->pio_inline_send(ppd->dd, pbuf, pbc,
 						 &hdr, hwords);
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 4e7b3c027901b..90e12f9433a39 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1096,10 +1096,10 @@ int hfi1_verbs_send_pio(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
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



