Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBD124EF419
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352866AbiDAPIW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 11:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350545AbiDAPAI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 11:00:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3808D65401;
        Fri,  1 Apr 2022 07:47:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C300560A53;
        Fri,  1 Apr 2022 14:47:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 112DDC36AE2;
        Fri,  1 Apr 2022 14:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824465;
        bh=J/cov+O/p/dhmJJdHkhL71kzXqzqN4UKCqaMC//VubM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GxEY8u/R2UFRGS3K7sbfKkhmkbMZUmb6YU77M4Cm3hKl2g5hMkrTiiIf36rjUKdq3
         kfY6g7cWQr9TFnVzs7cRvA9KgkkPt7DsVnP4fPmnZJCDsnHjCLG5u3yLqP0BoJB2QM
         G0xbBLZAJ/kXvKFvcYlsmG1fgp+EDurJ4+0RGVZsPLl7tzEGo8gUaPeD/rmDqNuYK1
         TcmVHGfcgaoSqkMEeGpkR1E+HJMASwIsnPMdBLaIb5gwAXePh3Y9n3oan9euhBOwYz
         dvTgv4+E48KPfE/eyP4RJba6099Gn9dYZ851cp/0fouTiRRZz+BizgPts6x0GAq5TH
         8uEf20dyR8nfA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Guang <yang.guang5@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>,
        David Yang <davidcomponentone@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, anil.gurumurthy@qlogic.com,
        sudarsana.kalluru@qlogic.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 05/22] scsi: bfa: Replace snprintf() with sysfs_emit()
Date:   Fri,  1 Apr 2022 10:47:12 -0400
Message-Id: <20220401144729.1955554-5-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401144729.1955554-1-sashal@kernel.org>
References: <20220401144729.1955554-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Yang Guang <yang.guang5@zte.com.cn>

[ Upstream commit 2245ea91fd3a04cafbe2f54911432a8657528c3b ]

coccinelle report:
./drivers/scsi/bfa/bfad_attr.c:908:8-16:
WARNING: use scnprintf or sprintf
./drivers/scsi/bfa/bfad_attr.c:860:8-16:
WARNING: use scnprintf or sprintf
./drivers/scsi/bfa/bfad_attr.c:888:8-16:
WARNING: use scnprintf or sprintf
./drivers/scsi/bfa/bfad_attr.c:853:8-16:
WARNING: use scnprintf or sprintf
./drivers/scsi/bfa/bfad_attr.c:808:8-16:
WARNING: use scnprintf or sprintf
./drivers/scsi/bfa/bfad_attr.c:728:8-16:
WARNING: use scnprintf or sprintf
./drivers/scsi/bfa/bfad_attr.c:822:8-16:
WARNING: use scnprintf or sprintf
./drivers/scsi/bfa/bfad_attr.c:927:9-17:
WARNING: use scnprintf or sprintf
./drivers/scsi/bfa/bfad_attr.c:900:8-16:
WARNING: use scnprintf or sprintf
./drivers/scsi/bfa/bfad_attr.c:874:8-16:
WARNING: use scnprintf or sprintf
./drivers/scsi/bfa/bfad_attr.c:714:8-16:
WARNING: use scnprintf or sprintf
./drivers/scsi/bfa/bfad_attr.c:839:8-16:
WARNING: use scnprintf or sprintf

Use sysfs_emit() instead of scnprintf() or sprintf().

Link: https://lore.kernel.org/r/def83ff75faec64ba592b867a8499b1367bae303.1643181468.git.yang.guang5@zte.com.cn
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Yang Guang <yang.guang5@zte.com.cn>
Signed-off-by: David Yang <davidcomponentone@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/bfa/bfad_attr.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index 0a70d54a4df6..47e599352468 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -722,7 +722,7 @@ bfad_im_serial_num_show(struct device *dev, struct device_attribute *attr,
 	char serial_num[BFA_ADAPTER_SERIAL_NUM_LEN];
 
 	bfa_get_adapter_serial_num(&bfad->bfa, serial_num);
-	return snprintf(buf, PAGE_SIZE, "%s\n", serial_num);
+	return sysfs_emit(buf, "%s\n", serial_num);
 }
 
 static ssize_t
@@ -736,7 +736,7 @@ bfad_im_model_show(struct device *dev, struct device_attribute *attr,
 	char model[BFA_ADAPTER_MODEL_NAME_LEN];
 
 	bfa_get_adapter_model(&bfad->bfa, model);
-	return snprintf(buf, PAGE_SIZE, "%s\n", model);
+	return sysfs_emit(buf, "%s\n", model);
 }
 
 static ssize_t
