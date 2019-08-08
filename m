Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8825C869BC
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405289AbfHHTKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:10:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:44748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405286AbfHHTKZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:10:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A39382173E;
        Thu,  8 Aug 2019 19:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291424;
        bh=Vv85fbJA8H/u6uTJ/X/9QADwTmMr+LeoEhTty7D4Fhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nX/pyqkpdGj7akOzzKZOeFRm+L2LKBoKHSAGbE/11y482vDmA90N6stLmDlB95Q/Q
         eLp/l9ZjXzst4uZLP9f+mjHo9kNj5JmQ7v0sjAFWoVH3Ly5KIihA3YcvvWQwsC3UXH
         PsbeAx5m/MzsIZzfx9iqC4QKn9AfxlV5FtLyTQ9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.14 01/33] scsi: fcoe: Embed fc_rport_priv in fcoe_rport structure
Date:   Thu,  8 Aug 2019 21:05:08 +0200
Message-Id: <20190808190453.646271154@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190453.582417307@linuxfoundation.org>
References: <20190808190453.582417307@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

commit 023358b136d490ca91735ac6490db3741af5a8bd upstream.

Gcc-9 complains for a memset across pointer boundaries, which happens as
the code tries to allocate a flexible array on the stack.  Turns out we
cannot do this without relying on gcc-isms, so with this patch we'll embed
the fc_rport_priv structure into fcoe_rport, can use the normal
'container_of' outcast, and will only have to do a memset over one
structure.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/fcoe/fcoe_ctlr.c |   51 ++++++++++++++++--------------------------
 drivers/scsi/libfc/fc_rport.c |    5 +++-
 include/scsi/libfcoe.h        |    1 
 3 files changed, 25 insertions(+), 32 deletions(-)

