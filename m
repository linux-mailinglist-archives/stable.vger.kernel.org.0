Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9D715C4D3
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729280AbgBMPvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:51:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:44600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387528AbgBMP0T (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:26:19 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8681C24676;
        Thu, 13 Feb 2020 15:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607578;
        bh=+AozUer+RTveAtjd+snUjhhpsON3Db5m0S4zTsSF4T4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oPHFZJpd2sjYsu+XDrYavwfRQZcN+KMor2IWLCcoFWX0Amrqm6/JQqB6oB5hsHn81
         f6rmKSpi7rMMH9mY7JBhri+yuNxOGXizc67h/d4xnYQQRzwAiaQfvIcUgUIrcfcoFx
         umm4JVJUwbVNP1ygmmI0Ti5o9x2sPUVfb3/3BajQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Anand Lodnoor <anand.lodnoor@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.14 168/173] scsi: megaraid_sas: Do not initiate OCR if controller is not in ready state
Date:   Thu, 13 Feb 2020 07:21:11 -0800
Message-Id: <20200213152013.403952129@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
References: <20200213151931.677980430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anand Lodnoor <anand.lodnoor@broadcom.com>

commit 6d7537270e3283b92f9b327da9d58a4de40fe8d0 upstream.

Driver initiates OCR if a DCMD command times out. But there is a deadlock
if the driver attempts to invoke another OCR before the mutex lock
(reset_mutex) is released from the previous session of OCR.

This patch takes care of the above scenario using new flag
MEGASAS_FUSION_OCR_NOT_POSSIBLE to indicate if OCR is possible.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1579000882-20246-9-git-send-email-anand.lodnoor@broadcom.com
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Anand Lodnoor <anand.lodnoor@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/megaraid/megaraid_sas_base.c   |    3 ++-
 drivers/scsi/megaraid/megaraid_sas_fusion.c |    3 ++-
 drivers/scsi/megaraid/megaraid_sas_fusion.h |    1 +
 3 files changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4109,7 +4109,8 @@ dcmd_timeout_ocr_possible(struct megasas
 	if (instance->adapter_type == MFI_SERIES)
 		return KILL_ADAPTER;
 	else if (instance->unload ||
-			test_bit(MEGASAS_FUSION_IN_RESET, &instance->reset_flags))
+			test_bit(MEGASAS_FUSION_OCR_NOT_POSSIBLE,
+				 &instance->reset_flags))
 		return IGNORE_TIMEOUT;
 	else
 		return INITIATE_OCR;
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -4212,6 +4212,7 @@ int megasas_reset_fusion(struct Scsi_Hos
 	if (instance->requestorId && !instance->skip_heartbeat_timer_del)
 		del_timer_sync(&instance->sriov_heartbeat_timer);
 	set_bit(MEGASAS_FUSION_IN_RESET, &instance->reset_flags);
+	set_bit(MEGASAS_FUSION_OCR_NOT_POSSIBLE, &instance->reset_flags);
 	atomic_set(&instance->adprecovery, MEGASAS_ADPRESET_SM_POLLING);
 	instance->instancet->disable_intr(instance);
 	megasas_sync_irqs((unsigned long)instance);
@@ -4399,7 +4400,7 @@ fail_kill_adapter:
 		atomic_set(&instance->adprecovery, MEGASAS_HBA_OPERATIONAL);
 	}
 out:
-	clear_bit(MEGASAS_FUSION_IN_RESET, &instance->reset_flags);
+	clear_bit(MEGASAS_FUSION_OCR_NOT_POSSIBLE, &instance->reset_flags);
 	mutex_unlock(&instance->reset_mutex);
 	return retval;
 }
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -100,6 +100,7 @@ enum MR_RAID_FLAGS_IO_SUB_TYPE {
 
 #define MEGASAS_FP_CMD_LEN	16
 #define MEGASAS_FUSION_IN_RESET 0
+#define MEGASAS_FUSION_OCR_NOT_POSSIBLE 1
 #define THRESHOLD_REPLY_COUNT 50
 #define RAID_1_PEER_CMDS 2
 #define JBOD_MAPS_COUNT	2


