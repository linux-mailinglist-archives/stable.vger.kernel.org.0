Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEDF913E984
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393334AbgAPRiZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:38:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:54252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404985AbgAPRiY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:38:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F1AD246DB;
        Thu, 16 Jan 2020 17:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196303;
        bh=YD5Ie152X2diOgl1WgLPBjDtz/7t+yfr5MhUnXiuwZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pIpZVIffxzr+AGE8//7n3EkxavUHWj18OwhyVKbvt7/ZXEfv5L+EMJVr2Qg5oVOeK
         svGIsrV5dej/xnKAgK0q342mKo6KrubruFpJWhU6KwLoSSzLWRTi07FDgqCBD6sT70
         mNIgv6HFJ0vjKnXdsuJh0ZOMS1aUrwYWYCOZ0b38=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Giridhar Malavali <giridhar.malavali@qlogic.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 113/251] scsi: qla2xxx: Unregister chrdev if module initialization fails
Date:   Thu, 16 Jan 2020 12:34:22 -0500
Message-Id: <20200116173641.22137-73-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116173641.22137-1-sashal@kernel.org>
References: <20200116173641.22137-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 3bae56b202f8..e730aabc26d0 100644
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

