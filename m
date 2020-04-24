Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A98311B7DA3
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 20:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728692AbgDXSN2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 14:13:28 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:39072 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728469AbgDXSN1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 14:13:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587752004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=jxOzpKVPHKn5MvaZVsOpstO6HWV0tuIA0WpwLQfRDm8=;
        b=dfBoDBqrM/nLq70xnyAvkhrl/UFehOWrbkcxaoZnWF3NXC937e0r7hp2cLcic98w7Yc/pG
        FF3KcOdiClfBEcvhSahWcHFigctXxzIv30DIUyeARm9XxNJFsZdE3mqs7iPsKC5b9rOf/1
        /rwbsa4sn7vprEy9V6J9Zp34otnSxTU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-lWoSOydVOjKPQ1y6Hr9pqg-1; Fri, 24 Apr 2020 14:13:22 -0400
X-MC-Unique: lWoSOydVOjKPQ1y6Hr9pqg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 78A84835B41;
        Fri, 24 Apr 2020 18:13:20 +0000 (UTC)
Received: from Ruby.redhat.com (ovpn-115-210.rdu2.redhat.com [10.10.115.210])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CEF0B5D70C;
        Fri, 24 Apr 2020 18:13:16 +0000 (UTC)
From:   Lyude Paul <lyude@redhat.com>
To:     dri-devel@lists.freedesktop.org
Cc:     Sean Paul <sean@poorly.run>, "Lin, Wayne" <Wayne.Lin@amd.com>,
        stable@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>,
        Todd Previte <tprevite@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] drm/dp_mst: Kill the second sideband tx slot, save the world
Date:   Fri, 24 Apr 2020 14:13:08 -0400
Message-Id: <20200424181308.770749-1-lyude@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While we support using both tx slots for sideband transmissions, it
appears that DisplayPort devices in the field didn't end up doing a very
good job of supporting it. From section 5.2.1 of the DP 2.0
specification:

  There are MST Sink/Branch devices in the field that do not handle
  interleaved message transactions.

  To facilitate message transaction handling by downstream devices, an
  MST Source device shall generate message transactions in an atomic
  manner (i.e., the MST Source device shall not concurrently interleave
  multiple message transactions). Therefore, an MST Source device shall
  clear the Message_Sequence_No value in the Sideband_MSG_Header to 0.

This might come as a bit of a surprise since the vast majority of hubs
will support using both tx slots even if they don't support interleaved
message transactions, and we've also been using both tx slots since MST
was introduced into the kernel.

However, there is one device we've had trouble getting working
consistently with MST for so long that we actually assumed it was just
broken: the infamous Dell P2415Qb. Previously this monitor would appear
to work sometimes, but in most situations would end up timing out
LINK_ADDRESS messages almost at random until you power cycled the whole
display. After reading section 5.2.1 in the DP 2.0 spec, some closer
investigation into this infamous display revealed it was only ever
timing out on sideband messages in the second TX slot.

Sure enough, avoiding the second TX slot has suddenly made this monitor
function perfectly for the first time in five years. And since they
explicitly mention this in the specification, I doubt this is the only
monitor out there with this issue. This might even explain explain the
seemingly harmless garbage sideband responses we would occasionally see
with MST hubs!

So - rewrite our sideband TX handlers to only support one TX slot. In
order to simplify our sideband handling now that we don't support
transmitting to multiple MSTBs at once, we also move all state tracking
for down replies from mstbs to the topology manager.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: ad7f8a1f9ced ("drm/helper: add Displayport multi-stream helper (v0=
.6)")
Cc: Sean Paul <sean@poorly.run>
Cc: "Lin, Wayne" <Wayne.Lin@amd.com>
Cc: <stable@vger.kernel.org> # v3.17+
---
 drivers/gpu/drm/drm_dp_mst_topology.c | 149 ++++++++------------------
 include/drm/drm_dp_mst_helper.h       |  29 ++---
 2 files changed, 50 insertions(+), 128 deletions(-)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_=
