Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3A114EF27D
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351104AbiDAPGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 11:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350121AbiDAO7E (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:59:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9B458835;
        Fri,  1 Apr 2022 07:46:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BAC360AC9;
        Fri,  1 Apr 2022 14:46:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7ED2C340EE;
        Fri,  1 Apr 2022 14:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824396;
        bh=tTR3uV3Kb9zcs1WZe6212+WS79Fv9rslN/hXewfw9vM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s3w/qe+qQZF1Oox9ANXrrN3E9UyR1CkULnLaA56Q2iOFBsFFtgm2w9hMl0u5PeanQ
         Qmn5KZTbWWqXzS2HptVi7JVd6RmFikqxIlfpx2G+m8iQhnCwTNECo7L7ciJETURkea
         WvemeneojieZXJsTPPAqqztyXZWl4SxGHEKSn9Fg7OLv1GjkaN9Noy6MSMOFFJgbQ+
         UHZdmDJE9XmU/NP7PzluykzAX96LE0dGyYhDwLBQdgGtgtgSX//92AW2RfaZrvCZhx
         FNWnUzdkvITTg57m72LpNWkhsIsfjSLBP12d6NA3XYwoaVshGs8TmVYb97bfpr5veQ
         9Gztd8TkwElFg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Guang <yang.guang5@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>,
        David Yang <davidcomponentone@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, anil.gurumurthy@qlogic.com,
        sudarsana.kalluru@qlogic.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 07/29] scsi: bfa: Replace snprintf() with sysfs_emit()
Date:   Fri,  1 Apr 2022 10:45:50 -0400
Message-Id: <20220401144612.1955177-7-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401144612.1955177-1-sashal@kernel.org>
References: <20220401144612.1955177-1-sashal@kernel.org>
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
index 3b84290cf0a7..eaab423a5fd0 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -719,7 +719,7 @@ bfad_im_serial_num_show(struct device *dev, struct device_attribute *attr,
 	char serial_num[BFA_ADAPTER_SERIAL_NUM_LEN];
 
 	bfa_get_adapter_serial_num(&bfad->bfa, serial_num);
-	return snprintf(buf, PAGE_SIZE, "%s\n", serial_num);
+	return sysfs_emit(buf, "%s\n", serial_num);
 }
 
 static ssize_t
@@ -733,7 +733,7 @@ bfad_im_model_show(struct device *dev, struct device_attribute *attr,
 	char model[BFA_ADAPTER_MODEL_NAME_LEN];
 
 	bfa_get_adapter_model(&bfad->bfa, model);
-	return snprintf(buf, PAGE_SIZE, "%s\n", model);
+	return sysfs_emit(buf, "%s\n", model);
 }
 
 static ssize_t
@@ -813,7 +813,7 @@ bfad_im_model_desc_show(struct device *dev, struct device_attribute *attr,
 		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
 			"Invalid Model");
 
-	return snprintf(buf, PAGE_SIZE, "%s\n", model_descr);
+	return sysfs_emit(buf, "%s\n", model_descr);
 }
 
 static ssize_t
@@ -827,7 +827,7 @@ bfad_im_node_name_show(struct device *dev, struct device_attribute *attr,
 	u64        nwwn;
 
 	nwwn = bfa_fcs_lport_get_nwwn(port->fcs_port);
-	return snprintf(buf, PAGE_SIZE, "0x%llx\n", cpu_to_be64(nwwn));
+	return sysfs_emit(buf, "0x%llx\n", cpu_to_be64(nwwn));
 }
 
 static ssize_t
@@ -844,7 +844,7 @@ bfad_im_symbolic_name_show(struct device *dev, struct device_attribute *attr,
 	bfa_fcs_lport_get_attr(&bfad->bfa_fcs.fabric.bport, &port_attr);
 	strlcpy(symname, port_attr.port_cfg.sym_name.symname,
 			BFA_SYMNAME_MAXLEN);
-	return snprintf(buf, PAGE_SIZE, "%s\n", symname);
+	return sysfs_emit(buf, "%s\n", symname);
 }
 
 static ssize_t
@@ -858,14 +858,14 @@ bfad_im_hw_version_show(struct device *dev, struct device_attribute *attr,
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
@@ -879,7 +879,7 @@ bfad_im_optionrom_version_show(struct device *dev,
 	char optrom_ver[BFA_VERSION_LEN];
 
 	bfa_get_adapter_optrom_ver(&bfad->bfa, optrom_ver);
-	return snprintf(buf, PAGE_SIZE, "%s\n", optrom_ver);
+	return sysfs_emit(buf, "%s\n", optrom_ver);
 }
 
 static ssize_t
@@ -893,7 +893,7 @@ bfad_im_fw_version_show(struct device *dev, struct device_attribute *attr,
 	char fw_ver[BFA_VERSION_LEN];
 
 	bfa_get_adapter_fw_ver(&bfad->bfa, fw_ver);
-	return snprintf(buf, PAGE_SIZE, "%s\n", fw_ver);
+	return sysfs_emit(buf, "%s\n", fw_ver);
 }
 
 static ssize_t
@@ -905,7 +905,7 @@ bfad_im_num_of_ports_show(struct device *dev, struct device_attribute *attr,
 			(struct bfad_im_port_s *) shost->hostdata[0];
 	struct bfad_s *bfad = im_port->bfad;
 
-	return snprintf(buf, PAGE_SIZE, "%d\n",
+	return sysfs_emit(buf, "%d\n",
 			bfa_get_nports(&bfad->bfa));
 }
 
@@ -913,7 +913,7 @@ static ssize_t
 bfad_im_drv_name_show(struct device *dev, struct device_attribute *attr,
 				char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%s\n", BFAD_DRIVER_NAME);
+	return sysfs_emit(buf, "%s\n", BFAD_DRIVER_NAME);
 }
 
 static ssize_t
@@ -932,14 +932,14 @@ bfad_im_num_of_discovered_ports_show(struct device *dev,
 	rports = kcalloc(nrports, sizeof(struct bfa_rport_qualifier_s),
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

