Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83EBC195472
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 10:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbgC0JxJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Mar 2020 05:53:09 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45573 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgC0JxJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Mar 2020 05:53:09 -0400
Received: by mail-wr1-f65.google.com with SMTP id t7so10566307wrw.12
        for <stable@vger.kernel.org>; Fri, 27 Mar 2020 02:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=nGE3jUS7mJMmKSh14Ouz5xS6ONRyETt8E6L1noBcP0c=;
        b=X3vePnOg3dl+w4Ufwf1TdXU0v03Y1Vy+KhHZQbkdEfpAVsnmreDfPcPnK3KGGEqTSF
         OEwQ/PQncRyyOw32YvyMj1+176NgebxLijedP/1/gL3ZAqRDWgJJ1tgUxIvM6kNCoQ3h
         SXTscbXwzGxK0YAJ5dAy4jwfUcu+Z045ryFmY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=nGE3jUS7mJMmKSh14Ouz5xS6ONRyETt8E6L1noBcP0c=;
        b=cEz0GgxVorob9piyA5YxCuCkGyWFViyvEJ7RVZU53xBrdZcfPv2cGHECVqiABoGISO
         93DwVGI5ZxVFr4OaIs7nOnPcPQr8SPEURDnBjadXB9bCieJJkKy9fSk9Som0mAUS8ACs
         Ca2LEgpHYDK4DFZjHtO2PA1ozA4fgbHsOmpIQ8NfW+Ka9t1fOqO/xgnChGoXt0Mpevvi
         LoM46wsFr+G/EEFWY833QN0Guv4idq8u5M/P8HEQhE/PRh7JvLQMcvtkOWv/qISHtA7Q
         G1pyo9mBmtwuw1sV4D2FuMEZ3vN8cJatuYotjyDBVzBllqRLju2xm89Ga8DDFdbfHlNP
         6CJg==
X-Gm-Message-State: ANhLgQ3SUPKNu9uey6cn/Tf2hmgOYHETLHMChzSqp332KAcfidTglW4M
        Vtg5lNvT10QtRRK8m6MJd9TjDA==
X-Google-Smtp-Source: ADFU+vth/i6ss9n9Xc8K7b8bZ/4r30Eq+N8qC8hdBzWPhOWRXrIH5ocBOgjwEX5rgyx81u4qrD9pVA==
X-Received: by 2002:adf:9526:: with SMTP id 35mr15031929wrs.164.1585302787996;
        Fri, 27 Mar 2020 02:53:07 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id b187sm7436029wmb.42.2020.03.27.02.53.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 27 Mar 2020 02:53:07 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, sathya.prakash@broadcom.com,
        suganath-prabu.subramani@broadcom.com, stable@vger.kernel.org,
        amit@kernel.org, Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH v2] mpt3sas: Fix kernel panic observed on soft HBA unplug
Date:   Fri, 27 Mar 2020 05:52:43 -0400
Message-Id: <1585302763-23007-1-git-send-email-sreekanth.reddy@broadcom.com>
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
only in case of 'physical HBA hot unplug' where their won't be any
communication with the HBA.

During shutdown also it is possible that HBA hardware can perform
DMA operations on those outstanding IO buffers which are completed
with DID_NO_CONNECT by the driver from .shutdown(). So same above fix
is applied in shutdown path as well.

In Summary it is always safe to drop the outstanding commands when HBA
is inaccessible. Such as when permanent PCI failure happens, HBA is
in non-operational state and when someone does the real HBA hot unplug
operation. Since driver knows that HBA is inaccessible during these
cases, so it is always safe to drop the outstanding commands instead
of waiting for SCSI error recovery to kicks start and clear these
outstanding commands.

Cc: stable@vger.kernel.org #v4.14.174+
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
v1:
    Update the patch description.
v2:
    Update the patch description by adding summary paragraph.

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

