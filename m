Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2D9F2901A6
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 11:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406361AbgJPJQ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 05:16:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:36884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405027AbgJPJIY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 05:08:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60ABC21556;
        Fri, 16 Oct 2020 09:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602839302;
        bh=16/TAZ8EDeUaBagtevxZ1bw/cNO+Dxs9T4s6oryzSFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sgeTjRjHjUT95h6KZydA6eggEV5ArudDwcyQpF4WwCtuSwims+hYl1cKdxs2hHPfX
         QHviJDAdZVg8m3oJm9iVr9G74za+m7KSUnXv50z9LV/66KJiHf0TXnjWYo37q4+6sW
         UK+WyDHgOnDJJ3dHR1M+aj+7XuuStLsVObfX19CA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 4.14 02/18] Bluetooth: A2MP: Fix not initializing all members
Date:   Fri, 16 Oct 2020 11:07:12 +0200
Message-Id: <20201016090437.390458348@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016090437.265805669@linuxfoundation.org>
References: <20201016090437.265805669@linuxfoundation.org>
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
@@ -233,6 +233,9 @@ static int a2mp_discover_rsp(struct amp_
 			struct a2mp_info_req req;
 
 			found = true;
+
+			memset(&req, 0, sizeof(req));
+
 			req.id = cl->id;
 			a2mp_send(mgr, A2MP_GETINFO_REQ, __next_ident(mgr),
 				  sizeof(req), &req);
@@ -312,6 +315,8 @@ static int a2mp_getinfo_req(struct amp_m
 	if (!hdev || hdev->dev_type != HCI_AMP) {
 		struct a2mp_info_rsp rsp;
 
+		memset(&rsp, 0, sizeof(rsp));
+
 		rsp.id = req->id;
 		rsp.status = A2MP_STATUS_INVALID_CTRL_ID;
 
@@ -355,6 +360,8 @@ static int a2mp_getinfo_rsp(struct amp_m
 	if (!ctrl)
 		return -ENOMEM;
 
+	memset(&req, 0, sizeof(req));
+
 	req.id = rsp->id;
 	a2mp_send(mgr, A2MP_GETAMPASSOC_REQ, __next_ident(mgr), sizeof(req),
 		  &req);
@@ -383,6 +390,8 @@ static int a2mp_getampassoc_req(struct a
 		struct a2mp_amp_assoc_rsp rsp;
 		rsp.id = req->id;
 
+		memset(&rsp, 0, sizeof(rsp));
+
 		if (tmp) {
 			rsp.status = A2MP_STATUS_COLLISION_OCCURED;
 			amp_mgr_put(tmp);
@@ -471,7 +480,6 @@ static int a2mp_createphyslink_req(struc
 				   struct a2mp_cmd *hdr)
 {
 	struct a2mp_physlink_req *req = (void *) skb->data;
-
 	struct a2mp_physlink_rsp rsp;
 	struct hci_dev *hdev;
 	struct hci_conn *hcon;
@@ -482,6 +490,8 @@ static int a2mp_createphyslink_req(struc
 
 	BT_DBG("local_id %d, remote_id %d", req->local_id, req->remote_id);
 
+	memset(&rsp, 0, sizeof(rsp));
+
 	rsp.local_id = req->remote_id;
 	rsp.remote_id = req->local_id;
 
@@ -560,6 +570,8 @@ static int a2mp_discphyslink_req(struct
 
 	BT_DBG("local_id %d remote_id %d", req->local_id, req->remote_id);
 
+	memset(&rsp, 0, sizeof(rsp));
+
 	rsp.local_id = req->remote_id;
 	rsp.remote_id = req->local_id;
 	rsp.status = A2MP_STATUS_SUCCESS;
@@ -682,6 +694,8 @@ static int a2mp_chan_recv_cb(struct l2ca
 	if (err) {
 		struct a2mp_cmd_rej rej;
 
+		memset(&rej, 0, sizeof(rej));
+
 		rej.reason = cpu_to_le16(0);
 		hdr = (void *) skb->data;
 
@@ -905,6 +919,8 @@ void a2mp_send_getinfo_rsp(struct hci_de
 
 	BT_DBG("%s mgr %p", hdev->name, mgr);
 
+	memset(&rsp, 0, sizeof(rsp));
+
 	rsp.id = hdev->id;
 	rsp.status = A2MP_STATUS_INVALID_CTRL_ID;
 
@@ -1002,6 +1018,8 @@ void a2mp_send_create_phy_link_rsp(struc
 	if (!mgr)
 		return;
 
+	memset(&rsp, 0, sizeof(rsp));
+
 	hs_hcon = hci_conn_hash_lookup_state(hdev, AMP_LINK, BT_CONNECT);
 	if (!hs_hcon) {
 		rsp.status = A2MP_STATUS_UNABLE_START_LINK_CREATION;
@@ -1034,6 +1052,8 @@ void a2mp_discover_amp(struct l2cap_chan
 
 	mgr->bredr_chan = chan;
 
+	memset(&req, 0, sizeof(req));
+
 	req.mtu = cpu_to_le16(L2CAP_A2MP_DEFAULT_MTU);
 	req.ext_feat = 0;
 	a2mp_send(mgr, A2MP_DISCOVER_REQ, 1, sizeof(req), &req);


