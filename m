Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 960FB14844B
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:41:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388325AbgAXLQk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:16:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:53440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390381AbgAXLQh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:16:37 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDC9A20704;
        Fri, 24 Jan 2020 11:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864596;
        bh=k/czbYxF4bnobyYal/I8K+luZWw3QnlhrGOKRtVi+L0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IHEnUXNXSQz/x7HKZgr/cn+kdu9MOs4jXsc7cj/31dyDHlWLrjXq8qXnYcJ4PiXic
         rFxpiGQXwC5cSyFpWU0B9RYDtO1NZxJNSAZK7FMc3NI/YxPg/KjeNyZGE+3BMXiYzJ
         mGEumDUGmrFJKSmPCMi2e7lwcL+iZfqtiq0yrEIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Himanshu Madhani <hmadhani@marvell.com>,
        Giridhar Malavali <giridhar.malavali@qlogic.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 297/639] scsi: qla2xxx: Unregister chrdev if module initialization fails
Date:   Fri, 24 Jan 2020 10:27:47 +0100
Message-Id: <20200124093124.130769714@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit c794d24ec9eb6658909955772e70f34bef5b5b91 ]

If module initialization fails after the character device has been
registered, unregister the character device. Additionally, avoid
duplicating error path code.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
Fixes: 6a03b4cd78f3 ("[SCSI] qla2xxx: Add char device to increase driver use count") # v2.6.35.
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index bb20a4a228cfe..fff20a3707677 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -6967,8 +6967,7 @@ qla2x00_module_init(void)
 	/* Initialize target kmem_cache and mem_pools */
 	ret = qlt_init();
 	if (ret < 0) {
-		kmem_cache_destroy(srb_cachep);
-		return ret;
+		goto destroy_cache;
 	} else if (ret > 0) {
 		/*
 		 * If initiator mode is explictly disabled by qlt_init(),
@@ -6989,11 +6988,10 @@ qla2x00_module_init(void)
 	qla2xxx_transport_template =
 	    fc_attach_transport(&qla2xxx_transport_functions);
 	if (!qla2xxx_transport_template) {
-		kmem_cache_destroy(srb_cachep);
 		ql_log(ql_log_fatal, NULL, 0x0002,
 		    "fc_attach_transport failed...Failing load!.\n");
-		qlt_exit();
-		return -ENODEV;
+		ret = -ENODEV;
+		goto qlt_exit;
 	}
 
 	apidev_major = register_chrdev(0, QLA2XXX_APIDEV, &apidev_fops);
@@ -7005,27 +7003,37 @@ qla2x00_module_init(void)
 	qla2xxx_transport_vport_template =
 	    fc_attach_transport(&qla2xxx_transport_vport_functions);
 	if (!qla2xxx_transport_vport_template) {
-		kmem_cache_destroy(srb_cachep);
-		qlt_exit();
-		fc_release_transport(qla2xxx_transport_template);
 		ql_log(ql_log_fatal, NULL, 0x0004,
 		    "fc_attach_transport vport failed...Failing load!.\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto unreg_chrdev;
 	}
 	ql_log(ql_log_info, NULL, 0x0005,
 	    "QLogic Fibre Channel HBA Driver: %s.\n",
 	    qla2x00_version_str);
 	ret = pci_register_driver(&qla2xxx_pci_driver);
 	if (ret) {
-		kmem_cache_destroy(srb_cachep);
-		qlt_exit();
-		fc_release_transport(qla2xxx_transport_template);
-		fc_release_transport(qla2xxx_transport_vport_template);
 		ql_log(ql_log_fatal, NULL, 0x0006,
 		    "pci_register_driver failed...ret=%d Failing load!.\n",
 		    ret);
+		goto release_vport_transport;
 	}
 	return ret;
+
+release_vport_transport:
+	fc_release_transport(qla2xxx_transport_vport_template);
+
+unreg_chrdev:
+	if (apidev_major >= 0)
+		unregister_chrdev(apidev_major, QLA2XXX_APIDEV);
+	fc_release_transport(qla2xxx_transport_template);
+
+qlt_exit:
+	qlt_exit();
+
+destroy_cache:
+	kmem_cache_destroy(srb_cachep);
+	return ret;
 }
 
 /**
-- 
2.20.1



