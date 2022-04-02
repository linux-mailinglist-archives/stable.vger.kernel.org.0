Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 672CE4F03F4
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 16:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356483AbiDBOcp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 10:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239878AbiDBOcp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 10:32:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD94F4C42D
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 07:30:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A858615C3
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 14:30:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E81BC340EC;
        Sat,  2 Apr 2022 14:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648909852;
        bh=DcUbYRbu6G4oilO38e5bFg5TeJqtydhsj8inxk7SiPU=;
        h=Subject:To:Cc:From:Date:From;
        b=sKNq8kaUNRmZ5PF3U48arktQwVpTEV2x6eV0yeJHpe8dwB8FMFU52rhl+iCZIr96y
         EqSY33L9U9ZKjUsVWNSz1ee6QNRPgcuS+Cp4TtJLFnnDnhvrQYh4yc8Czp7LCznhpK
         RSNcZuIFuxzKyyxPN/Lmh3JeYD7Rm5FnWbTrGISk=
Subject: FAILED: patch "[PATCH] scsi: qla2xxx: Fix loss of NVMe namespaces after driver" failed to apply to 5.4-stable tree
To:     aeasi@marvell.com, himanshu.madhani@oracle.com,
        martin.petersen@oracle.com, mpatalan@redhat.com,
        njavali@marvell.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 02 Apr 2022 16:30:04 +0200
Message-ID: <164890980419203@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From db212f2eb3fb7f546366777e93c8f54614d39269 Mon Sep 17 00:00:00 2001
From: Arun Easi <aeasi@marvell.com>
Date: Thu, 10 Mar 2022 01:25:54 -0800
Subject: [PATCH] scsi: qla2xxx: Fix loss of NVMe namespaces after driver
 reload test

Driver registration of localport can race when it happens at the remote
port discovery time. Fix this by calling the registration under a mutex.

Link: https://lore.kernel.org/r/20220310092604.22950-4-njavali@marvell.com
Fixes: e84067d74301 ("scsi: qla2xxx: Add FC-NVMe F/W initialization and transport registration")
Cc: stable@vger.kernel.org
Reported-by: Marco Patalano <mpatalan@redhat.com>
Tested-by: Marco Patalano <mpatalan@redhat.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 5723082d94d6..3bf5cbd754a7 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -782,8 +782,6 @@ int qla_nvme_register_hba(struct scsi_qla_host *vha)
 	ha = vha->hw;
 	tmpl = &qla_nvme_fc_transport;
 
-	WARN_ON(vha->nvme_local_port);
-
 	if (ql2xnvme_queues < MIN_NVME_HW_QUEUES || ql2xnvme_queues > MAX_NVME_HW_QUEUES) {
 		ql_log(ql_log_warn, vha, 0xfffd,
 		    "ql2xnvme_queues=%d is out of range(MIN:%d - MAX:%d). Resetting ql2xnvme_queues to:%d\n",
@@ -797,7 +795,7 @@ int qla_nvme_register_hba(struct scsi_qla_host *vha)
 		(uint8_t)(ha->max_qpairs ? ha->max_qpairs : 1));
 
 	ql_log(ql_log_info, vha, 0xfffb,
-	    "Number of NVME queues used for this port: %d\n",
+	       "Number of NVME queues used for this port: %d\n",
 	    qla_nvme_fc_transport.max_hw_queues);
 
 	pinfo.node_name = wwn_to_u64(vha->node_name);
@@ -805,13 +803,25 @@ int qla_nvme_register_hba(struct scsi_qla_host *vha)
 	pinfo.port_role = FC_PORT_ROLE_NVME_INITIATOR;
 	pinfo.port_id = vha->d_id.b24;
 
-	ql_log(ql_log_info, vha, 0xffff,
-	    "register_localport: host-traddr=nn-0x%llx:pn-0x%llx on portID:%x\n",
-	    pinfo.node_name, pinfo.port_name, pinfo.port_id);
-	qla_nvme_fc_transport.dma_boundary = vha->host->dma_boundary;
-
-	ret = nvme_fc_register_localport(&pinfo, tmpl,
-	    get_device(&ha->pdev->dev), &vha->nvme_local_port);
+	mutex_lock(&ha->vport_lock);
+	/*
+	 * Check again for nvme_local_port to see if any other thread raced
+	 * with this one and finished registration.
+	 */
+	if (!vha->nvme_local_port) {
+		ql_log(ql_log_info, vha, 0xffff,
+		    "register_localport: host-traddr=nn-0x%llx:pn-0x%llx on portID:%x\n",
+		    pinfo.node_name, pinfo.port_name, pinfo.port_id);
+		qla_nvme_fc_transport.dma_boundary = vha->host->dma_boundary;
+
+		ret = nvme_fc_register_localport(&pinfo, tmpl,
+						 get_device(&ha->pdev->dev),
+						 &vha->nvme_local_port);
+		mutex_unlock(&ha->vport_lock);
+	} else {
+		mutex_unlock(&ha->vport_lock);
+		return 0;
+	}
 	if (ret) {
 		ql_log(ql_log_warn, vha, 0xffff,
 		    "register_localport failed: ret=%x\n", ret);

