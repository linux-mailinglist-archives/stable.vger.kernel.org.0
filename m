Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70C932ABB72
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731732AbgKINNw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:13:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:39978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733033AbgKINNv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:13:51 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AC022076E;
        Mon,  9 Nov 2020 13:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927630;
        bh=IXYWi8RdgKIyTCtQm0YBY4aWVoi2cblTRqZHxzm2Psw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ejhoScko21v3dLArisLufxKIC91NsVGLIYM4CzuDx6aJ1szCVu2XGf38HgEEGOmV5
         OUDNCiW7/tgBsvC+uoN/YrmMEYz620RERYSDFrnH5jOJWl5Aa/HNLq17ZawiHoEaHC
         O396bteDHKauAYOZGenyf/846LJ815kWMn/5Uol0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyrel Datwyler <tyreld@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 53/85] scsi: ibmvscsi: Fix potential race after loss of transport
Date:   Mon,  9 Nov 2020 13:55:50 +0100
Message-Id: <20201109125025.126066589@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125022.614792961@linuxfoundation.org>
References: <20201109125022.614792961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tyrel Datwyler <tyreld@linux.ibm.com>

[ Upstream commit 665e0224a3d76f36da40bd9012270fa629aa42ed ]

After a loss of transport due to an adapter migration or crash/disconnect
from the host partner there is a tiny window where we can race adjusting
the request_limit of the adapter. The request limit is atomically
increased/decreased to track the number of inflight requests against the
allowed limit of our VIOS partner.

After a transport loss we set the request_limit to zero to reflect this
state.  However, there is a window where the adapter may attempt to queue a
command because the transport loss event hasn't been fully processed yet
and request_limit is still greater than zero.  The hypercall to send the
event will fail and the error path will increment the request_limit as a
result.  If the adapter processes the transport event prior to this
increment the request_limit becomes out of sync with the adapter state and
can result in SCSI commands being submitted on the now reset connection
prior to an SRP Login resulting in a protocol violation.

Fix this race by protecting request_limit with the host lock when changing
the value via atomic_set() to indicate no transport.

Link: https://lore.kernel.org/r/20201025001355.4527-1-tyreld@linux.ibm.com
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c | 36 +++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index c5711c659b517..1ab0a61e3fb59 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -806,6 +806,22 @@ static void purge_requests(struct ibmvscsi_host_data *hostdata, int error_code)
 	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
 }
 
+/**
+ * ibmvscsi_set_request_limit - Set the adapter request_limit in response to
+ * an adapter failure, reset, or SRP Login. Done under host lock to prevent
+ * race with SCSI command submission.
+ * @hostdata:	adapter to adjust
+ * @limit:	new request limit
+ */
+static void ibmvscsi_set_request_limit(struct ibmvscsi_host_data *hostdata, int limit)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(hostdata->host->host_lock, flags);
+	atomic_set(&hostdata->request_limit, limit);
+	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+}
+
 /**
  * ibmvscsi_reset_host - Reset the connection to the server
  * @hostdata:	struct ibmvscsi_host_data to reset
@@ -813,7 +829,7 @@ static void purge_requests(struct ibmvscsi_host_data *hostdata, int error_code)
 static void ibmvscsi_reset_host(struct ibmvscsi_host_data *hostdata)
 {
 	scsi_block_requests(hostdata->host);
-	atomic_set(&hostdata->request_limit, 0);
+	ibmvscsi_set_request_limit(hostdata, 0);
 
 	purge_requests(hostdata, DID_ERROR);
 	hostdata->action = IBMVSCSI_HOST_ACTION_RESET;
@@ -1146,13 +1162,13 @@ static void login_rsp(struct srp_event_struct *evt_struct)
 		dev_info(hostdata->dev, "SRP_LOGIN_REJ reason %u\n",
 			 evt_struct->xfer_iu->srp.login_rej.reason);
 		/* Login failed.  */
-		atomic_set(&hostdata->request_limit, -1);
+		ibmvscsi_set_request_limit(hostdata, -1);
 		return;
 	default:
 		dev_err(hostdata->dev, "Invalid login response typecode 0x%02x!\n",
 			evt_struct->xfer_iu->srp.login_rsp.opcode);
 		/* Login failed.  */
-		atomic_set(&hostdata->request_limit, -1);
+		ibmvscsi_set_request_limit(hostdata, -1);
 		return;
 	}
 
@@ -1163,7 +1179,7 @@ static void login_rsp(struct srp_event_struct *evt_struct)
 	 * This value is set rather than added to request_limit because
 	 * request_limit could have been set to -1 by this client.
 	 */
-	atomic_set(&hostdata->request_limit,
+	ibmvscsi_set_request_limit(hostdata,
 		   be32_to_cpu(evt_struct->xfer_iu->srp.login_rsp.req_lim_delta));
 
 	/* If we had any pending I/Os, kick them */
@@ -1195,13 +1211,13 @@ static int send_srp_login(struct ibmvscsi_host_data *hostdata)
 	login->req_buf_fmt = cpu_to_be16(SRP_BUF_FORMAT_DIRECT |
 					 SRP_BUF_FORMAT_INDIRECT);
 
-	spin_lock_irqsave(hostdata->host->host_lock, flags);
 	/* Start out with a request limit of 0, since this is negotiated in
 	 * the login request we are just sending and login requests always
 	 * get sent by the driver regardless of request_limit.
 	 */
-	atomic_set(&hostdata->request_limit, 0);
+	ibmvscsi_set_request_limit(hostdata, 0);
 
+	spin_lock_irqsave(hostdata->host->host_lock, flags);
 	rc = ibmvscsi_send_srp_event(evt_struct, hostdata, login_timeout * 2);
 	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
 	dev_info(hostdata->dev, "sent SRP login\n");
@@ -1781,7 +1797,7 @@ static void ibmvscsi_handle_crq(struct viosrp_crq *crq,
 		return;
 	case VIOSRP_CRQ_XPORT_EVENT:	/* Hypervisor telling us the connection is closed */
 		scsi_block_requests(hostdata->host);
-		atomic_set(&hostdata->request_limit, 0);
+		ibmvscsi_set_request_limit(hostdata, 0);
 		if (crq->format == 0x06) {
 			/* We need to re-setup the interpartition connection */
 			dev_info(hostdata->dev, "Re-enabling adapter!\n");
@@ -2137,12 +2153,12 @@ static void ibmvscsi_do_work(struct ibmvscsi_host_data *hostdata)
 	}
 
 	hostdata->action = IBMVSCSI_HOST_ACTION_NONE;
+	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
 
 	if (rc) {
-		atomic_set(&hostdata->request_limit, -1);
+		ibmvscsi_set_request_limit(hostdata, -1);
 		dev_err(hostdata->dev, "error after %s\n", action);
 	}
-	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
 
 	scsi_unblock_requests(hostdata->host);
 }
@@ -2226,7 +2242,7 @@ static int ibmvscsi_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	init_waitqueue_head(&hostdata->work_wait_q);
 	hostdata->host = host;
 	hostdata->dev = dev;
-	atomic_set(&hostdata->request_limit, -1);
+	ibmvscsi_set_request_limit(hostdata, -1);
 	hostdata->host->max_sectors = IBMVSCSI_MAX_SECTORS_DEFAULT;
 
 	if (map_persist_bufs(hostdata)) {
-- 
2.27.0



