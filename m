Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC0414B9C9
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730936AbgA1OUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:20:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:45974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731144AbgA1OUz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:20:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C0DF24688;
        Tue, 28 Jan 2020 14:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221253;
        bh=VlTm21CudXxI9MsRLV27o43q5O6M17krNLwXLviJQBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZdKMuQZlSbORErhb1WjPRzQJHAUI08LuelemlJzrSXWhMtYoCyRg38mVqIiFAmTyl
         GfmuHkT2MTl2NtCGeRwcqw8pQj2jGQXFcQXqcHp77uG6yJYY/Ekmuq8BpsuZYmqDPe
         RvqD7dcQ30TcGbbfBkqf6P0PicAG+VQA8vI+rb38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Himanshu Madhani <hmadhani@marvell.com>,
        Giridhar Malavali <giridhar.malavali@qlogic.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 114/271] scsi: qla2xxx: Unregister chrdev if module initialization fails
Date:   Tue, 28 Jan 2020 15:04:23 +0100
Message-Id: <20200128135901.063091208@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
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
index 3bae56b202f87..e730aabc26d0d 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -6055,8 +6055,7 @@ qla2x00_module_init(void)
 	/* Initialize target kmem_cache and mem_pools */
 	ret = qlt_init();
 	if (ret < 0) {
-		kmem_cache_destroy(srb_cachep);
-		return ret;
+		goto destroy_cache;
 	} else if (ret > 0) {
 		/*
 		 * If initiator mode is explictly disabled by qlt_init(),
@@ -6075,11 +6074,10 @@ qla2x00_module_init(void)
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
@@ -6091,27 +6089,37 @@ qla2x00_module_init(void)
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



