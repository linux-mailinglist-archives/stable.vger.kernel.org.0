Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA45182B34
	for <lists+stable@lfdr.de>; Thu, 12 Mar 2020 09:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbgCLI3K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Mar 2020 04:29:10 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38088 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbgCLI3K (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Mar 2020 04:29:10 -0400
Received: by mail-wm1-f65.google.com with SMTP id h83so1662141wmf.3
        for <stable@vger.kernel.org>; Thu, 12 Mar 2020 01:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=6Gi/OdaICzktDVYOdA4WP8Yxk5qHZ7ClcZn2IAV7MBI=;
        b=R8GBg7KQD97Ni6hoo9Ft95VutYKqPZEHhOOu/KUGDJqTnNbNHVzEDj2xWS9gZtGLNU
         MWQD5HHpVjDK92t7XTeGeYdeAdJt8nmHEPZof4iHhPJyhAx6j6UJ3KSULc2Mpo3XNWGK
         6xgMxS6IWF6NNH/BvM1BdvCrKfTpMfyN3GuWA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6Gi/OdaICzktDVYOdA4WP8Yxk5qHZ7ClcZn2IAV7MBI=;
        b=eONRtUJ1JSOb5X6C+OA/KRsNskmIaLbveBwhnk28UuSaRxspt28IT1+jwwptIcC3Es
         YiE1Hp/vZgGKHQxp9uEzzYPnHDyshFK3DOpIHX0U+NSglvC2nZSX39BYxFoA3bGgPcjs
         G4DiCQJuEiu6x05GEJx5IHUvmqEyC6LM5objo7hGqHm6C7D+XWqm37tfThXn81Tf9aOJ
         93cE1jP4c1qCsYHri+8dLDvdtLbKdC6soy/D629hkGk1E64zC0OnlcoAPusNSdwGGEr8
         lMx9P+xJIbvUQwZyMKnWgfLDVTZPbYznkG5wa8ys01k0JHvagFV7nkKgP8lhqURIQVV+
         HRUg==
X-Gm-Message-State: ANhLgQ0HX/vpfpGutugY9fn4W4MX6/I3F/covlryuSS0faXJfZGIR4wd
        Z57Au5Ld+RbzXT6aNu1tbfheUw==
X-Google-Smtp-Source: ADFU+vtCHQUivEzeVNBg44c15fYfAGGyq+UGBrf9KvX6uDgska35BTvtGoBYddK6mC5VuykR0oGPkw==
X-Received: by 2002:a7b:cc98:: with SMTP id p24mr3384547wma.29.1584001748507;
        Thu, 12 Mar 2020 01:29:08 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id v15sm7803460wrm.32.2020.03.12.01.29.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Mar 2020 01:29:07 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, sathya.prakash@broadcom.com,
        suganath-prabu.subramani@broadcom.com, stable@vger.kernel.org,
        amit@kernel.org, Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH v1] mpt3sas: Fix kernel panic observed on soft HBA unplug
Date:   Thu, 12 Mar 2020 04:28:55 -0400
Message-Id: <1584001735-22719-1-git-send-email-sreekanth.reddy@broadcom.com>
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

This bug got introduced from below commit,
commit c666d3be99c000bb889a33353e9be0fa5808d3de
("scsi: mpt3sas: wait for and flush running commands on shutdown/unload")

Fix:
Don't flush out the outstanding IOs from .remove() path in case of
ordered HBA removal since HBA will be still alive in this case and
it can complete the outstanding IOs. Flush out the outstanding IOs
only in case physical HBA hot unplug where their won't be any
communication with the HBA.

During shutdown also it is possible that HBA hardware can perform
DMA operations on those outstanding IO buffers which are completed
with DID_NO_CONNECT by the driver from .shutdown(). So same above fix
is applied in shutdown path as well.

Cc: stable@vger.kernel.org
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
v1:
    Update the patch description.

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

