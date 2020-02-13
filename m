Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D41E115BCFD
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 11:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729544AbgBMKn0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 05:43:26 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44282 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729428AbgBMKn0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Feb 2020 05:43:26 -0500
Received: by mail-wr1-f68.google.com with SMTP id m16so6007846wrx.11
        for <stable@vger.kernel.org>; Thu, 13 Feb 2020 02:43:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=fr6xt7KUVPxc0Yax/tNFOtFFN5TEp4wbvrEHmeSpuz8=;
        b=Fp0PQ95pVY88cb+1XJ7qg29h14ZU0EiYaV0kVvv0zt+heEHMWxbRjq2Fy+vnaLv3su
         w+vILsjYOjY9PzWduLFmT94YM2RPFMyP2W6cM31wPyTRAAC0d+DgPBp5yRM0KjYlrDxk
         Xwk/CbvJw3dQBXP8qgmydEq8RuB5b5SjYNPis=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=fr6xt7KUVPxc0Yax/tNFOtFFN5TEp4wbvrEHmeSpuz8=;
        b=b+Dyt0hOn0RQoblM9W/nPOTFBTBW2i7jzSTy2/D7UPDFDhdOe51s6Jiy6NrBsbSeoz
         5qfcKkULW8AcUKDjh9Hc2gJL8yzbbHpAmzm/+UmdaWM8gdTDAb5DV4WpfR9EOwwVlLfX
         WjtGdvW7XDkPT5CvgPnMxJAR9s/libV34DV5bpdvod2nIXi7vdrdJGnX1ZUcHS/TFrVi
         IVLYGAmHHWdiIkf5Mw20CYNtA/ZIJeBbwf4SL38aFHOr8zJQZ7nZgF0PRY5EE2Kaa/5V
         KDuwI2nXWhIFT7MeBEcERsJlhsPbZRKUQ8HEF8UFlmoli5kbnfT1ZIgX2uOJxDIMNLSN
         5TnA==
X-Gm-Message-State: APjAAAUksBfLUJ52dU+up7hbKUiAInFl7HEoqYiUex4XuN8epmmdoQxw
        vBlDpe/Df4yqVdELKOf8nCcsrDF3vjEbB1moNYOOicnwUl9Cl5t5GpdEcdQcEl+yiZu1LPdw4cE
        eNxGmfV+7XLPuzu/5yNg9grSMCxiqdLiWdkPIyYql+PJWlP8LR40/FcWe+dbxOveK5h+7C7L1aw
        ==
X-Google-Smtp-Source: APXvYqxrX0m2wQE7bqxbgAvb2VFbAF0cRRrN4jBKsz1kSvZ2yRgz363hLzg205SmKpcwI8chNa8M1w==
X-Received: by 2002:adf:c3d0:: with SMTP id d16mr20183916wrg.376.1581590603219;
        Thu, 13 Feb 2020 02:43:23 -0800 (PST)
Received: from dhcp-10-123-20-32.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d13sm2333935wrc.64.2020.02.13.02.43.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Feb 2020 02:43:22 -0800 (PST)
From:   Anand Lodnoor <anand.lodnoor@broadcom.com>
To:     stable@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        kiran-kumar.kasturi@broadcom.com, sankar.patra@broadcom.com,
        sasikumar.pc@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        chandrakanth.patil@broadcom.com,
        Anand Lodnoor <anand.lodnoor@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19] scsi: megaraid_sas: Do not initiate OCR if controller is not in ready state
Date:   Thu, 13 Feb 2020 16:12:58 +0530
Message-Id: <1581590578-19615-1-git-send-email-anand.lodnoor@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 6d7537270e3283b92f9b327da9d58a4de40fe8d0 upstream.

Driver initiates OCR if a DCMD command times out. But there is a
deadlock if the driver attempts to invoke another OCR before the
mutex lock (reset_mutex) is released from the previous session of OCR.

This patch takes care of the above scenario using new flag
MEGASAS_FUSION_OCR_NOT_POSSIBLE to indicate if OCR is possible.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1579000882-20246-9-git-send-email-anand.lodnoor@broadcom.com
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Anand Lodnoor <anand.lodnoor@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/megaraid/megaraid_sas_base.c   | 3 ++-
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 3 ++-
 drivers/scsi/megaraid/megaraid_sas_fusion.h | 1 +
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 2f31d26..a2da200 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4177,7 +4177,8 @@ int megasas_alloc_cmds(struct megasas_instance *instance)
 	if (instance->adapter_type == MFI_SERIES)
 		return KILL_ADAPTER;
 	else if (instance->unload ||
-			test_bit(MEGASAS_FUSION_IN_RESET, &instance->reset_flags))
+			test_bit(MEGASAS_FUSION_OCR_NOT_POSSIBLE,
+				 &instance->reset_flags))
 		return IGNORE_TIMEOUT;
 	else
 		return INITIATE_OCR;
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index f45c54f..b094a4e 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -4558,6 +4558,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 	if (instance->requestorId && !instance->skip_heartbeat_timer_del)
 		del_timer_sync(&instance->sriov_heartbeat_timer);
 	set_bit(MEGASAS_FUSION_IN_RESET, &instance->reset_flags);
+	set_bit(MEGASAS_FUSION_OCR_NOT_POSSIBLE, &instance->reset_flags);
 	atomic_set(&instance->adprecovery, MEGASAS_ADPRESET_SM_POLLING);
 	instance->instancet->disable_intr(instance);
 	megasas_sync_irqs((unsigned long)instance);
@@ -4747,7 +4748,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 		atomic_set(&instance->adprecovery, MEGASAS_HBA_OPERATIONAL);
 	}
 out:
-	clear_bit(MEGASAS_FUSION_IN_RESET, &instance->reset_flags);
+	clear_bit(MEGASAS_FUSION_OCR_NOT_POSSIBLE, &instance->reset_flags);
 	mutex_unlock(&instance->reset_mutex);
 	return retval;
 }
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index 8e5ebee..df7bbd0 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -102,6 +102,7 @@ enum MR_RAID_FLAGS_IO_SUB_TYPE {
 
 #define MEGASAS_FP_CMD_LEN	16
 #define MEGASAS_FUSION_IN_RESET 0
+#define MEGASAS_FUSION_OCR_NOT_POSSIBLE 1
 #define THRESHOLD_REPLY_COUNT 50
 #define RAID_1_PEER_CMDS 2
 #define JBOD_MAPS_COUNT	2
-- 
1.8.3.1

