Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B154999DE0
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393050AbfHVRqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:46:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391676AbfHVRW5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:22:57 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CDDA2341A;
        Thu, 22 Aug 2019 17:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494576;
        bh=nu3Cf9luCnSo7c0WYrSHpGfz7d81vlFh2rBuHMHkdPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LH57xKSjQENaw1hZ3caTCS8sI39Ho00rMrkoKkzhhmKYtKd/7bZTuPpe9CTyfrfzH
         +TH++mMjwMlB0iNHJR1lR6tHi6wMpoZZc8GpQf0JUchfXP1SzDdc2eJWpArTAxjSh1
         /xY4U7umV4D273H2EXTu2mT7FKbqhGhNAMCUfWbk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.4 68/78] scsi: fcoe: Embed fc_rport_priv in fcoe_rport structure
Date:   Thu, 22 Aug 2019 10:19:12 -0700
Message-Id: <20190822171833.998724002@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171832.012773482@linuxfoundation.org>
References: <20190822171832.012773482@linuxfoundation.org>
User-Agent: quilt/0.66
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
 drivers/scsi/fcoe/fcoe_ctlr.c |   33 ++++++++++++++-------------------
 drivers/scsi/libfc/fc_rport.c |    5 ++++-
 include/scsi/libfcoe.h        |    1 +
 3 files changed, 19 insertions(+), 20 deletions(-)

--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -1973,7 +1973,7 @@ EXPORT_SYMBOL_GPL(fcoe_wwn_from_mac);
  */
 static inline struct fcoe_rport *fcoe_ctlr_rport(struct fc_rport_priv *rdata)
 {
-	return (struct fcoe_rport *)(rdata + 1);
+	return container_of(rdata, struct fcoe_rport, rdata);
 }
 
 /**
@@ -2233,7 +2233,7 @@ static void fcoe_ctlr_vn_start(struct fc
  */
 static int fcoe_ctlr_vn_parse(struct fcoe_ctlr *fip,
 			      struct sk_buff *skb,
-			      struct fc_rport_priv *rdata)
+			      struct fcoe_rport *frport)
 {
 	struct fip_header *fiph;
 	struct fip_desc *desc = NULL;
@@ -2241,16 +2241,12 @@ static int fcoe_ctlr_vn_parse(struct fco
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
 
@@ -2313,15 +2309,17 @@ static int fcoe_ctlr_vn_parse(struct fco
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
@@ -2664,16 +2662,13 @@ static int fcoe_ctlr_vn_recv(struct fcoe
 {
 	struct fip_header *fiph;
 	enum fip_vn2vn_subcode sub;
-	struct {
-		struct fc_rport_priv rdata;
-		struct fcoe_rport frport;
-	} buf;
+	struct fcoe_rport frport = { };
 	int rc;
 
 	fiph = (struct fip_header *)skb->data;
 	sub = fiph->fip_subcode;
 
-	rc = fcoe_ctlr_vn_parse(fip, skb, &buf.rdata);
+	rc = fcoe_ctlr_vn_parse(fip, skb, &frport);
 	if (rc) {
 		LIBFCOE_FIP_DBG(fip, "vn_recv vn_parse error %d\n", rc);
 		goto drop;
@@ -2682,19 +2677,19 @@ static int fcoe_ctlr_vn_recv(struct fcoe
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
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -121,12 +121,15 @@ static struct fc_rport_priv *fc_rport_cr
 					     u32 port_id)
 {
 	struct fc_rport_priv *rdata;
+	size_t rport_priv_size = sizeof(*rdata);
 
 	rdata = lport->tt.rport_lookup(lport, port_id);
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
@@ -236,6 +236,7 @@ struct fcoe_fcf {
  * @vn_mac:	VN_Node assigned MAC address for data
  */
 struct fcoe_rport {
+	struct fc_rport_priv rdata;
 	unsigned long time;
 	u16 fcoe_len;
 	u16 flags;


