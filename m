Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35EFB26FC5F
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 14:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgIRMUv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Sep 2020 08:20:51 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:40007 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726260AbgIRMUv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Sep 2020 08:20:51 -0400
X-Greylist: delayed 310 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Sep 2020 08:20:50 EDT
Received: from threadripper.lan ([149.172.98.151]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MhlCa-1kwiqN2nei-00dnUh; Fri, 18 Sep 2020 14:15:27 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, anand.lodnoor@broadcom.com,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 2/3] scsi: megaraid_sas: check user-provided offsets
Date:   Fri, 18 Sep 2020 14:15:22 +0200
Message-Id: <20200918121522.1466028-1-arnd@arndb.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200918120955.1465510-1-arnd@arndb.de>
References: <20200918120955.1465510-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:6kJPcwuHge9uT864Zf5TyvhQnlmxeK+RpOYT34mVoK7SAncOfq9
 1wvhRh03/TO74JK8VdAlLNISWQ5JFsbrhhGN08krYQ5ip4disf1Dbd4f2biDPp+wGScYwrk
 2eqIMN9aKY5vKPnBcr335Ny6XSIVuPsdE2ZYCeV/dH1z1t5zLmiLylvjF/EJwebLxJi7oyz
 c/wyKFRfXQ+XgvvduDU/Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:kPSrEyv5snI=:inbnGO0kfNro0y470ipxfy
 G38lYzALukLIy2LVz2zLpPm9wn2MNaRdJczGmz+HshZFtsDk3gJUqF1ojZccNY885pAM5Xa+H
 eCa5EM1SmNEtEiN+FTNkwqs3ry5zkzJqro+D2EvVo9w8zZW7oeaQVb4dtr0pROEwab/JseALK
 N7o2i8X/o1ljiCuc31xVisx/d3u89wpb6z0lqLeeg4j1n9rD1dO8M62a5PSNtKMSXk5j3GrUF
 2L1FQvdiI7y0tICrgXjT/gbi4uO0hx/rBOdpdRed8bMaZiAccC8roSneVXtdpOcNohoWT6aiq
 CIJgh7laPwI5esdSyExwScCETEOtY2qAYyHTvfS2D1Wt1Gnpmc7L32BUNLGVhhCtVvSmfn9/v
 0ygkQAjPUo0cN1gK/T6y5XbbJ7vaGPN045NG7A2p2slLsSSzPzMTb8QiGjee1PdsZNLgYIMKA
 az6pmsYBdDswyE2RS9xqK4GJwRjiow1i9LOMvhdt+GormNd8/EH35O2r9gSItNeS9R/HvqMIK
 DSO+g2YtgivXBAp4sRjom69gc4KSYq5YEEaUjdvxmOs5NlJRR2qLGrTMaLxGtdMnkw62RVzF3
 K/NVGStY+Xx0ltNkz/ixPojj04IX6RaPw0QIL+zINVIUP+zjlXEFVKUzw1G8WvcU8ZekzTwIV
 WpT26pvKgkBePVQJIjIKG8EVfn7i+mZgfsyVMRSV2LMVVOcrYy0QbZCxoiuF5zN6CV2KMrJ5K
 V2h03du9yzW3iRdtGYcLS27xSInLlSQP6TDZ6xjHphuFM/SPG/TL6YFOM+8EcRklrRa+6kJ0P
 jr8hEiFYlp4HioeiBPLi8Jw0YjErSkyDUaJT+aaSuszrLygJZHdJc7GFaDOZdZatn+8gGjL
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

Cc: <stable@vger.kernel.org> # v2.6.15+
Fixes: c4a3e0a529ab ("[SCSI] MegaRAID SAS RAID: new driver")
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

