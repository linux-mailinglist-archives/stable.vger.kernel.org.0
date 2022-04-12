Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8754FCA9A
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 02:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242563AbiDLAym (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 20:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243118AbiDLAxl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:53:41 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0228B34677;
        Mon, 11 Apr 2022 17:48:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4607FCE1A84;
        Tue, 12 Apr 2022 00:48:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E47C385A9;
        Tue, 12 Apr 2022 00:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724530;
        bh=+d1W2Bsbjdk5UQO9pAwyPjGuXlSIBU9LahFxJwAPdzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u7tLkBeR3mOKRxNV4Zd9La932qJnfQtVNwC1mtzGA+Hb9rdQtEnhJRC6OXYWRpnzX
         +h49BJbtrzPvWuWTf2fDIMToTgIS4ULaurU3ejvyUFbNOXAH6p9+bMGC+TSEQ+Dq4n
         f8pP7ycoBOr5Fs9hJ7DFzhrx9Lve1GdYx6rodR84BJzvZPKmU2yqzFGmH7ct3M+p7K
         tgEI/MgrbjVAOsCFYcn4bsAWiX4/P2elqaaUrDM1p5KhP36jHBigKJ+69vqfqv9bO7
         rD68xH39C2dS59JXDbJcZNdDJOkd+QZoEbXUd/fliDkeAviESvJQCoDnGHQdROIoiK
         v99O22YGMJueQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chandrakanth patil <chandrakanth.patil@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        jejb@linux.ibm.com, megaraidlinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 36/41] scsi: megaraid_sas: Target with invalid LUN ID is deleted during scan
Date:   Mon, 11 Apr 2022 20:46:48 -0400
Message-Id: <20220412004656.350101-36-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412004656.350101-1-sashal@kernel.org>
References: <20220412004656.350101-1-sashal@kernel.org>
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
index 7af2c23652b0..650210d2abb4 100644
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
index 39d8754e63ac..bb3f78013a13 100644
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

