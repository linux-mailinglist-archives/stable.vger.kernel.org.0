Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF89A56FCF6
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233529AbiGKJtm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233791AbiGKJtP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:49:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FFFC7AB23;
        Mon, 11 Jul 2022 02:23:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 129FD6134C;
        Mon, 11 Jul 2022 09:23:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11106C34115;
        Mon, 11 Jul 2022 09:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531435;
        bh=3I3gg384dMTs0wQ0ZdufSMp00jh+Tq4Oo6AjInUC+LE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vMnf0XQbh2ccrstp3v/SOgVnSvcgCtfjqcQh3PcTcx4cROfOC9IwseNA4n+LzctAz
         I8vLdWhxrSfsrnP6jiuNLQYOgqO4OPWaQoWLggLfwKganiNi3pOjU5Xg0Y4RIiXHmq
         Ywzl7B7yMljvRybram6pMWYHRa927HVQiZwb+PO0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Patalano <mpatalan@redhat.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 105/230] scsi: qla2xxx: Fix loss of NVMe namespaces after driver reload test
Date:   Mon, 11 Jul 2022 11:06:01 +0200
Message-Id: <20220711090607.046745625@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

[ Upstream commit db212f2eb3fb7f546366777e93c8f54614d39269 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 42b29f4fd937..1bf3ab10846a 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -775,7 +775,6 @@ int qla_nvme_register_hba(struct scsi_qla_host *vha)
 	ha = vha->hw;
 	tmpl = &qla_nvme_fc_transport;
 
-	WARN_ON(vha->nvme_local_port);
 
 	qla_nvme_fc_transport.max_hw_queues =
 	    min((uint8_t)(qla_nvme_fc_transport.max_hw_queues),
@@ -786,13 +785,25 @@ int qla_nvme_register_hba(struct scsi_qla_host *vha)
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
-- 
2.35.1



