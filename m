Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43B2B2E399B
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388906AbgL1NZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:25:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:54044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388902AbgL1NZ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:25:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF9F220719;
        Mon, 28 Dec 2020 13:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161885;
        bh=6JE0UNhSRbQ5lIXyrZXz7GwSnXiv+R1sJx4VaR0Fduk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E1J6TdSD0SA1HLcmzkxoCyqr3g80TuNdXT2kt6cz6g1SS+YiNfL5XuVIhaDal683q
         /8n+8tA3w86PXC3nNKXQspiBRVKXsLZnUljdret5kWDQVR6Qh+oaW354zXN4h8/jpb
         ygQtlsaRd/7EZikZjIVaQS23jaYcNGoSuMTmKEu4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Arnd Bergmann <arnd@arndb.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.19 088/346] scsi: megaraid_sas: Check user-provided offsets
Date:   Mon, 28 Dec 2020 13:46:47 +0100
Message-Id: <20201228124924.055088871@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 381d34e376e3d9d27730fda8a0e870600e6c8196 upstream.

It sounds unwise to let user space pass an unchecked 32-bit offset into a
kernel structure in an ioctl. This is an unsigned variable, so checking the
upper bound for the size of the structure it points into is sufficient to
avoid data corruption, but as the pointer might also be unaligned, it has
to be written carefully as well.

While I stumbled over this problem by reading the code, I did not continue
checking the function for further problems like it.

Link: https://lore.kernel.org/r/20201030164450.1253641-2-arnd@kernel.org
Fixes: c4a3e0a529ab ("[SCSI] MegaRAID SAS RAID: new driver")
Cc: <stable@vger.kernel.org> # v2.6.15+
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/megaraid/megaraid_sas_base.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -7192,7 +7192,7 @@ megasas_mgmt_fw_ioctl(struct megasas_ins
 	int error = 0, i;
 	void *sense = NULL;
 	dma_addr_t sense_handle;
-	unsigned long *sense_ptr;
+	void *sense_ptr;
 	u32 opcode = 0;
 
 	memset(kbuff_arr, 0, sizeof(kbuff_arr));
@@ -7309,6 +7309,13 @@ megasas_mgmt_fw_ioctl(struct megasas_ins
 	}
 
 	if (ioc->sense_len) {
+		/* make sure the pointer is part of the frame */
+		if (ioc->sense_off >
+		    (sizeof(union megasas_frame) - sizeof(__le64))) {
+			error = -EINVAL;
+			goto out;
+		}
+
 		sense = dma_alloc_coherent(&instance->pdev->dev, ioc->sense_len,
 					     &sense_handle, GFP_KERNEL);
 		if (!sense) {
@@ -7316,12 +7323,11 @@ megasas_mgmt_fw_ioctl(struct megasas_ins
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


