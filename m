Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1EB4FCB49
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 03:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345116AbiDLBEK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 21:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345662AbiDLA6g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:58:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D5531DEE;
        Mon, 11 Apr 2022 17:51:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16EEDB819C4;
        Tue, 12 Apr 2022 00:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 902A1C385A3;
        Tue, 12 Apr 2022 00:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724699;
        bh=zaBTjNkcM8cbUwEEMh6y0TD42PYpHi2M7HAfRYX2IB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ebfkTzxA9GHpgDnrGkf5BWOxRzx7lzUCTYBXikwT/E0yFCv2eAa6RizQpuXFk4pVT
         Mv0GsFljesVEdzkP9UiSkEzA51ozqUYFRyhhzIMAyLRCr/PVBRP9yV2XVY9fIMGSaM
         NhSp7b9iIQ1d+P3NoBQZP63e/RdzbaDr2JPzTGI1/fSVRrloG+rvdwL0kdBF//LfXN
         iSLs91c8zPQXK81J1osRMb5g2IkAWsEJ1/w9/SuA0aGyAG+Qmq0aQ7TeTvfTqbT17v
         wIGyDgZY5vdI1bHUP+Ee6RXmlRtRMbM42S63b/mblft9GTol/vsU7EIIs4dd4/AO41
         ZsHHTA9EZbGhQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chandrakanth patil <chandrakanth.patil@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        jejb@linux.ibm.com, megaraidlinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 19/21] scsi: megaraid_sas: Target with invalid LUN ID is deleted during scan
Date:   Mon, 11 Apr 2022 20:50:38 -0400
Message-Id: <20220412005042.351105-19-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412005042.351105-1-sashal@kernel.org>
References: <20220412005042.351105-1-sashal@kernel.org>
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
index 3d43ac9772f7..aa62cc8ffd0a 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2551,6 +2551,9 @@ struct megasas_instance_template {
 #define MEGASAS_IS_LOGICAL(sdev)					\
 	((sdev->channel < MEGASAS_MAX_PD_CHANNELS) ? 0 : 1)
 
+#define MEGASAS_IS_LUN_VALID(sdev)					\
+	(((sdev)->lun == 0) ? 1 : 0)
+
 #define MEGASAS_DEV_INDEX(scp)						\
 	(((scp->device->channel % 2) * MEGASAS_MAX_DEV_PER_CHANNEL) +	\
 	scp->device->id)
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 6700d43b12ff..a261ce511e9e 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2102,6 +2102,9 @@ static int megasas_slave_alloc(struct scsi_device *sdev)
 			goto scan_target;
 		}
 		return -ENXIO;
+	} else if (!MEGASAS_IS_LUN_VALID(sdev)) {
+		sdev_printk(KERN_INFO, sdev, "%s: invalid LUN\n", __func__);
+		return -ENXIO;
 	}
 
 scan_target:
@@ -2132,6 +2135,10 @@ static void megasas_slave_destroy(struct scsi_device *sdev)
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

