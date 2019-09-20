Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE4F5B9323
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392861AbfITOh4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:37:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35764 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388024AbfITOZA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:00 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqD-0004wy-P9; Fri, 20 Sep 2019 15:24:57 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqC-0007qZ-Qk; Fri, 20 Sep 2019 15:24:56 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Giridhar Malavali" <giridhar.malavali@qlogic.com>,
        "Bart Van Assche" <bvanassche@acm.org>,
        "Himanshu Madhani" <hmadhani@marvell.com>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.337953114@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 025/132] scsi: qla2xxx: Unregister chrdev if module
 initialization fails
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

commit c794d24ec9eb6658909955772e70f34bef5b5b91 upstream.

If module initialization fails after the character device has been
registered, unregister the character device. Additionally, avoid
duplicating error path code.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
Fixes: 6a03b4cd78f3 ("[SCSI] qla2xxx: Add char device to increase driver use count") # v2.6.35.
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/qla2xxx/qla_os.c | 34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5775,8 +5775,7 @@ qla2x00_module_init(void)
 	/* Initialize target kmem_cache and mem_pools */
 	ret = qlt_init();
 	if (ret < 0) {
-		kmem_cache_destroy(srb_cachep);
-		return ret;
+		goto destroy_cache;
 	} else if (ret > 0) {
 		/*
 		 * If initiator mode is explictly disabled by qlt_init(),
@@ -5795,11 +5794,10 @@ qla2x00_module_init(void)
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
@@ -5811,27 +5809,37 @@ qla2x00_module_init(void)
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