dp_mst_topology.c
index 03a1496f6120..dec5df82eef4 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -1197,16 +1197,8 @@ static int drm_dp_mst_wait_tx_reply(struct drm_dp_=
mst_branch *mstb,
=20
 		/* remove from q */
 		if (txmsg->state =3D=3D DRM_DP_SIDEBAND_TX_QUEUED ||
-		    txmsg->state =3D=3D DRM_DP_SIDEBAND_TX_START_SEND) {
+		    txmsg->state =3D=3D DRM_DP_SIDEBAND_TX_START_SEND)
 			list_del(&txmsg->next);
-		}
-
-		if (txmsg->state =3D=3D DRM_DP_SIDEBAND_TX_START_SEND ||
-		    txmsg->state =3D=3D DRM_DP_SIDEBAND_TX_SENT) {
-			mstb->tx_slots[txmsg->seqno] =3D NULL;
-		}
-		mgr->is_waiting_for_dwn_reply =3D false;
-
 	}
 out:
 	if (unlikely(ret =3D=3D -EIO) && drm_debug_enabled(DRM_UT_DP)) {
@@ -2685,22 +2677,6 @@ static int set_hdr_from_dst_qlock(struct drm_dp_si=
deband_msg_hdr *hdr,
 	struct drm_dp_mst_branch *mstb =3D txmsg->dst;
 	u8 req_type;
=20
-	/* both msg slots are full */
-	if (txmsg->seqno =3D=3D -1) {
-		if (mstb->tx_slots[0] && mstb->tx_slots[1]) {
-			DRM_DEBUG_KMS("%s: failed to find slot\n", __func__);
-			return -EAGAIN;
-		}
-		if (mstb->tx_slots[0] =3D=3D NULL && mstb->tx_slots[1] =3D=3D NULL) {
-			txmsg->seqno =3D mstb->last_seqno;
-			mstb->last_seqno ^=3D 1;
-		} else if (mstb->tx_slots[0] =3D=3D NULL)
-			txmsg->seqno =3D 0;
-		else
-			txmsg->seqno =3D 1;
-		mstb->tx_slots[txmsg->seqno] =3D txmsg;
-	}
-
 	req_type =3D txmsg->msg[0] & 0x7f;
 	if (req_type =3D=3D DP_CONNECTION_STATUS_NOTIFY ||
 		req_type =3D=3D DP_RESOURCE_STATUS_NOTIFY)
@@ -2712,7 +2688,7 @@ static int set_hdr_from_dst_qlock(struct drm_dp_sid=
eband_msg_hdr *hdr,
 	hdr->lcr =3D mstb->lct - 1;
 	if (mstb->lct > 1)
 		memcpy(hdr->rad, mstb->rad, mstb->lct / 2);
-	hdr->seqno =3D txmsg->seqno;
+
 	return 0;
 }
 /*
@@ -2727,15 +2703,15 @@ static int process_single_tx_qlock(struct drm_dp_=
mst_topology_mgr *mgr,
 	int len, space, idx, tosend;
 	int ret;
=20
+	if (txmsg->state =3D=3D DRM_DP_SIDEBAND_TX_SENT)
+		return 0;
+
 	memset(&hdr, 0, sizeof(struct drm_dp_sideband_msg_hdr));
=20
-	if (txmsg->state =3D=3D DRM_DP_SIDEBAND_TX_QUEUED) {
-		txmsg->seqno =3D -1;
+	if (txmsg->state =3D=3D DRM_DP_SIDEBAND_TX_QUEUED)
 		txmsg->state =3D DRM_DP_SIDEBAND_TX_START_SEND;
-	}
=20
-	/* make hdr from dst mst - for replies use seqno
-	   otherwise assign one */
+	/* make hdr from dst mst */
 	ret =3D set_hdr_from_dst_qlock(&hdr, txmsg);
 	if (ret < 0)
 		return ret;
@@ -2788,42 +2764,17 @@ static void process_single_down_tx_qlock(struct d=
rm_dp_mst_topology_mgr *mgr)
 	if (list_empty(&mgr->tx_msg_downq))
 		return;
=20
-	txmsg =3D list_first_entry(&mgr->tx_msg_downq, struct drm_dp_sideband_m=
sg_tx, next);
+	txmsg =3D list_first_entry(&mgr->tx_msg_downq,
+				 struct drm_dp_sideband_msg_tx, next);
 	ret =3D process_single_tx_qlock(mgr, txmsg, false);
-	if (ret =3D=3D 1) {
-		/* txmsg is sent it should be in the slots now */
-		mgr->is_waiting_for_dwn_reply =3D true;
-		list_del(&txmsg->next);
-	} else if (ret) {
+	if (ret < 0) {
 		DRM_DEBUG_KMS("failed to send msg in q %d\n", ret);
-		mgr->is_waiting_for_dwn_reply =3D false;
 		list_del(&txmsg->next);
-		if (txmsg->seqno !=3D -1)
-			txmsg->dst->tx_slots[txmsg->seqno] =3D NULL;
 		txmsg->state =3D DRM_DP_SIDEBAND_TX_TIMEOUT;
 		wake_up_all(&mgr->tx_waitq);
 	}
 }
=20
-/* called holding qlock */
-static void process_single_up_tx_qlock(struct drm_dp_mst_topology_mgr *m=
gr,
-				       struct drm_dp_sideband_msg_tx *txmsg)
-{
-	int ret;
-
-	/* construct a chunk from the first msg in the tx_msg queue */
-	ret =3D process_single_tx_qlock(mgr, txmsg, true);
-
-	if (ret !=3D 1)
-		DRM_DEBUG_KMS("failed to send msg in q %d\n", ret);
-
-	if (txmsg->seqno !=3D -1) {
-		WARN_ON((unsigned int)txmsg->seqno >
-			ARRAY_SIZE(txmsg->dst->tx_slots));
-		txmsg->dst->tx_slots[txmsg->seqno] =3D NULL;
-	}
-}
-
 static void drm_dp_queue_down_tx(struct drm_dp_mst_topology_mgr *mgr,
 				 struct drm_dp_sideband_msg_tx *txmsg)
 {
@@ -2836,8 +2787,7 @@ static void drm_dp_queue_down_tx(struct drm_dp_mst_=
topology_mgr *mgr,
 		drm_dp_mst_dump_sideband_msg_tx(&p, txmsg);
 	}
=20
-	if (list_is_singular(&mgr->tx_msg_downq) &&
-	    !mgr->is_waiting_for_dwn_reply)
+	if (list_is_singular(&mgr->tx_msg_downq))
 		process_single_down_tx_qlock(mgr);
 	mutex_unlock(&mgr->qlock);
 }
@@ -3457,7 +3407,7 @@ static int drm_dp_encode_up_ack_reply(struct drm_dp=
_sideband_msg_tx *msg, u8 req
=20
 static int drm_dp_send_up_ack_reply(struct drm_dp_mst_topology_mgr *mgr,
 				    struct drm_dp_mst_branch *mstb,
-				    int req_type, int seqno, bool broadcast)
+				    int req_type, bool broadcast)
 {
 	struct drm_dp_sideband_msg_tx *txmsg;
=20
@@ -3466,13 +3416,11 @@ static int drm_dp_send_up_ack_reply(struct drm_dp=
_mst_topology_mgr *mgr,
 		return -ENOMEM;
=20
 	txmsg->dst =3D mstb;
-	txmsg->seqno =3D seqno;
 	drm_dp_encode_up_ack_reply(txmsg, req_type);
=20
 	mutex_lock(&mgr->qlock);
-
-	process_single_up_tx_qlock(mgr, txmsg);
-
+	/* construct a chunk from the first msg in the tx_msg queue */
+	process_single_tx_qlock(mgr, txmsg, true);
 	mutex_unlock(&mgr->qlock);
=20
 	kfree(txmsg);
@@ -3697,8 +3645,9 @@ int drm_dp_mst_topology_mgr_resume(struct drm_dp_ms=
t_topology_mgr *mgr,
 }
 EXPORT_SYMBOL(drm_dp_mst_topology_mgr_resume);
=20
-static bool drm_dp_get_one_sb_msg(struct drm_dp_mst_topology_mgr *mgr, b=
ool up,
-				  struct drm_dp_mst_branch **mstb, int *seqno)
+static bool
+drm_dp_get_one_sb_msg(struct drm_dp_mst_topology_mgr *mgr, bool up,
+		      struct drm_dp_mst_branch **mstb)
 {
 	int len;
 	u8 replyblock[32];
@@ -3706,13 +3655,13 @@ static bool drm_dp_get_one_sb_msg(struct drm_dp_m=
st_topology_mgr *mgr, bool up,
 	int ret;
 	u8 hdrlen;
 	struct drm_dp_sideband_msg_hdr hdr;
-	struct drm_dp_sideband_msg_rx *msg;
+	struct drm_dp_sideband_msg_rx *msg =3D
+		up ? &mgr->up_req_recv : &mgr->down_rep_recv;
 	int basereg =3D up ? DP_SIDEBAND_MSG_UP_REQ_BASE :
 			   DP_SIDEBAND_MSG_DOWN_REP_BASE;
=20
 	if (!up)
 		*mstb =3D NULL;
-	*seqno =3D -1;
=20
 	len =3D min(mgr->max_dpcd_transaction_bytes, 16);
 	ret =3D drm_dp_dpcd_read(mgr->aux, basereg, replyblock, len);
@@ -3729,11 +3678,7 @@ static bool drm_dp_get_one_sb_msg(struct drm_dp_ms=
t_topology_mgr *mgr, bool up,
 		return false;
 	}
=20
-	*seqno =3D hdr.seqno;
-
-	if (up) {
-		msg =3D &mgr->up_req_recv;
-	} else {
+	if (!up) {
 		/* Caller is responsible for giving back this reference */
 		*mstb =3D drm_dp_get_mst_branch_device(mgr, hdr.lct, hdr.rad);
 		if (!*mstb) {
@@ -3741,7 +3686,6 @@ static bool drm_dp_get_one_sb_msg(struct drm_dp_mst=
_topology_mgr *mgr, bool up,
 				      hdr.lct);
 			return false;
 		}
-		msg =3D &(*mstb)->down_rep_recv[hdr.seqno];
 	}
=20
 	if (!drm_dp_sideband_msg_set_header(msg, &hdr, hdrlen)) {
@@ -3785,13 +3729,10 @@ static int drm_dp_mst_handle_down_rep(struct drm_=
dp_mst_topology_mgr *mgr)
 {
 	struct drm_dp_sideband_msg_tx *txmsg;
 	struct drm_dp_mst_branch *mstb =3D NULL;
-	struct drm_dp_sideband_msg_rx *msg =3D NULL;
-	int seqno =3D -1;
-
-	if (!drm_dp_get_one_sb_msg(mgr, false, &mstb, &seqno))
-		goto out_clear_reply;
+	struct drm_dp_sideband_msg_rx *msg =3D &mgr->down_rep_recv;
=20
-	msg =3D &mstb->down_rep_recv[seqno];
+	if (!drm_dp_get_one_sb_msg(mgr, false, &mstb))
+		goto out;
=20
 	/* Multi-packet message transmission, don't clear the reply */
 	if (!msg->have_eomt)
@@ -3799,11 +3740,12 @@ static int drm_dp_mst_handle_down_rep(struct drm_=
dp_mst_topology_mgr *mgr)
=20
 	/* find the message */
 	mutex_lock(&mgr->qlock);
-	txmsg =3D mstb->tx_slots[seqno];
-	/* remove from slots */
+	txmsg =3D list_first_entry_or_null(&mgr->tx_msg_downq,
+					 struct drm_dp_sideband_msg_tx, next);
 	mutex_unlock(&mgr->qlock);
=20
-	if (!txmsg) {
+	/* Were we actually expecting a response, and from this mstb? */
+	if (!txmsg || txmsg->dst !=3D mstb) {
 		struct drm_dp_sideband_msg_hdr *hdr;
 		hdr =3D &msg->initial_hdr;
 		DRM_DEBUG_KMS("Got MST reply with no msg %p %d %d %02x %02x\n",
@@ -3828,8 +3770,7 @@ static int drm_dp_mst_handle_down_rep(struct drm_dp=
_mst_topology_mgr *mgr)
=20
 	mutex_lock(&mgr->qlock);
 	txmsg->state =3D DRM_DP_SIDEBAND_TX_RX;
-	mstb->tx_slots[seqno] =3D NULL;
-	mgr->is_waiting_for_dwn_reply =3D false;
+	list_del(&txmsg->next);
 	mutex_unlock(&mgr->qlock);
=20
 	wake_up_all(&mgr->tx_waitq);
@@ -3837,11 +3778,7 @@ static int drm_dp_mst_handle_down_rep(struct drm_d=
p_mst_topology_mgr *mgr)
 	return 0;
=20
 out_clear_reply:
-	mutex_lock(&mgr->qlock);
-	mgr->is_waiting_for_dwn_reply =3D false;
-	mutex_unlock(&mgr->qlock);
-	if (msg)
-		memset(msg, 0, sizeof(struct drm_dp_sideband_msg_rx));
+	memset(msg, 0, sizeof(struct drm_dp_sideband_msg_rx));
 out:
 	if (mstb)
 		drm_dp_mst_topology_put_mstb(mstb);
@@ -3921,9 +3858,8 @@ static void drm_dp_mst_up_req_work(struct work_stru=
ct *work)
 static int drm_dp_mst_handle_up_req(struct drm_dp_mst_topology_mgr *mgr)
 {
 	struct drm_dp_pending_up_req *up_req;
-	int seqno;
=20
-	if (!drm_dp_get_one_sb_msg(mgr, true, NULL, &seqno))
+	if (!drm_dp_get_one_sb_msg(mgr, true, NULL))
 		goto out;
=20
 	if (!mgr->up_req_recv.have_eomt)
@@ -3947,7 +3883,7 @@ static int drm_dp_mst_handle_up_req(struct drm_dp_m=
st_topology_mgr *mgr)
 	}
=20
 	drm_dp_send_up_ack_reply(mgr, mgr->mst_primary, up_req->msg.req_type,
-				 seqno, false);
+				 false);
=20
 	if (up_req->msg.req_type =3D=3D DP_CONNECTION_STATUS_NOTIFY) {
 		const struct drm_dp_connection_status_notify *conn_stat =3D
@@ -4693,7 +4629,7 @@ static void drm_dp_tx_work(struct work_struct *work=
)
 	struct drm_dp_mst_topology_mgr *mgr =3D container_of(work, struct drm_d=
p_mst_topology_mgr, tx_work);
=20
 	mutex_lock(&mgr->qlock);
-	if (!list_empty(&mgr->tx_msg_downq) && !mgr->is_waiting_for_dwn_reply)
+	if (!list_empty(&mgr->tx_msg_downq))
 		process_single_down_tx_qlock(mgr);
 	mutex_unlock(&mgr->qlock);
 }
@@ -4714,26 +4650,25 @@ static inline void
 drm_dp_delayed_destroy_mstb(struct drm_dp_mst_branch *mstb)
 {
 	struct drm_dp_mst_topology_mgr *mgr =3D mstb->mgr;
-	struct drm_dp_mst_port *port, *tmp;
+	struct drm_dp_mst_port *port, *port_tmp;
+	struct drm_dp_sideband_msg_tx *txmsg, *txmsg_tmp;
 	bool wake_tx =3D false;
=20
 	mutex_lock(&mgr->lock);
-	list_for_each_entry_safe(port, tmp, &mstb->ports, next) {
+	list_for_each_entry_safe(port, port_tmp, &mstb->ports, next) {
 		list_del(&port->next);
 		drm_dp_mst_topology_put_port(port);
 	}
 	mutex_unlock(&mgr->lock);
=20
-	/* drop any tx slots msg */
+	/* drop any tx slot msg */
 	mutex_lock(&mstb->mgr->qlock);
-	if (mstb->tx_slots[0]) {
-		mstb->tx_slots[0]->state =3D DRM_DP_SIDEBAND_TX_TIMEOUT;
-		mstb->tx_slots[0] =3D NULL;
-		wake_tx =3D true;
-	}
-	if (mstb->tx_slots[1]) {
-		mstb->tx_slots[1]->state =3D DRM_DP_SIDEBAND_TX_TIMEOUT;
-		mstb->tx_slots[1] =3D NULL;
+	list_for_each_entry_safe(txmsg, txmsg_tmp, &mgr->tx_msg_downq, next) {
+		if (txmsg->dst !=3D mstb)
+			continue;
+
+		txmsg->state =3D DRM_DP_SIDEBAND_TX_TIMEOUT;
+		list_del(&txmsg->next);
 		wake_tx =3D true;
 	}
 	mutex_unlock(&mstb->mgr->qlock);
diff --git a/include/drm/drm_dp_mst_helper.h b/include/drm/drm_dp_mst_hel=
per.h
index 96bcf33c03d3..9e1ffcd7cb68 100644
--- a/include/drm/drm_dp_mst_helper.h
+++ b/include/drm/drm_dp_mst_helper.h
@@ -194,11 +194,8 @@ struct drm_dp_sideband_msg_rx {
  * @rad: Relative Address to talk to this branch device.
  * @lct: Link count total to talk to this branch device.
  * @num_ports: number of ports on the branch.
- * @msg_slots: one bit per transmitted msg slot.
  * @port_parent: pointer to the port parent, NULL if toplevel.
  * @mgr: topology manager for this branch device.
- * @tx_slots: transmission slots for this device.
- * @last_seqno: last sequence number used to talk to this.
  * @link_address_sent: if a link address message has been sent to this d=
evice yet.
  * @guid: guid for DP 1.2 branch device. port under this branch can be
  * identified by port #.
@@ -239,7 +236,6 @@ struct drm_dp_mst_branch {
 	u8 lct;
 	int num_ports;
=20
-	int msg_slots;
 	/**
 	 * @ports: the list of ports on this branch device. This should be
 	 * considered protected for reading by &drm_dp_mst_topology_mgr.lock.
@@ -252,20 +248,11 @@ struct drm_dp_mst_branch {
 	 */
 	struct list_head ports;
=20
-	/* list of tx ops queue for this port */
 	struct drm_dp_mst_port *port_parent;
 	struct drm_dp_mst_topology_mgr *mgr;
=20
-	/* slots are protected by mstb->mgr->qlock */
-	struct drm_dp_sideband_msg_tx *tx_slots[2];
-	int last_seqno;
 	bool link_address_sent;
=20
-	/**
-	 * @down_rep_recv: Message receiver state for down replies.
-	 */
-	struct drm_dp_sideband_msg_rx down_rep_recv[2];
-
 	/* global unique identifier to identify branch devices */
 	u8 guid[16];
 };
@@ -567,6 +554,12 @@ struct drm_dp_mst_topology_mgr {
 	 */
 	struct drm_dp_sideband_msg_rx up_req_recv;
=20
+	/**
+	 * @down_rep_recv: Message receiver state for replies to down
+	 * requests.
+	 */
+	struct drm_dp_sideband_msg_rx down_rep_recv;
+
 	/**
 	 * @lock: protects @mst_state, @mst_primary, @dpcd, and
 	 * @payload_id_table_cleared.
@@ -592,11 +585,6 @@ struct drm_dp_mst_topology_mgr {
 	 */
 	bool payload_id_table_cleared : 1;
=20
-	/**
-	 * @is_waiting_for_dwn_reply: whether we're waiting for a down reply.
-	 */
-	bool is_waiting_for_dwn_reply : 1;
-
 	/**
 	 * @mst_primary: Pointer to the primary/first branch device.
 	 */
@@ -621,13 +609,12 @@ struct drm_dp_mst_topology_mgr {
 	const struct drm_private_state_funcs *funcs;
=20
 	/**
-	 * @qlock: protects @tx_msg_downq, the &drm_dp_mst_branch.txslost and
-	 * &drm_dp_sideband_msg_tx.state once they are queued
+	 * @qlock: protects @tx_msg_downq and &drm_dp_sideband_msg_tx.state
 	 */
 	struct mutex qlock;
=20
 	/**
-	 * @tx_msg_downq: List of pending down replies.
+	 * @tx_msg_downq: List of pending down requests
 	 */
 	struct list_head tx_msg_downq;
=20
--=20
2.25.3

