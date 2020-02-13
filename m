Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB52E15BCFC
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 11:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729526AbgBMKmW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 05:42:22 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41441 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729428AbgBMKmW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Feb 2020 05:42:22 -0500
Received: by mail-wr1-f67.google.com with SMTP id c9so6033384wrw.8
        for <stable@vger.kernel.org>; Thu, 13 Feb 2020 02:42:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=hYeg+wlRdEphQLMa6bJ+kzNI6fLLZBpv3hkhUqSkWkw=;
        b=EMKXOpr09lqzAz0uzFhSLwbJ/kmPxUJYoWcck/sqdYTr1T402w/1ELxZPbnjpoVd+G
         aunnoiWoSyUtyr7T9JzC2bcRc+i6RoZdGViGD3WFjJ2O5AGkv6H+U6CtE5Z6lyB/0/r/
         JA67EY8wx756kU67S0XoZJ6ZDE+g2KJexfQJc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=hYeg+wlRdEphQLMa6bJ+kzNI6fLLZBpv3hkhUqSkWkw=;
        b=Pp4Eh78jdPvHsyBoTu+07HeGdV9oG1Ds8J5oGjADiN2bJKh6CG83FMSvdkSvcTR00g
         bAmVZqbUMC+gXOo8K58xPPY04FNvuI5fqnlvwR9HZ+vtoe0tDKlJaoi6jAqe7RCIx0yU
         6cE1s1Lk84psBNrv5Apyk9C21FV8mLbs0GXO/1uvVVYf62LtEKl6rwbO3LXViws+C5o2
         uLfHkDtYyE+IzXarIHUPoav9r9xskcaRLAsM6Ov9dnY/G0K3/E06oE0m1zLUz3GhXPtE
         SfH/BiPoTFKsIjnktmqWCfhf82GCnsw+iRxe/tQ/IbT+XxNDODQuTW31xXiGMH8+vXSZ
         tD4A==
X-Gm-Message-State: APjAAAW6CoUWBOJ9Mxnzd6x/Z1YNspm7HSLrLKZ2dITNe09mJbbshjLJ
        OeuSm3/ymMVp6DRI9/YVu5H6MH4n6pdqaWYeghXtiYylXK9RwrBrWuffe70MdjsN/wAoaVQ2ERx
        IKjqg2iI05qYmQkRwapEaRz/uwVV0BeHDz3WxkqWZSFu/77d1gKWq9M6aS2BJLhUEMyQVm1q7rw
        ==
X-Google-Smtp-Source: APXvYqxZloHdlXqIWw8+Dpm+5B6WtDRgS6JTncSV+qbixF6dLwnuD3zMq06wDIONzHzsdh/dtQGCsw==
X-Received: by 2002:a5d:5647:: with SMTP id j7mr21067568wrw.265.1581590538063;
        Thu, 13 Feb 2020 02:42:18 -0800 (PST)
Received: from dhcp-10-123-20-32.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id h10sm2557378wml.18.2020.02.13.02.42.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Feb 2020 02:42:17 -0800 (PST)
From:   Anand Lodnoor <anand.lodnoor@broadcom.com>
To:     stable@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        kiran-kumar.kasturi@broadcom.com, sankar.patra@broadcom.com,
        sasikumar.pc@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        chandrakanth.patil@broadcom.com,
        Anand Lodnoor <anand.lodnoor@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14] scsi: megaraid_sas: Do not initiate OCR if controller is not in ready state
Date:   Thu, 13 Feb 2020 16:11:53 +0530
Message-Id: <1581590513-19568-1-git-send-email-anand.lodnoor@broadcom.com>
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
index 5775136..9b77f4e 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4109,7 +4109,8 @@ int megasas_alloc_cmds(struct megasas_instance *instance)
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
index 7be2b9e..b137212 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -4212,6 +4212,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 	if (instance->requestorId && !instance->skip_heartbeat_timer_del)
 		del_timer_sync(&instance->sriov_heartbeat_timer);
 	set_bit(MEGASAS_FUSION_IN_RESET, &instance->reset_flags);
+	set_bit(MEGASAS_FUSION_OCR_NOT_POSSIBLE, &instance->reset_flags);
 	atomic_set(&instance->adprecovery, MEGASAS_ADPRESET_SM_POLLING);
 	instance->instancet->disable_intr(instance);
 	megasas_sync_irqs((unsigned long)instance);
@@ -4399,7 +4400,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 		atomic_set(&instance->adprecovery, MEGASAS_HBA_OPERATIONAL);
 	}
 out:
-	clear_bit(MEGASAS_FUSION_IN_RESET, &instance->reset_flags);
+	clear_bit(MEGASAS_FUSION_OCR_NOT_POSSIBLE, &instance->reset_flags);
 	mutex_unlock(&instance->reset_mutex);
 	return retval;
 }
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index 7c1f7cc..40724df 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -100,6 +100,7 @@ enum MR_RAID_FLAGS_IO_SUB_TYPE {
 
 #define MEGASAS_FP_CMD_LEN	16
 #define MEGASAS_FUSION_IN_RESET 0
+#define MEGASAS_FUSION_OCR_NOT_POSSIBLE 1
 #define THRESHOLD_REPLY_COUNT 50
 #define RAID_1_PEER_CMDS 2
 #define JBOD_MAPS_COUNT	2
-- 
1.8.3.1

