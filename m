Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8545E1815F5
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 11:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728444AbgCKKhJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 06:37:09 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:32928 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbgCKKhJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Mar 2020 06:37:09 -0400
Received: by mail-pf1-f195.google.com with SMTP id n7so1095300pfn.0
        for <stable@vger.kernel.org>; Wed, 11 Mar 2020 03:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=zDAtGZZlnMl0nThiIiOP76Uq+16Zqz24GZvrNhqC2vY=;
        b=dsY+/MsBt2iIGklM4BYJHdvvl/3P5lxTQo7dEML4wIcJ5OwCA/ZT/ilZbXJBuojPHD
         que491N0rlKv/g1op+AaBWzoLHZwxeMmc/8lP+zaX7reNzfjUbzUlOES96zAsgqLN4Wu
         TbwTXyp5hpVER9ECiK0S512Vf6YDib45g7sGI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zDAtGZZlnMl0nThiIiOP76Uq+16Zqz24GZvrNhqC2vY=;
        b=tjreQZjBFiILa75hhqkGM5pW7djxc1+0U6xLDSQDGr3sn3SC6wVsDEuC2uEy9PGuAj
         g5EXVHIKx6nkHsA3tVehN1L3VQ/Qu54J95oZgJifPkqNemHhNAnodrLaSa5xwaV8jxsR
         VRRyR9k9rmcL9YRb2xTcDZ7LRGt5pgPUpX6y7B4OGTHnp4ii5QA531g8mnUYA9xzDtik
         lmxylj8/Ez2sOwnkxA8htELFpTUvoFN14toX9OmuM59BcvDDPhVAw6WOesQVDRzjOZL0
         TD2mffFLLN8OY00MLMmSPs2DW4gRA4wgaVKkZorWXcRTIrc9RatAHq72fkDg4r6Nf3Ge
         nigw==
X-Gm-Message-State: ANhLgQ1bCJ4pgMx4S/Oek6rE7cnOeE4sfOZ7TUq5kfzYknX2lez4jmba
        X+fAwuoKL44YZ0McP1tRPojm9w==
X-Google-Smtp-Source: ADFU+vvNPQ1qsX7n2U3cijoD2VYGzq2zDqlEBEbY82LByWfqG8NCc62qAiwBkAu6hBRj9M5TBs6FBg==
X-Received: by 2002:a63:82c2:: with SMTP id w185mr2331272pgd.382.1583923028194;
        Wed, 11 Mar 2020 03:37:08 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id z3sm51156004pfz.155.2020.03.11.03.37.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Mar 2020 03:37:07 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, sathya.prakash@broadcom.com,
        suganath-prabu.subramani@broadcom.com, stable@vger.kernel.org,
        amit@kernel.org, Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH] mpt3sas: Fix kernel panic observed on soft HBA unplug
Date:   Wed, 11 Mar 2020 06:36:53 -0400
Message-Id: <1583923013-3935-1-git-send-email-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Generic protection fault type kernel panic is observed when user
performs soft(ordered) HBA unplug operation while IOs are running
on drives connected to HBA.

When user performs ordered HBA removal operation then kernel calls
PCI device's .remove() call back function where driver is flushing out
all the outstanding SCSI IO commands with DID_NO_CONNECT host byte and
also un-maps sg buffers allocated for these IO commands.
But in the ordered HBA removal case (unlike of real HBA hot unplug)
HBA device is still alive and hence HBA hardware is performing the
DMA operations to those buffers on the system memory which are already
unmapped while flushing out the outstanding SCSI IO commands
and this leads to Kernel panic.

Fix:
Don't flush out the outstanding IOs from .remove() path in case of
ordered HBA removal since HBA will be still alive in this case and
it can complete the outstanding IOs. Flush out the outstanding IOs
only in case physical HBA hot unplug where their won't be any
communication with the HBA.

Cc: stable@vger.kernel.org
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 778d5e6..04a40af 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -9908,8 +9908,8 @@ static void scsih_remove(struct pci_dev *pdev)
 
 	ioc->remove_host = 1;
 
-	mpt3sas_wait_for_commands_to_complete(ioc);
-	_scsih_flush_running_cmds(ioc);
+	if (!pci_device_is_present(pdev))
+		_scsih_flush_running_cmds(ioc);
 
 	_scsih_fw_event_cleanup_queue(ioc);
 
@@ -9992,8 +9992,8 @@ static void scsih_remove(struct pci_dev *pdev)
 
 	ioc->remove_host = 1;
 
-	mpt3sas_wait_for_commands_to_complete(ioc);
-	_scsih_flush_running_cmds(ioc);
+	if (!pci_device_is_present(pdev))
+		_scsih_flush_running_cmds(ioc);
 
 	_scsih_fw_event_cleanup_queue(ioc);
 
-- 
1.8.3.1

