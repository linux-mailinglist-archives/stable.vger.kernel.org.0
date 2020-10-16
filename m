Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D06FB290167
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 11:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395010AbgJPJOL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 05:14:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:40746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405798AbgJPJLO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 05:11:14 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4442E21527;
        Fri, 16 Oct 2020 09:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602839471;
        bh=iJDPr1SCZ19wIMLz4nGPwoBz1Tz+1pyLUTra09Ar6qM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sJUGuoXTH0qo30O/RjCsV3CsCm+GUXoyjSVU3vvpzEDCrggR45b98Y2GC6d3Klbtp
         5fY64FJ4A3HI+g+ovqHZqVSXItQQM9wyTQSYgPBC1AuxyAXft0duBd6bhtomFeDjKR
         pw+atpmt6mpcPZrNfkDBNy2xpqsHl5yS2ZhLciG8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 5.8 03/14] Bluetooth: A2MP: Fix not initializing all members
Date:   Fri, 16 Oct 2020 11:07:48 +0200
Message-Id: <20201016090437.331232767@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016090437.153175229@linuxfoundation.org>
References: <20201016090437.153175229@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit eddb7732119d53400f48a02536a84c509692faa8 upstream.

This fixes various places where a stack variable is used uninitialized.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/a2mp.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

--- a/net/bluetooth/a2mp.c
+++ b/net/bluetooth/a2mp.c
@@ -226,6 +226,9 @@ static int a2mp_discover_rsp(struct amp_
 			struct a2mp_info_req req;
 
 			found = true;
+
+			memset(&req, 0, sizeof(req));
+
 			req.id = cl->id;
 			a2mp_send(mgr, A2MP_GETINFO_REQ, __next_ident(mgr),
 				  sizeof(req), &req);
@@ -305,6 +308,8 @@ static int a2mp_getinfo_req(struct amp_m
 	if (!hdev || hdev->dev_type != HCI_AMP) {
 		struct a2mp_info_rsp rsp;
 
+		memset(&rsp, 0, sizeof(rsp));
+
 		rsp.id = req->id;
 		rsp.status = A2MP_STATUS_INVALID_CTRL_ID;
 
@@ -348,6 +353,8 @@ static int a2mp_getinfo_rsp(struct amp_m
 	if (!ctrl)
 		return -ENOMEM;
 
+	memset(&req, 0, sizeof(req));
+
 	req.id = rsp->id;
 	a2mp_send(mgr, A2MP_GETAMPASSOC_REQ, __next_ident(mgr), sizeof(req),
 		  &req);
@@ -376,6 +383,8 @@ static int a2mp_getampassoc_req(struct a
 		struct a2mp_amp_assoc_rsp rsp;
 		rsp.id = req->id;
 
+		memset(&rsp, 0, sizeof(rsp));
+
 		if (tmp) {
 			rsp.status = A2MP_STATUS_COLLISION_OCCURED;
 			amp_mgr_put(tmp);
@@ -464,7 +473,6 @@ static int a2mp_createphyslink_req(struc
 				   struct a2mp_cmd *hdr)
 {
 	struct a2mp_physlink_req *req = (void *) skb->data;
-
 	struct a2mp_physlink_rsp rsp;
 	struct hci_dev *hdev;
 	struct hci_conn *hcon;
@@ -475,6 +483,8 @@ static int a2mp_createphyslink_req(struc
 
 	BT_DBG("local_id %d, remote_id %d", req->local_id, req->remote_id);
 
+	memset(&rsp, 0, sizeof(rsp));
+
 	rsp.local_id = req->remote_id;
 	rsp.remote_id = req->local_id;
 
@@ -553,6 +563,8 @@ static int a2mp_discphyslink_req(struct
 
 	BT_DBG("local_id %d remote_id %d", req->local_id, req->remote_id);
 
+	memset(&rsp, 0, sizeof(rsp));
+
 	rsp.local_id = req->remote_id;
 	rsp.remote_id = req->local_id;
 	rsp.status = A2MP_STATUS_SUCCESS;
@@ -675,6 +687,8 @@ static int a2mp_chan_recv_cb(struct l2ca
 	if (err) {
 		struct a2mp_cmd_rej rej;
 
+		memset(&rej, 0, sizeof(rej));
+
 		rej.reason = cpu_to_le16(0);
 		hdr = (void *) skb->data;
 
@@ -898,6 +912,8 @@ void a2mp_send_getinfo_rsp(struct hci_de
 
 	BT_DBG("%s mgr %p", hdev->name, mgr);
 
+	memset(&rsp, 0, sizeof(rsp));
+
 	rsp.id = hdev->id;
 	rsp.status = A2MP_STATUS_INVALID_CTRL_ID;
 
@@ -995,6 +1011,8 @@ void a2mp_send_create_phy_link_rsp(struc
 	if (!mgr)
 		return;
 
+	memset(&rsp, 0, sizeof(rsp));
+
 	hs_hcon = hci_conn_hash_lookup_state(hdev, AMP_LINK, BT_CONNECT);
 	if (!hs_hcon) {
 		rsp.status = A2MP_STATUS_UNABLE_START_LINK_CREATION;
@@ -1027,6 +1045,8 @@ void a2mp_discover_amp(struct l2cap_chan
 
 	mgr->bredr_chan = chan;
 
+	memset(&req, 0, sizeof(req));
+
 	req.mtu = cpu_to_le16(L2CAP_A2MP_DEFAULT_MTU);
 	req.ext_feat = 0;
 	a2mp_send(mgr, A2MP_DISCOVER_REQ, 1, sizeof(req), &req);