--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -2017,7 +2017,7 @@ EXPORT_SYMBOL_GPL(fcoe_wwn_from_mac);
  */
 static inline struct fcoe_rport *fcoe_ctlr_rport(struct fc_rport_priv *rdata)
 {
-	return (struct fcoe_rport *)(rdata + 1);
+	return container_of(rdata, struct fcoe_rport, rdata);
 }
 
 /**
@@ -2283,7 +2283,7 @@ static void fcoe_ctlr_vn_start(struct fc
  */
 static int fcoe_ctlr_vn_parse(struct fcoe_ctlr *fip,
 			      struct sk_buff *skb,
-			      struct fc_rport_priv *rdata)
+			      struct fcoe_rport *frport)
 {
 	struct fip_header *fiph;
 	struct fip_desc *desc = NULL;
@@ -2291,16 +2291,12 @@ static int fcoe_ctlr_vn_parse(struct fco
 	struct fip_wwn_desc *wwn = NULL;
 	struct fip_vn_desc *vn = NULL;
 	struct fip_size_desc *size = NULL;
-	struct fcoe_rport *frport;
 	size_t rlen;
 	size_t dlen;
 	u32 desc_mask = 0;
 	u32 dtype;
 	u8 sub;
 
-	memset(rdata, 0, sizeof(*rdata) + sizeof(*frport));
-	frport = fcoe_ctlr_rport(rdata);
-
 	fiph = (struct fip_header *)skb->data;
 	frport->flags = ntohs(fiph->fip_flags);
 
@@ -2363,15 +2359,17 @@ static int fcoe_ctlr_vn_parse(struct fco
 			if (dlen != sizeof(struct fip_wwn_desc))
 				goto len_err;
 			wwn = (struct fip_wwn_desc *)desc;
-			rdata->ids.node_name = get_unaligned_be64(&wwn->fd_wwn);
+			frport->rdata.ids.node_name =
+				get_unaligned_be64(&wwn->fd_wwn);
 			break;
 		case FIP_DT_VN_ID:
 			if (dlen != sizeof(struct fip_vn_desc))
 				goto len_err;
 			vn = (struct fip_vn_desc *)desc;
 			memcpy(frport->vn_mac, vn->fd_mac, ETH_ALEN);
-			rdata->ids.port_id = ntoh24(vn->fd_fc_id);
-			rdata->ids.port_name = get_unaligned_be64(&vn->fd_wwpn);
+			frport->rdata.ids.port_id = ntoh24(vn->fd_fc_id);
+			frport->rdata.ids.port_name =
+				get_unaligned_be64(&vn->fd_wwpn);
 			break;
 		case FIP_DT_FC4F:
 			if (dlen != sizeof(struct fip_fc4_feat))
@@ -2752,10 +2750,7 @@ static int fcoe_ctlr_vn_recv(struct fcoe
 {
 	struct fip_header *fiph;
 	enum fip_vn2vn_subcode sub;
-	struct {
-		struct fc_rport_priv rdata;
-		struct fcoe_rport frport;
-	} buf;
+	struct fcoe_rport frport = { };
 	int rc, vlan_id = 0;
 
 	fiph = (struct fip_header *)skb->data;
@@ -2771,7 +2766,7 @@ static int fcoe_ctlr_vn_recv(struct fcoe
 		goto drop;
 	}
 
-	rc = fcoe_ctlr_vn_parse(fip, skb, &buf.rdata);
+	rc = fcoe_ctlr_vn_parse(fip, skb, &frport);
 	if (rc) {
 		LIBFCOE_FIP_DBG(fip, "vn_recv vn_parse error %d\n", rc);
 		goto drop;
@@ -2780,19 +2775,19 @@ static int fcoe_ctlr_vn_recv(struct fcoe
 	mutex_lock(&fip->ctlr_mutex);
 	switch (sub) {
 	case FIP_SC_VN_PROBE_REQ:
-		fcoe_ctlr_vn_probe_req(fip, &buf.rdata);
+		fcoe_ctlr_vn_probe_req(fip, &frport.rdata);
 		break;
 	case FIP_SC_VN_PROBE_REP:
-		fcoe_ctlr_vn_probe_reply(fip, &buf.rdata);
+		fcoe_ctlr_vn_probe_reply(fip, &frport.rdata);
 		break;
 	case FIP_SC_VN_CLAIM_NOTIFY:
-		fcoe_ctlr_vn_claim_notify(fip, &buf.rdata);
+		fcoe_ctlr_vn_claim_notify(fip, &frport.rdata);
 		break;
 	case FIP_SC_VN_CLAIM_REP:
-		fcoe_ctlr_vn_claim_resp(fip, &buf.rdata);
+		fcoe_ctlr_vn_claim_resp(fip, &frport.rdata);
 		break;
 	case FIP_SC_VN_BEACON:
-		fcoe_ctlr_vn_beacon(fip, &buf.rdata);
+		fcoe_ctlr_vn_beacon(fip, &frport.rdata);
 		break;
 	default:
 		LIBFCOE_FIP_DBG(fip, "vn_recv unknown subcode %d\n", sub);
@@ -2816,22 +2811,18 @@ drop:
  */
 static int fcoe_ctlr_vlan_parse(struct fcoe_ctlr *fip,
 			      struct sk_buff *skb,
-			      struct fc_rport_priv *rdata)
+			      struct fcoe_rport *frport)
 {
 	struct fip_header *fiph;
 	struct fip_desc *desc = NULL;
 	struct fip_mac_desc *macd = NULL;
 	struct fip_wwn_desc *wwn = NULL;
-	struct fcoe_rport *frport;
 	size_t rlen;
 	size_t dlen;
 	u32 desc_mask = 0;
 	u32 dtype;
 	u8 sub;
 
-	memset(rdata, 0, sizeof(*rdata) + sizeof(*frport));
-	frport = fcoe_ctlr_rport(rdata);
-
 	fiph = (struct fip_header *)skb->data;
 	frport->flags = ntohs(fiph->fip_flags);
 
@@ -2885,7 +2876,8 @@ static int fcoe_ctlr_vlan_parse(struct f
 			if (dlen != sizeof(struct fip_wwn_desc))
 				goto len_err;
 			wwn = (struct fip_wwn_desc *)desc;
-			rdata->ids.node_name = get_unaligned_be64(&wwn->fd_wwn);
+			frport->rdata.ids.node_name =
+				get_unaligned_be64(&wwn->fd_wwn);
 			break;
 		default:
 			LIBFCOE_FIP_DBG(fip, "unexpected descriptor type %x "
@@ -2996,22 +2988,19 @@ static int fcoe_ctlr_vlan_recv(struct fc
 {
 	struct fip_header *fiph;
 	enum fip_vlan_subcode sub;
-	struct {
-		struct fc_rport_priv rdata;
-		struct fcoe_rport frport;
-	} buf;
+	struct fcoe_rport frport = { };
 	int rc;
 
 	fiph = (struct fip_header *)skb->data;
 	sub = fiph->fip_subcode;
-	rc = fcoe_ctlr_vlan_parse(fip, skb, &buf.rdata);
+	rc = fcoe_ctlr_vlan_parse(fip, skb, &frport);
 	if (rc) {
 		LIBFCOE_FIP_DBG(fip, "vlan_recv vlan_parse error %d\n", rc);
 		goto drop;
 	}
 	mutex_lock(&fip->ctlr_mutex);
 	if (sub == FIP_SC_VL_REQ)
-		fcoe_ctlr_vlan_disc_reply(fip, &buf.rdata);
+		fcoe_ctlr_vlan_disc_reply(fip, &frport.rdata);
 	mutex_unlock(&fip->ctlr_mutex);
 
 drop:
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -142,12 +142,15 @@ EXPORT_SYMBOL(fc_rport_lookup);
 struct fc_rport_priv *fc_rport_create(struct fc_lport *lport, u32 port_id)
 {
 	struct fc_rport_priv *rdata;
+	size_t rport_priv_size = sizeof(*rdata);
 
 	rdata = fc_rport_lookup(lport, port_id);
 	if (rdata)
 		return rdata;
 
-	rdata = kzalloc(sizeof(*rdata) + lport->rport_priv_size, GFP_KERNEL);
+	if (lport->rport_priv_size > 0)
+		rport_priv_size = lport->rport_priv_size;
+	rdata = kzalloc(rport_priv_size, GFP_KERNEL);
 	if (!rdata)
 		return NULL;
 
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -241,6 +241,7 @@ struct fcoe_fcf {
  * @vn_mac:	VN_Node assigned MAC address for data
  */
 struct fcoe_rport {
+	struct fc_rport_priv rdata;
 	unsigned long time;
 	u16 fcoe_len;
 	u16 flags;


