Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF5A513A847
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 12:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729074AbgANLW7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 06:22:59 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33634 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728914AbgANLW7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 06:22:59 -0500
Received: by mail-wr1-f65.google.com with SMTP id b6so11795764wrq.0
        for <stable@vger.kernel.org>; Tue, 14 Jan 2020 03:22:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3eHBomyW/Wwk0va6H9jkbvlKklYJQRPgDR1v4/SFIYo=;
        b=fvuk46CjM/HAPcrEFNHc567oPALzsU8uvvLuOI7CmI5TOJRJCmBIEBh4lVAHUqAgDz
         WMiNfWOWqwBC4kc9S3AoXh7CaFmYegwWUO94Nh5HHsAcEfgsJABZG2BNWfFxozJeUzaN
         TBsEP0+ecPXOP+ezL+TpzjY/w/oGn592byV4M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3eHBomyW/Wwk0va6H9jkbvlKklYJQRPgDR1v4/SFIYo=;
        b=FpgaSp8JaOKz2ktQ1YvILCdtp0fgR/MPCJY7itv5VpvWWkqbIYesOhpVKOrx8WEYTL
         iiH6z+2z/psEnEtXl18TaWh7C3jdzTbMnGZNcz5OPZ4yau8c/CnZeZcHMj5DMtE+VC/n
         xaOBV8sYPj7ZgHYIOWgMZRICSdKNnjczg6ozbmqEMIK1qRqhIDl8gWq1g7MHRM/ChBJu
         50cGVS2XndUBO0NG4nQ/ol+a8rl70dF9mI6N2A7GUrN39wlSegcAR3fzWtrrsLvmcud5
         Pw9IAkTDB/5eOYPViRq37ZGpaGFdDaswavkdt2U7b8OFq4a6tJsDEMNKoUkwBqD+jNut
         6fTw==
X-Gm-Message-State: APjAAAU5+BQsEXXdYXyi6+0KhOybqCviZycCQxbppqH8NZp3LBYcSJsA
        rsyLMOWdm/6zROU8N70n9NIy0w==
X-Google-Smtp-Source: APXvYqw+oKm0YJPz50Z2HRWT84RSWXFytnemqoBQDWLO9LzXIE5PA5Apf83+asCtvvcVe3Iq9Hi/UQ==
X-Received: by 2002:a05:6000:160d:: with SMTP id u13mr25130484wrb.22.1579000977209;
        Tue, 14 Jan 2020 03:22:57 -0800 (PST)
Received: from dhcp-10-123-20-32.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id z21sm17638160wml.5.2020.01.14.03.22.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Jan 2020 03:22:56 -0800 (PST)
From:   Anand Lodnoor <anand.lodnoor@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        kiran-kumar.kasturi@broadcom.com, sankar.patra@broadcom.com,
        sasikumar.pc@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        chandrakanth.patil@broadcom.com,
        Anand Lodnoor <anand.lodnoor@broadcom.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 08/11] megaraid_sas: Do not initiate OCR if controller is not in ready state
Date:   Tue, 14 Jan 2020 16:51:19 +0530
Message-Id: <1579000882-20246-9-git-send-email-anand.lodnoor@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1579000882-20246-1-git-send-email-anand.lodnoor@broadcom.com>
References: <1579000882-20246-1-git-send-email-anand.lodnoor@broadcom.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Driver initiates OCR if a DCMD command times out. But there is a
deadlock if the driver attempts to invoke another OCR before the
mutex lock (reset_mutex) is released from the previous session of OCR.

This patch takes care of the above scenario using new flag
MEGASAS_FUSION_OCR_NOT_POSSIBLE to indicate if OCR is possible.

Cc: stable@vger.kernel.org
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Anand Lodnoor <anand.lodnoor@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c   | 3 ++-
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 3 ++-
 drivers/scsi/megaraid/megaraid_sas_fusion.h | 1 +
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 8bee5629..792db75 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4403,7 +4403,8 @@ int megasas_alloc_cmds(struct megasas_instance *instance)
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
index 6860fd2..8b6cc1b 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -4851,6 +4851,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 	if (instance->requestorId && !instance->skip_heartbeat_timer_del)
 		del_timer_sync(&instance->sriov_heartbeat_timer);
 	set_bit(MEGASAS_FUSION_IN_RESET, &instance->reset_flags);
+	set_bit(MEGASAS_FUSION_OCR_NOT_POSSIBLE, &instance->reset_flags);
 	atomic_set(&instance->adprecovery, MEGASAS_ADPRESET_SM_POLLING);
 	instance->instancet->disable_intr(instance);
 	megasas_sync_irqs((unsigned long)instance);
@@ -5059,7 +5060,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 	instance->skip_heartbeat_timer_del = 1;
 	retval = FAILED;
 out:
-	clear_bit(MEGASAS_FUSION_IN_RESET, &instance->reset_flags);
+	clear_bit(MEGASAS_FUSION_OCR_NOT_POSSIBLE, &instance->reset_flags);
 	mutex_unlock(&instance->reset_mutex);
 	return retval;
 }
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index 8358b68..d57ecc7 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -89,6 +89,7 @@ enum MR_RAID_FLAGS_IO_SUB_TYPE {
 
 #define MEGASAS_FP_CMD_LEN	16
 #define MEGASAS_FUSION_IN_RESET 0
+#define MEGASAS_FUSION_OCR_NOT_POSSIBLE 1
 #define RAID_1_PEER_CMDS 2
 #define JBOD_MAPS_COUNT	2
 #define MEGASAS_REDUCE_QD_COUNT 64
-- 
1.8.3.1

