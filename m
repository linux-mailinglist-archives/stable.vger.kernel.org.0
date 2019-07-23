Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2E97144E
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 10:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728735AbfGWIrf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 04:47:35 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:53123 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728573AbfGWIre (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 04:47:34 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id CA2A6490;
        Tue, 23 Jul 2019 04:47:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 04:47:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=xFLoif
        i53/F/fnE4sj62VA3HI9daSO+BIb0NV2Eyylk=; b=I34pbDCah0Vwl/LHT8NgCy
        bDwYSUo+poz9M1fgujP41N5fhVOXBC7CkHj0o+AUmPuY/eVlzL5QRnLgiBiIIeK8
        hRMue/kiPY8lvh6GVvefC9qier53rTBtIp7Qfrp9+AJq4emISIxrW8M97iimk1nj
        ExIwjtF9duQDLbKe0S6gYavjvHExn/+aFceQbCS3X771XCRh+NjM2aFa39zCkz5t
        pkgiTG8zRrOX3OzniHg+8ezhAAbAl8GFD0QBxEiJToQOZC31KNEAPczDRV9ShwVA
        bqm3EBIUFln8z8a7fPvm5EgZtx5gjja2Wwnl+w4jYaBk8bf01t+VhrbhXLA21l+Q
        ==
X-ME-Sender: <xms:pck2XXMhK5L7TQywCCLmU1Go3ZHCwqX7JMmo6L4yFCS3H1V79Eg72w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgddtkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:pck2XaFhbbe8dfcXTdYBvp19uMR6EdbWw_Qlm2m_mBrVwMc4RhgXlw>
    <xmx:pck2XVxFTseo2yTakE3mgFb2dkOIoHhxBW-5NJYYcN1ggxn8FFkyMg>
    <xmx:pck2Xbqu3jkbUQYqfx7Fh4Dtks0D0tqCwud7sIb_HOKkI776Q-1bSg>
    <xmx:pck2XTcpUfnbMLjsYMDuNU6JRgmlXxs_Ooik4AKYR-aPdcXSZWALTQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D28148005B;
        Tue, 23 Jul 2019 04:47:32 -0400 (EDT)
Subject: FAILED: patch "[PATCH] scsi: zfcp: fix request object use-after-free in send path" failed to apply to 4.14-stable tree
To:     bblock@linux.ibm.com, jremus@linux.ibm.com, maier@linux.ibm.com,
        martin.petersen@oracle.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 10:47:22 +0200
Message-ID: <156387164223019@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 106d45f350c7cac876844dc685845cba4ffdb70b Mon Sep 17 00:00:00 2001
From: Benjamin Block <bblock@linux.ibm.com>
Date: Tue, 2 Jul 2019 23:02:01 +0200
Subject: [PATCH] scsi: zfcp: fix request object use-after-free in send path
 causing wrong traces

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

diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index c5b2615b49ef..296bbc3c4606 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -1627,6 +1627,7 @@ int zfcp_fsf_open_wka_port(struct zfcp_fc_wka_port *wka_port)
 {
 	struct zfcp_qdio *qdio = wka_port->adapter->qdio;
 	struct zfcp_fsf_req *req;
+	unsigned long req_id = 0;
 	int retval = -EIO;
 
 	spin_lock_irq(&qdio->req_q_lock);
@@ -1649,6 +1650,8 @@ int zfcp_fsf_open_wka_port(struct zfcp_fc_wka_port *wka_port)
 	hton24(req->qtcb->bottom.support.d_id, wka_port->d_id);
 	req->data = wka_port;
 
+	req_id = req->req_id;
+
 	zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
 	retval = zfcp_fsf_req_send(req);
 	if (retval)
@@ -1657,7 +1660,7 @@ int zfcp_fsf_open_wka_port(struct zfcp_fc_wka_port *wka_port)
 out:
 	spin_unlock_irq(&qdio->req_q_lock);
 	if (!retval)
-		zfcp_dbf_rec_run_wka("fsowp_1", wka_port, req->req_id);
+		zfcp_dbf_rec_run_wka("fsowp_1", wka_port, req_id);
 	return retval;
 }
 
@@ -1683,6 +1686,7 @@ int zfcp_fsf_close_wka_port(struct zfcp_fc_wka_port *wka_port)
 {
 	struct zfcp_qdio *qdio = wka_port->adapter->qdio;
 	struct zfcp_fsf_req *req;
+	unsigned long req_id = 0;
 	int retval = -EIO;
 
 	spin_lock_irq(&qdio->req_q_lock);
@@ -1705,6 +1709,8 @@ int zfcp_fsf_close_wka_port(struct zfcp_fc_wka_port *wka_port)
 	req->data = wka_port;
 	req->qtcb->header.port_handle = wka_port->handle;
 
+	req_id = req->req_id;
+
 	zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
 	retval = zfcp_fsf_req_send(req);
 	if (retval)
@@ -1713,7 +1719,7 @@ int zfcp_fsf_close_wka_port(struct zfcp_fc_wka_port *wka_port)
 out:
 	spin_unlock_irq(&qdio->req_q_lock);
 	if (!retval)
-		zfcp_dbf_rec_run_wka("fscwp_1", wka_port, req->req_id);
+		zfcp_dbf_rec_run_wka("fscwp_1", wka_port, req_id);
 	return retval;
 }
 

