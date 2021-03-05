Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81FA132EACC
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbhCEMkX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:40:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:55068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232235AbhCEMkD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:40:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 718AA64EE8;
        Fri,  5 Mar 2021 12:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614948003;
        bh=ht9JQwpi9WbtDutU3j51nSmm4cxM+833p+SRf+3R/v4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JPOFmMNm1jew2hKDuEujm5HOnxR/C7RMJXqqCAkQN1ItTtUEUKDL/87detx41bX4l
         JAy8vX5Z6/syY8m0l1ToqsNnhbG+Vnkz4kJqa4QK5ltV32Nz8LDhEcwFnDW2GbxYS2
         DRK71av3mvAR4WC2VgNkosxJb9/MnA6HY6+bHgOc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Nichols <adam@grimm-co.com>,
        Lee Duncan <lduncan@suse.com>,
        Mike Christie <michael.christie@oracle.com>,
        Chris Leech <cleech@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.14 34/39] scsi: iscsi: Verify lengths on passthrough PDUs
Date:   Fri,  5 Mar 2021 13:22:33 +0100
Message-Id: <20210305120853.492572090@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120851.751937389@linuxfoundation.org>
References: <20210305120851.751937389@linuxfoundation.org>
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
@@ -3507,6 +3507,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, s
 {
 	int err = 0;
 	u32 portid;
+	u32 pdu_len;
 	struct iscsi_uevent *ev = nlmsg_data(nlh);
 	struct iscsi_transport *transport = NULL;
 	struct iscsi_internal *priv;
@@ -3624,6 +3625,14 @@ iscsi_if_recv_msg(struct sk_buff *skb, s
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


