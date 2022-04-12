Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2054FCA0C
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 02:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243924AbiDLAu2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 20:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242869AbiDLAty (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:49:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E5B631904;
        Mon, 11 Apr 2022 17:46:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C0B9617E9;
        Tue, 12 Apr 2022 00:46:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E92AC385A3;
        Tue, 12 Apr 2022 00:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724396;
        bh=w55IroD1ketdAcUPL7kbVGOTtGkFF2/DhAwI312KWh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eAoL8IEV7ylsTt4q47+1yyFcrCWr/HBtqkYI6ewql5iIww5H5xVvaydZWxMYoLoH2
         jdaF+D/kXCsLdnww6k/WgHn+gE1qASSvYCFG4py5fTj33Ypz1AxxF+S9QkffHZIYpk
         FQZ8z1+/xWMm3X04LkEuRrZsE+K6+r1uyxwzKtxcmYz8d0wzyZxI7Ymi4M4NZp/br0
         ZqucmhNd2Yh23VmeJPdNKDW32S47IneheFzO/S1DYQ0FJJlZRSk2+pQ/AUETUqJs4G
         wcCNQt5MYggUPy+nzJxkZIeAa0SbkNyO+LFy+oi9KA9NxBkh6GjEstPRrjGDC5XG30
         CppUGi1G21FBA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chandrakanth patil <chandrakanth.patil@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        jejb@linux.ibm.com, megaraidlinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 43/49] scsi: megaraid_sas: Target with invalid LUN ID is deleted during scan
Date:   Mon, 11 Apr 2022 20:44:01 -0400
Message-Id: <20220412004411.349427-43-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412004411.349427-1-sashal@kernel.org>
References: <20220412004411.349427-1-sashal@kernel.org>
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

From: Chandrakanth patil <chandrakanth.patil@broadcom.com>

[ Upstream commit 56495f295d8e021f77d065b890fc0100e3f9f6d8 ]

The megaraid_sas driver supports single LUN for RAID devices. That is LUN
0. All other LUNs are unsupported. When a device scan on a logical target
with invalid LUN number is invoked through sysfs, that target ends up
getting removed.

Add LUN ID validation in the slave destroy function to avoid the target
deletion.

Link: https://lore.kernel.org/r/20220324094711.48833-1-chandrakanth.patil@broadcom.com
Signed-off-by: Chandrakanth patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/megaraid/megaraid_sas.h      | 3 +++
 drivers/scsi/megaraid/megaraid_sas_base.c | 7 +++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 2c9d1b796475..ae2aef9ba8cf 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2558,6 +2558,9 @@ struct megasas_instance_template {
 #define MEGASAS_IS_LOGICAL(sdev)					\
 	((sdev->channel < MEGASAS_MAX_PD_CHANNELS) ? 0 : 1)
 
+#define MEGASAS_IS_LUN_VALID(sdev)					\
+	(((sdev)->lun == 0) ? 1 : 0)
+
 #define MEGASAS_DEV_INDEX(scp)						\
 	(((scp->device->channel % 2) * MEGASAS_MAX_DEV_PER_CHANNEL) +	\
 	scp->device->id)
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 82e1e24257bc..ca563498dcdb 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2126,6 +2126,9 @@ static int megasas_slave_alloc(struct scsi_device *sdev)
 			goto scan_target;
 		}
 		return -ENXIO;
+	} else if (!MEGASAS_IS_LUN_VALID(sdev)) {
+		sdev_printk(KERN_INFO, sdev, "%s: invalid LUN\n", __func__);
+		return -ENXIO;
 	}
 
 scan_target:
@@ -2156,6 +2159,10 @@ static void megasas_slave_destroy(struct scsi_device *sdev)
 	instance = megasas_lookup_instance(sdev->host->host_no);
 
 	if (MEGASAS_IS_LOGICAL(sdev)) {
+		if (!MEGASAS_IS_LUN_VALID(sdev)) {
+			sdev_printk(KERN_INFO, sdev, "%s: invalid LUN\n", __func__);
+			return;
+		}
 		ld_tgt_id = MEGASAS_TARGET_ID(sdev);
 		instance->ld_tgtid_status[ld_tgt_id] = LD_TARGET_ID_DELETED;
 		if (megasas_dbg_lvl & LD_PD_DEBUG)
-- 
2.35.1

