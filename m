Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBA81013FC
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728950AbfKSF3N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:29:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:47684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728944AbfKSF3M (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:29:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D74D521823;
        Tue, 19 Nov 2019 05:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141351;
        bh=C6IkK7Gqz3rOVkZpbjQqtq8pgpHfEsSqDX4SCQ5deCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P1TH1gYD31upJXwQfyo1X95bTHCrlwonH1Ti+GtsDmusFL55I+fhNR+cYJiF9i6t+
         Zcz2MZj2ROuVVORlXjks3ERXaNF3UtElGrQcuQnYWbsAHkQBeVXzV4o5mwzOISbMph
         wluVMsrf8+M56y7n+jvX4SFUXqjg+dsmEbsHVcaQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 130/422] RDMA/core: Rate limit MAD error messages
Date:   Tue, 19 Nov 2019 06:15:27 +0100
Message-Id: <20191119051407.332119901@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

[ Upstream commit f9d08f1e1939ad4d92e38bd3dee6842512f5bee6 ]

While registering a mad agent, a user space can trigger various errors
and flood the logs.

Therefore, decrease verbosity and rate limit such error messages.
While we are at it, use __func__ to print function name.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/mad.c | 72 ++++++++++++++++++-----------------
 1 file changed, 37 insertions(+), 35 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 74aa3e651bc3c..218411282069b 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -223,30 +223,30 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 	/* Validate parameters */
 	qpn = get_spl_qp_index(qp_type);
 	if (qpn == -1) {
-		dev_notice(&device->dev,
-			   "ib_register_mad_agent: invalid QP Type %d\n",
-			   qp_type);
+		dev_dbg_ratelimited(&device->dev, "%s: invalid QP Type %d\n",
+				    __func__, qp_type);
 		goto error1;
 	}
 
 	if (rmpp_version && rmpp_version != IB_MGMT_RMPP_VERSION) {
-		dev_notice(&device->dev,
-			   "ib_register_mad_agent: invalid RMPP Version %u\n",
-			   rmpp_version);
+		dev_dbg_ratelimited(&device->dev,
+				    "%s: invalid RMPP Version %u\n",
+				    __func__, rmpp_version);
 		goto error1;
 	}
 
 	/* Validate MAD registration request if supplied */
 	if (mad_reg_req) {
 		if (mad_reg_req->mgmt_class_version >= MAX_MGMT_VERSION) {
-			dev_notice(&device->dev,
-				   "ib_register_mad_agent: invalid Class Version %u\n",
-				   mad_reg_req->mgmt_class_version);
+			dev_dbg_ratelimited(&device->dev,
+					    "%s: invalid Class Version %u\n",
+					    __func__,
+					    mad_reg_req->mgmt_class_version);
 			goto error1;
 		}
 		if (!recv_handler) {
-			dev_notice(&device->dev,
-				   "ib_register_mad_agent: no recv_handler\n");
+			dev_dbg_ratelimited(&device->dev,
+					    "%s: no recv_handler\n", __func__);
 			goto error1;
 		}
 		if (mad_reg_req->mgmt_class >= MAX_MGMT_CLASS) {
@@ -256,9 +256,9 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 			 */
 			if (mad_reg_req->mgmt_class !=
 			    IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE) {
-				dev_notice(&device->dev,
-					   "ib_register_mad_agent: Invalid Mgmt Class 0x%x\n",
-					   mad_reg_req->mgmt_class);
+				dev_dbg_ratelimited(&device->dev,
+					"%s: Invalid Mgmt Class 0x%x\n",
+					__func__, mad_reg_req->mgmt_class);
 				goto error1;
 			}
 		} else if (mad_reg_req->mgmt_class == 0) {
@@ -266,8 +266,9 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 			 * Class 0 is reserved in IBA and is used for
 			 * aliasing of IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE
 			 */
-			dev_notice(&device->dev,
-				   "ib_register_mad_agent: Invalid Mgmt Class 0\n");
+			dev_dbg_ratelimited(&device->dev,
+					    "%s: Invalid Mgmt Class 0\n",
+					    __func__);
 			goto error1;
 		} else if (is_vendor_class(mad_reg_req->mgmt_class)) {
 			/*
@@ -275,18 +276,19 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 			 * ensure supplied OUI is not zero
 			 */
 			if (!is_vendor_oui(mad_reg_req->oui)) {
-				dev_notice(&device->dev,
-					   "ib_register_mad_agent: No OUI specified for class 0x%x\n",
-					   mad_reg_req->mgmt_class);
+				dev_dbg_ratelimited(&device->dev,
+					"%s: No OUI specified for class 0x%x\n",
+					__func__,
+					mad_reg_req->mgmt_class);
 				goto error1;
 			}
 		}
 		/* Make sure class supplied is consistent with RMPP */
 		if (!ib_is_mad_class_rmpp(mad_reg_req->mgmt_class)) {
 			if (rmpp_version) {
-				dev_notice(&device->dev,
-					   "ib_register_mad_agent: RMPP version for non-RMPP class 0x%x\n",
-					   mad_reg_req->mgmt_class);
+				dev_dbg_ratelimited(&device->dev,
+					"%s: RMPP version for non-RMPP class 0x%x\n",
+					__func__, mad_reg_req->mgmt_class);
 				goto error1;
 			}
 		}
@@ -297,9 +299,9 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 					IB_MGMT_CLASS_SUBN_LID_ROUTED) &&
 			    (mad_reg_req->mgmt_class !=
 					IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE)) {
-				dev_notice(&device->dev,
-					   "ib_register_mad_agent: Invalid SM QP type: class 0x%x\n",
-					   mad_reg_req->mgmt_class);
+				dev_dbg_ratelimited(&device->dev,
+					"%s: Invalid SM QP type: class 0x%x\n",
+					__func__, mad_reg_req->mgmt_class);
 				goto error1;
 			}
 		} else {
@@ -307,9 +309,9 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 					IB_MGMT_CLASS_SUBN_LID_ROUTED) ||
 			    (mad_reg_req->mgmt_class ==
 					IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE)) {
-				dev_notice(&device->dev,
-					   "ib_register_mad_agent: Invalid GS QP type: class 0x%x\n",
-					   mad_reg_req->mgmt_class);
+				dev_dbg_ratelimited(&device->dev,
+					"%s: Invalid GS QP type: class 0x%x\n",
+					__func__, mad_reg_req->mgmt_class);
 				goto error1;
 			}
 		}
@@ -324,18 +326,18 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 	/* Validate device and port */
 	port_priv = ib_get_mad_port(device, port_num);
 	if (!port_priv) {
-		dev_notice(&device->dev,
-			   "ib_register_mad_agent: Invalid port %d\n",
-			   port_num);
+		dev_dbg_ratelimited(&device->dev, "%s: Invalid port %d\n",
+				    __func__, port_num);
 		ret = ERR_PTR(-ENODEV);
 		goto error1;
 	}
 
-	/* Verify the QP requested is supported.  For example, Ethernet devices
-	 * will not have QP0 */
+	/* Verify the QP requested is supported. For example, Ethernet devices
+	 * will not have QP0.
+	 */
 	if (!port_priv->qp_info[qpn].qp) {
-		dev_notice(&device->dev,
-			   "ib_register_mad_agent: QP %d not supported\n", qpn);
+		dev_dbg_ratelimited(&device->dev, "%s: QP %d not supported\n",
+				    __func__, qpn);
 		ret = ERR_PTR(-EPROTONOSUPPORT);
 		goto error1;
 	}
-- 
2.20.1



