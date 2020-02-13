Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C167E15BCF8
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 11:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729466AbgBMKlG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 05:41:06 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43620 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729428AbgBMKlG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Feb 2020 05:41:06 -0500
Received: by mail-wr1-f66.google.com with SMTP id r11so5992555wrq.10
        for <stable@vger.kernel.org>; Thu, 13 Feb 2020 02:41:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=vSkTzaQA4831ATh6BRKstnf1knElx6iw4+X08WANkTI=;
        b=OfWHTqvs3h/rvonYxYIICe9cu4gsw0+chQ/Rgo7Cei1lR9zlQlHCSFpNlkjjtMJotb
         UHS992dpl4NG0KVLMfAQeIpycGocfDJ3ZT7iUmXKGxlkneyFYedaQS8xa6j5ziCQ2HvT
         cIf49f+jdBBOvcDdEHltgdCMk/Mvj6YhbbYTk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=vSkTzaQA4831ATh6BRKstnf1knElx6iw4+X08WANkTI=;
        b=KkeCiCKRRU3qOF1/RjMWxKBCEYFBePDBbm3rZs7Gu7IptBcQot7JqU7PMCeMhqiiX3
         3jHvjeNBuOdiWuE958z4/ZdT1nSW+l+3tVhHcYLLHTzxr595QfkFSIjZtYXGd7ngNGnO
         myobpH925LBRv/rl51KGMee6ByfgeQ5UIWVZl9INtKHQ5nLlbvtsilkpBtl8TGWav+bt
         KYOLaMNDQBfi5avl1ctRhzAvvHxyZHGitz1VKkFpKUl+2pqh50OzXM3oSWLXHfeIjr66
         SK37PiFyPQQ06ZTwL/ZjP87rl5C7N3PWkkGt5HXrm/MDV30RntxZEKINrML0Zh8+bpIJ
         uwZQ==
X-Gm-Message-State: APjAAAWY8B+DdsoSk38GKW/MvvSTC9zIgt1I4VGR706wSFiFjkSC/xD1
        wKK4GOZeGO/o9QPvTPrn7juwUNYweZkvhYI5eRjOFxKs7hIdbQLQtgDB72Osw3NBU7eeq0KJPoE
        GAKJJzwth2nZ9v7XAb3wEVMEdKgWkffQF3SPBUJ3NiM+R4PZFsEDoFA8Y+DsTRke5cLuquTyV8u
        Mg
X-Google-Smtp-Source: APXvYqydTqjiwkORXjqdch5Uyuq12cC+Fhq24cnHBq2KTZhUrepOpggIX4EypXMiwHYYZqrrFqv6oA==
X-Received: by 2002:a5d:6406:: with SMTP id z6mr20915035wru.294.1581590462940;
        Thu, 13 Feb 2020 02:41:02 -0800 (PST)
Received: from dhcp-10-123-20-32.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id j14sm2442682wrn.32.2020.02.13.02.40.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Feb 2020 02:41:02 -0800 (PST)
From:   Anand Lodnoor <anand.lodnoor@broadcom.com>
To:     stable@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        kiran-kumar.kasturi@broadcom.com, sankar.patra@broadcom.com,
        sasikumar.pc@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        chandrakanth.patil@broadcom.com,
        Anand Lodnoor <anand.lodnoor@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9] scsi: megaraid_sas: Do not initiate OCR if controller is not in ready state
Date:   Thu, 13 Feb 2020 16:10:35 +0530
Message-Id: <1581590435-19519-1-git-send-email-anand.lodnoor@broadcom.com>
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
index c5cc002..23848bb 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3978,7 +3978,8 @@ int megasas_alloc_cmds(struct megasas_instance *instance)
 	if (!instance->ctrl_context)
 		return KILL_ADAPTER;
 	else if (instance->unload ||
-			test_bit(MEGASAS_FUSION_IN_RESET, &instance->reset_flags))
+			test_bit(MEGASAS_FUSION_OCR_NOT_POSSIBLE,
+				 &instance->reset_flags))
 		return IGNORE_TIMEOUT;
 	else
 		return INITIATE_OCR;
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index fe1a209..874e5a7 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3438,6 +3438,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 	if (instance->requestorId && !instance->skip_heartbeat_timer_del)
 		del_timer_sync(&instance->sriov_heartbeat_timer);
 	set_bit(MEGASAS_FUSION_IN_RESET, &instance->reset_flags);
+	set_bit(MEGASAS_FUSION_OCR_NOT_POSSIBLE, &instance->reset_flags);
 	atomic_set(&instance->adprecovery, MEGASAS_ADPRESET_SM_POLLING);
 	instance->instancet->disable_intr(instance);
 	msleep(1000);
@@ -3594,7 +3595,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 		atomic_set(&instance->adprecovery, MEGASAS_HBA_OPERATIONAL);
 	}
 out:
-	clear_bit(MEGASAS_FUSION_IN_RESET, &instance->reset_flags);
+	clear_bit(MEGASAS_FUSION_OCR_NOT_POSSIBLE, &instance->reset_flags);
 	mutex_unlock(&instance->reset_mutex);
 	return retval;
 }
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index e3bee04..034653d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -93,6 +93,7 @@ enum MR_RAID_FLAGS_IO_SUB_TYPE {
 
 #define MEGASAS_FP_CMD_LEN	16
 #define MEGASAS_FUSION_IN_RESET 0
+#define MEGASAS_FUSION_OCR_NOT_POSSIBLE 1
 #define THRESHOLD_REPLY_COUNT 50
 #define JBOD_MAPS_COUNT	2
 
-- 
1.8.3.1

