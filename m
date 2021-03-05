Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C04C732EB82
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233712AbhCEMoc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:44:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:33122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233969AbhCEMoG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:44:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDFD164F23;
        Fri,  5 Mar 2021 12:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614948245;
        bh=2hTNgaeHn5JDMH40tkQkdEx4efY2GLA6g5MALG/NiEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=biRwLD5VsI2ZekZKm9EcRahqSSpxfjJ4ChOxCX8mL5aGAt+XKngbWYk72wZy470LA
         y9YBlK35GbIiDLHhcyTmQwoxeLk1Prgtm/XTjM81zWb21FJHjS0KDlFptGbuKl7dPp
         OQwPsSKDLWxZq2FXfbmnJsnhPd37fpHwbkfdCOSA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Nichols <adam@grimm-co.com>,
        Lee Duncan <lduncan@suse.com>,
        Mike Christie <michael.christie@oracle.com>,
        Chris Leech <cleech@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.4 25/30] scsi: iscsi: Verify lengths on passthrough PDUs
Date:   Fri,  5 Mar 2021 13:22:54 +0100
Message-Id: <20210305120850.658433097@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120849.381261651@linuxfoundation.org>
References: <20210305120849.381261651@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Leech <cleech@redhat.com>

commit f9dbdf97a5bd92b1a49cee3d591b55b11fd7a6d5 upstream.

Open-iSCSI sends passthrough PDUs over netlink, but the kernel should be
verifying that the provided PDU header and data lengths fall within the
netlink message to prevent accessing beyond that in memory.

Cc: stable@vger.kernel.org
Reported-by: Adam Nichols <adam@grimm-co.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_transport_iscsi.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -3526,6 +3526,7 @@ static int
 iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 {
 	int err = 0;
+	u32 pdu_len;
 	struct iscsi_uevent *ev = nlmsg_data(nlh);
 	struct iscsi_transport *transport = NULL;
 	struct iscsi_internal *priv;
@@ -3641,6 +3642,14 @@ iscsi_if_recv_msg(struct sk_buff *skb, s
 			err = -EINVAL;
 		break;
 	case ISCSI_UEVENT_SEND_PDU:
+		pdu_len = nlh->nlmsg_len - sizeof(*nlh) - sizeof(*ev);
+
+		if ((ev->u.send_pdu.hdr_size > pdu_len) ||
+		    (ev->u.send_pdu.data_size > (pdu_len - ev->u.send_pdu.hdr_size))) {
+			err = -EINVAL;
+			break;
+		}
+
 		conn = iscsi_conn_lookup(ev->u.send_pdu.sid, ev->u.send_pdu.cid);
 		if (conn)
 			ev->r.retcode =	transport->send_pdu(conn,


