Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63CEDA6F2E
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730262AbfICQaX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:30:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:51342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731196AbfICQ2y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:28:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF2C5238CD;
        Tue,  3 Sep 2019 16:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528133;
        bh=GOQcnBgM/52LCuH+agl4jDfZHlMROPIp99AfKXZDnWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HsNmK9VJBuGjtbq3quXykdTdhuS8x0UMTHl6o+D9L3reSv2r2jXK4tYiSFkZ8RK9X
         RDcIXtFjVRy4WR7PGZhrRe2pOM6r3tiGnaV2cLwr6beLsTR8R//01wJvgibXx9V9Ej
         t9jV89yma5MNB0qSmSNiWsXx+y0qrylVuRTLb/oo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Jens Remus <jremus@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 128/167] scsi: zfcp: fix request object use-after-free in send path causing wrong traces
Date:   Tue,  3 Sep 2019 12:24:40 -0400
Message-Id: <20190903162519.7136-128-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Block <bblock@linux.ibm.com>

[ Upstream commit 106d45f350c7cac876844dc685845cba4ffdb70b ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/scsi/zfcp_fsf.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 3c86e27f094de..aff073a5b52bf 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -1594,6 +1594,7 @@ int zfcp_fsf_open_wka_port(struct zfcp_fc_wka_port *wka_port)
 {
 	struct zfcp_qdio *qdio = wka_port->adapter->qdio;
 	struct zfcp_fsf_req *req;
+	unsigned long req_id = 0;
 	int retval = -EIO;
 
 	spin_lock_irq(&qdio->req_q_lock);
@@ -1616,6 +1617,8 @@ int zfcp_fsf_open_wka_port(struct zfcp_fc_wka_port *wka_port)
 	hton24(req->qtcb->bottom.support.d_id, wka_port->d_id);
 	req->data = wka_port;
 
+	req_id = req->req_id;
+
 	zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
 	retval = zfcp_fsf_req_send(req);
 	if (retval)
@@ -1623,7 +1626,7 @@ int zfcp_fsf_open_wka_port(struct zfcp_fc_wka_port *wka_port)
 out:
 	spin_unlock_irq(&qdio->req_q_lock);
 	if (!retval)
-		zfcp_dbf_rec_run_wka("fsowp_1", wka_port, req->req_id);
+		zfcp_dbf_rec_run_wka("fsowp_1", wka_port, req_id);
 	return retval;
 }
 
@@ -1649,6 +1652,7 @@ int zfcp_fsf_close_wka_port(struct zfcp_fc_wka_port *wka_port)
 {
 	struct zfcp_qdio *qdio = wka_port->adapter->qdio;
 	struct zfcp_fsf_req *req;
+	unsigned long req_id = 0;
 	int retval = -EIO;
 
 	spin_lock_irq(&qdio->req_q_lock);
@@ -1671,6 +1675,8 @@ int zfcp_fsf_close_wka_port(struct zfcp_fc_wka_port *wka_port)
 	req->data = wka_port;
 	req->qtcb->header.port_handle = wka_port->handle;
 
+	req_id = req->req_id;
+
 	zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
 	retval = zfcp_fsf_req_send(req);
 	if (retval)
@@ -1678,7 +1684,7 @@ int zfcp_fsf_close_wka_port(struct zfcp_fc_wka_port *wka_port)
 out:
 	spin_unlock_irq(&qdio->req_q_lock);
 	if (!retval)
-		zfcp_dbf_rec_run_wka("fscwp_1", wka_port, req->req_id);
+		zfcp_dbf_rec_run_wka("fscwp_1", wka_port, req_id);
 	return retval;
 }
 
-- 
2.20.1

