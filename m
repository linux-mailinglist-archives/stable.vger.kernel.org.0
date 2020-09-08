Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A41552621FE
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 23:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729251AbgIHViI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 17:38:08 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:48247 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728647AbgIHViG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 17:38:06 -0400
Received: from threadripper.lan ([149.172.98.151]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MYcy3-1k1cR223AB-00Vdt2; Tue, 08 Sep 2020 23:37:51 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     hch@infradead.org, Arnd Bergmann <arnd@arndb.de>,
        stable@vger.kernel.org, Anand Lodnoor <anand.lodnoor@broadcom.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, megaraidlinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] scsi: megaraid_sas: check user-provided offsets
Date:   Tue,  8 Sep 2020 23:36:22 +0200
Message-Id: <20200908213715.3553098-2-arnd@arndb.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200908213715.3553098-1-arnd@arndb.de>
References: <20200908213715.3553098-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:ySbOIHgYtcPCmDgKFJWQFKZzEpToys/t268vTJCmMrSGnITz77V
 xl5OAKtcncF9BqiN5rvTw8tDPiLZYdRujzLHGB3QOrcmuo53qW/gJlHNEKphYn0nYEAXhPt
 wpToVMv/Hyxv9/DTHreJq0bmwBQYh7+jRsM64wZyVdDwgI9bJDS3FXlC0d2H6XnCCEwTBFq
 TIT3+6Lq7J3BhphtiWgmA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Yd64zGE+X4E=:xdJ2yudVuGKJoDcfhgjFlS
 6vAp1av9q/HZUaGSmDDq2yVfr/RppdX2z8N6ZJ5lY2HgBs/5B6bYzlDL9TfTglgoM8utkS5ri
 LySDmoFHheBCtm9M8k4/ooxgV88XhwSikIF2dp9EA+D7I24mnn8Tt0/WjBhW06KDH9hggWY6Y
 +YkkyIOwgyECscXQTgnXQ1zwdtj9JmcViO/If2siZI8LJ7STwkvubJNV8alGmW6N9JQAebxyi
 +PJQcXFP3iUst6slq7UEpbuuVUwtJSs6LcfsGYi1N3CGgb8QGpALMxT9vfPnG94OTkpE+JIsT
 Av4GT0xdy67csPFsRqXoTlPxX2qLsyTptj4ytlrClRvlvf7EYKH4v1SE/yNw8ziCGovE0/Awv
 EIpcsSLVZMWrK8ZnFlPyEUeAnSjb0CO5QmBijC18tXh1HY8q5JCZupbYoqwx5b/gZpLrm10iV
 zQ+Qg5sA0ROBOHPVY8TeTXp8e2yzxacvkvW84pc0lLRiNxOVQlSphhS8thj4vIiq748FVpRYy
 /QI99VdO0M18FPyuFo76jTH9wy2KjsFQ7KZgm+UL/EmK6x56uZU6nUG6s06seNPMihd9iFPxZ
 w3UPXEcGq8qjLYsffUOUdJHGH0NvYYOr/YkbfySXLOs5FUWTufkFHSYB/5/RtSdynotBKJdHI
 Dz3++XKwS4GU8ynCnIBshzjCQR40yhThSfWSj6v81PLN+YqFgH85OtfJ5TOYB38i7aVy0UIzz
 kBRhA6g6GAaxJdkgpuDiGuor938PcPxaEnF1afRNuTLLoN3E4652cGMNWwTQU1u4Ia4fVPIYu
 xJTKNZTzRbWC78+oHOTfSNqumIpv1BFE3vb6Gnb2HUj21/jE51eWSexkqjNdiEbbguAFvvf
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It sounds unwise to let user space pass an unchecked 32-bit
offset into a kernel structure in an ioctl. This is an unsigned
variable, so checking the upper bound for the size of the structure
it points into is sufficient to avoid data corruption, but as
the pointer might also be unaligned, it has to be written carefully
as well.

While I stumbled over this problem by reading the code, I did not
continue checking the function for further problems like it.

Cc: stable@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 861f7140f52e..c3de69f3bee8 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -8095,7 +8095,7 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 	int error = 0, i;
 	void *sense = NULL;
 	dma_addr_t sense_handle;
-	unsigned long *sense_ptr;
+	void *sense_ptr;
 	u32 opcode = 0;
 	int ret = DCMD_SUCCESS;
 
@@ -8218,6 +8218,12 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
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
@@ -8225,12 +8231,11 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
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

