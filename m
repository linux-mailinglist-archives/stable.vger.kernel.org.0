Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 561F24F03FC
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 16:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356489AbiDBOeA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 10:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356541AbiDBOdI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 10:33:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA0B4BFC8
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 07:31:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D884B8095A
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 14:31:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D5AC340EC;
        Sat,  2 Apr 2022 14:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648909872;
        bh=0TnW/XpANW1fjknIImVhy+ZhUfmE7Xnhfo1z/KbzgV4=;
        h=Subject:To:Cc:From:Date:From;
        b=tJHlPZyTuzsHpMCLS/Mq1dFO2JUOeLTqbnyEcYPhXOItCoK9YZrTJc+dx7zY05Bif
         bzjeigSktNwY+2IEG0Vett1LVtI324QfP+5K3TUkU19xfz/CzH32BEiZbyexvlFo87
         fq9Pq1P9t2dxDIpu9NT5rywDC7Kuu4C6jZnQpBXM=
Subject: FAILED: patch "[PATCH] scsi: qla2xxx: Increase max limit of ql2xnvme_queues" failed to apply to 5.17-stable tree
To:     sdeodhar@marvell.com, himanshu.madhani@oracle.com,
        martin.petersen@oracle.com, njavali@marvell.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 02 Apr 2022 16:30:17 +0200
Message-ID: <1648909817226192@kroah.com>
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


The patch below does not apply to the 5.17-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3648bcf1c1374e9f42d241d83e2e50c0ef07a852 Mon Sep 17 00:00:00 2001
From: Shreyas Deodhar <sdeodhar@marvell.com>
Date: Thu, 10 Mar 2022 01:26:03 -0800
Subject: [PATCH] scsi: qla2xxx: Increase max limit of ql2xnvme_queues

Increase max limit of ql2xnvme_queues to (max_qpair - 1).

Link: https://lore.kernel.org/r/20220310092604.22950-13-njavali@marvell.com
Fixes: 65120de26a54 ("scsi: qla2xxx: Add ql2xnvme_queues module param to configure number of NVMe queues")
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Shreyas Deodhar <sdeodhar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 794a95b2e3b4..87c9404aa401 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -799,17 +799,22 @@ int qla_nvme_register_hba(struct scsi_qla_host *vha)
 	ha = vha->hw;
 	tmpl = &qla_nvme_fc_transport;
 
-	if (ql2xnvme_queues < MIN_NVME_HW_QUEUES || ql2xnvme_queues > MAX_NVME_HW_QUEUES) {
+	if (ql2xnvme_queues < MIN_NVME_HW_QUEUES) {
 		ql_log(ql_log_warn, vha, 0xfffd,
-		    "ql2xnvme_queues=%d is out of range(MIN:%d - MAX:%d). Resetting ql2xnvme_queues to:%d\n",
-		    ql2xnvme_queues, MIN_NVME_HW_QUEUES, MAX_NVME_HW_QUEUES,
-		    DEF_NVME_HW_QUEUES);
+		    "ql2xnvme_queues=%d is lower than minimum queues: %d. Resetting ql2xnvme_queues to:%d\n",
+		    ql2xnvme_queues, MIN_NVME_HW_QUEUES, DEF_NVME_HW_QUEUES);
 		ql2xnvme_queues = DEF_NVME_HW_QUEUES;
+	} else if (ql2xnvme_queues > (ha->max_qpairs - 1)) {
+		ql_log(ql_log_warn, vha, 0xfffd,
+		       "ql2xnvme_queues=%d is greater than available IRQs: %d. Resetting ql2xnvme_queues to: %d\n",
+		       ql2xnvme_queues, (ha->max_qpairs - 1),
+		       (ha->max_qpairs - 1));
+		ql2xnvme_queues = ((ha->max_qpairs - 1));
 	}
 
 	qla_nvme_fc_transport.max_hw_queues =
 	    min((uint8_t)(ql2xnvme_queues),
-		(uint8_t)(ha->max_qpairs ? ha->max_qpairs : 1));
+		(uint8_t)((ha->max_qpairs - 1) ? (ha->max_qpairs - 1) : 1));
 
 	ql_log(ql_log_info, vha, 0xfffb,
 	       "Number of NVME queues used for this port: %d\n",
diff --git a/drivers/scsi/qla2xxx/qla_nvme.h b/drivers/scsi/qla2xxx/qla_nvme.h
index d0e3c0e07baa..d299478371b2 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.h
+++ b/drivers/scsi/qla2xxx/qla_nvme.h
@@ -14,7 +14,6 @@
 #include "qla_dsd.h"
 
 #define MIN_NVME_HW_QUEUES 1
-#define MAX_NVME_HW_QUEUES 128
 #define DEF_NVME_HW_QUEUES 8
 
 #define NVME_ATIO_CMD_OFF 32
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 81451c11eef4..762229d495a8 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -344,7 +344,6 @@ MODULE_PARM_DESC(ql2xnvme_queues,
 	"Number of NVMe Queues that can be configured.\n"
 	"Final value will be min(ql2xnvme_queues, num_cpus,num_chip_queues)\n"
 	"1 - Minimum number of queues supported\n"
-	"128 - Maximum number of queues supported\n"
 	"8 - Default value");
 
 static struct scsi_transport_template *qla2xxx_transport_template = NULL;