@@ -816,7 +816,7 @@ bfad_im_model_desc_show(struct device *dev, struct device_attribute *attr,
 		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
 			"Invalid Model");
 
-	return snprintf(buf, PAGE_SIZE, "%s\n", model_descr);
+	return sysfs_emit(buf, "%s\n", model_descr);
 }
 
 static ssize_t
@@ -830,7 +830,7 @@ bfad_im_node_name_show(struct device *dev, struct device_attribute *attr,
 	u64        nwwn;
 
 	nwwn = bfa_fcs_lport_get_nwwn(port->fcs_port);
-	return snprintf(buf, PAGE_SIZE, "0x%llx\n", cpu_to_be64(nwwn));
+	return sysfs_emit(buf, "0x%llx\n", cpu_to_be64(nwwn));
 }
 
 static ssize_t
@@ -847,7 +847,7 @@ bfad_im_symbolic_name_show(struct device *dev, struct device_attribute *attr,
 	bfa_fcs_lport_get_attr(&bfad->bfa_fcs.fabric.bport, &port_attr);
 	strlcpy(symname, port_attr.port_cfg.sym_name.symname,
 			BFA_SYMNAME_MAXLEN);
-	return snprintf(buf, PAGE_SIZE, "%s\n", symname);
+	return sysfs_emit(buf, "%s\n", symname);
 }
 
 static ssize_t
@@ -861,14 +861,14 @@ bfad_im_hw_version_show(struct device *dev, struct device_attribute *attr,
 	char hw_ver[BFA_VERSION_LEN];
 
 	bfa_get_pci_chip_rev(&bfad->bfa, hw_ver);
-	return snprintf(buf, PAGE_SIZE, "%s\n", hw_ver);
+	return sysfs_emit(buf, "%s\n", hw_ver);
 }
 
 static ssize_t
 bfad_im_drv_version_show(struct device *dev, struct device_attribute *attr,
 				char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%s\n", BFAD_DRIVER_VERSION);
+	return sysfs_emit(buf, "%s\n", BFAD_DRIVER_VERSION);
 }
 
 static ssize_t
@@ -882,7 +882,7 @@ bfad_im_optionrom_version_show(struct device *dev,
 	char optrom_ver[BFA_VERSION_LEN];
 
 	bfa_get_adapter_optrom_ver(&bfad->bfa, optrom_ver);
-	return snprintf(buf, PAGE_SIZE, "%s\n", optrom_ver);
+	return sysfs_emit(buf, "%s\n", optrom_ver);
 }
 
 static ssize_t
@@ -896,7 +896,7 @@ bfad_im_fw_version_show(struct device *dev, struct device_attribute *attr,
 	char fw_ver[BFA_VERSION_LEN];
 
 	bfa_get_adapter_fw_ver(&bfad->bfa, fw_ver);
-	return snprintf(buf, PAGE_SIZE, "%s\n", fw_ver);
+	return sysfs_emit(buf, "%s\n", fw_ver);
 }
 
 static ssize_t
@@ -908,7 +908,7 @@ bfad_im_num_of_ports_show(struct device *dev, struct device_attribute *attr,
 			(struct bfad_im_port_s *) shost->hostdata[0];
 	struct bfad_s *bfad = im_port->bfad;
 
-	return snprintf(buf, PAGE_SIZE, "%d\n",
+	return sysfs_emit(buf, "%d\n",
 			bfa_get_nports(&bfad->bfa));
 }
 
@@ -916,7 +916,7 @@ static ssize_t
 bfad_im_drv_name_show(struct device *dev, struct device_attribute *attr,
 				char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%s\n", BFAD_DRIVER_NAME);
+	return sysfs_emit(buf, "%s\n", BFAD_DRIVER_NAME);
 }
 
 static ssize_t
@@ -935,14 +935,14 @@ bfad_im_num_of_discovered_ports_show(struct device *dev,
 	rports = kzalloc(sizeof(struct bfa_rport_qualifier_s) * nrports,
 			 GFP_ATOMIC);
 	if (rports == NULL)
-		return snprintf(buf, PAGE_SIZE, "Failed\n");
+		return sysfs_emit(buf, "Failed\n");
 
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
 	bfa_fcs_lport_get_rport_quals(port->fcs_port, rports, &nrports);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 	kfree(rports);
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", nrports);
+	return sysfs_emit(buf, "%d\n", nrports);
 }
 
 static          DEVICE_ATTR(serial_number, S_IRUGO,
-- 
2.34.1

