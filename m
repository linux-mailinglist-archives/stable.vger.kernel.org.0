Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6822A0B8F
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 17:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbgJ3Qp3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 12:45:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:58282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726063AbgJ3Qp3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Oct 2020 12:45:29 -0400
Received: from localhost.localdomain (HSI-KBW-46-223-126-90.hsi.kabel-badenwuerttemberg.de [46.223.126.90])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9313820756;
        Fri, 30 Oct 2020 16:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604076328;
        bh=TJe5PncsoCY6sMxrZnBZwktnNCtq0wI8fPX7anNMPFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MePavGne+C4z1ea1qvc/6xxO6fdpqM6LNmpMPGnPJi9yV5jxBasOYaDKB1jY5sxX0
         tmWQky1L5hfcwgdactK/SRRVGHjYMFxJ1gw5Vs7aR0H/F+U3okfzVzLrXlIOs/zUaY
         2zMRkEFRXDm7ND0W4GN+aYBWmIlJ2u2lsffXmH4M=
From:   Arnd Bergmann <arnd@kernel.org>
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Anand Lodnoor <anand.lodnoor@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, megaraidlinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/3] scsi: megaraid_sas: check user-provided offsets
Date:   Fri, 30 Oct 2020 17:44:20 +0100
Message-Id: <20201030164450.1253641-2-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201030164450.1253641-1-arnd@kernel.org>
References: <20201030164450.1253641-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

It sounds unwise to let user space pass an unchecked 32-bit
offset into a kernel structure in an ioctl. This is an unsigned
variable, so checking the upper bound for the size of the structure
it points into is sufficient to avoid data corruption, but as
the pointer might also be unaligned, it has to be written carefully
as well.

While I stumbled over this problem by reading the code, I did not
continue checking the function for further problems like it.

Cc: <stable@vger.kernel.org> # v2.6.15+
Fixes: c4a3e0a529ab ("[SCSI] MegaRAID SAS RAID: new driver")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 41cd66fc7d81..b1b9a8823c8c 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -8134,7 +8134,7 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 	int error = 0, i;
 	void *sense = NULL;
 	dma_addr_t sense_handle;
-	unsigned long *sense_ptr;
+	void *sense_ptr;
 	u32 opcode = 0;
 	int ret = DCMD_SUCCESS;
 
@@ -8257,6 +8257,12 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 	}
 
 	if (ioc->sense_len) {
+		/* make sure the pointer is part of the frame */
+		if (ioc->sense_off > (sizeof(union megasas_frame) - sizeof(__le64))) {
+			error = -EINVAL;
+			goto out;
+		}
+
 		sense = dma_alloc_coherent(&instance->pdev->dev, ioc->sense_len,
 					     &sense_handle, GFP_KERNEL);
 		if (!sense) {
@@ -8264,12 +8270,11 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 			goto out;
 		}
 
-		sense_ptr =
-		(unsigned long *) ((unsigned long)cmd->frame + ioc->sense_off);
+		sense_ptr = (void *)cmd->frame + ioc->sense_off;
 		if (instance->consistent_mask_64bit)
-			*sense_ptr = cpu_to_le64(sense_handle);
+			put_unaligned_le64(sense_handle, sense_ptr);
 		else
-			*sense_ptr = cpu_to_le32(sense_handle);
+			put_unaligned_le32(sense_handle, sense_ptr);
 	}
 
 	/*
-- 
2.27.0

