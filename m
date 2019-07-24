Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA59D73922
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389426AbfGXThP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:37:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:37296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389421AbfGXThO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:37:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1C2521873;
        Wed, 24 Jul 2019 19:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997033;
        bh=lednPcTVqVhtLN1g1Rjm601tmhqmTC7Osfas59sjvOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JOYNA6WnINU+YOQZJMhRgMF5/trwk0kOwB9SYkhHKf60QlOXpxaMdSyn8QLCcocaI
         krIavO8kW1UgCFulOR46xXRqXU6LlXg21b1yaBGl15gJ5YYZggfPflV4mNXM34itmZ
         d5pxIIujwbFRPBuTz4VXrmzsTL5RaeTp8g1hMKIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Jens Remus <jremus@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.2 259/413] scsi: zfcp: fix request object use-after-free in send path causing wrong traces
Date:   Wed, 24 Jul 2019 21:19:10 +0200
Message-Id: <20190724191754.580509769@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Block <bblock@linux.ibm.com>

commit 106d45f350c7cac876844dc685845cba4ffdb70b upstream.

When tracing instances where we open and close WKA ports, we also pass the
request-ID of the respective FSF command.

But after successfully sending the FSF command we must not use the
request-object anymore, as this might result in an use-after-free (see
"zfcp: fix request object use-after-free in send path causing seqno
errors" ).

To fix this add a new variable that caches the request-ID before sending
the request. This won't change during the hand-off to the FCP channel,
and so it's safe to trace this cached request-ID later, instead of using
the request object.

Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
Fixes: d27a7cb91960 ("zfcp: trace on request for open and close of WKA port")
Cc: <stable@vger.kernel.org> #2.6.38+
Reviewed-by: Steffen Maier <maier@linux.ibm.com>
Reviewed-by: Jens Remus <jremus@linux.ibm.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/scsi/zfcp_fsf.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -1627,6 +1627,7 @@ int zfcp_fsf_open_wka_port(struct zfcp_f
 {
 	struct zfcp_qdio *qdio = wka_port->adapter->qdio;
 	struct zfcp_fsf_req *req;
+	unsigned long req_id = 0;
 	int retval = -EIO;
 
 	spin_lock_irq(&qdio->req_q_lock);
@@ -1649,6 +1650,8 @@ int zfcp_fsf_open_wka_port(struct zfcp_f
 	hton24(req->qtcb->bottom.support.d_id, wka_port->d_id);
 	req->data = wka_port;
 
+	req_id = req->req_id;
+
 	zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
 	retval = zfcp_fsf_req_send(req);
 	if (retval)
@@ -1657,7 +1660,7 @@ int zfcp_fsf_open_wka_port(struct zfcp_f
 out:
 	spin_unlock_irq(&qdio->req_q_lock);
 	if (!retval)
-		zfcp_dbf_rec_run_wka("fsowp_1", wka_port, req->req_id);
+		zfcp_dbf_rec_run_wka("fsowp_1", wka_port, req_id);
 	return retval;
 }
 
@@ -1683,6 +1686,7 @@ int zfcp_fsf_close_wka_port(struct zfcp_
 {
 	struct zfcp_qdio *qdio = wka_port->adapter->qdio;
 	struct zfcp_fsf_req *req;
+	unsigned long req_id = 0;
 	int retval = -EIO;
 
 	spin_lock_irq(&qdio->req_q_lock);
@@ -1705,6 +1709,8 @@ int zfcp_fsf_close_wka_port(struct zfcp_
 	req->data = wka_port;
 	req->qtcb->header.port_handle = wka_port->handle;
 
+	req_id = req->req_id;
+
 	zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
 	retval = zfcp_fsf_req_send(req);
 	if (retval)
@@ -1713,7 +1719,7 @@ int zfcp_fsf_close_wka_port(struct zfcp_
 out:
 	spin_unlock_irq(&qdio->req_q_lock);
 	if (!retval)
-		zfcp_dbf_rec_run_wka("fscwp_1", wka_port, req->req_id);
+		zfcp_dbf_rec_run_wka("fscwp_1", wka_port, req_id);
 	return retval;
 }
 


