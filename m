Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5D85126B8F
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730496AbfLSSzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:55:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:51978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729871AbfLSSzq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:55:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB27024685;
        Thu, 19 Dec 2019 18:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781745;
        bh=/5VkuBAMF0hcicJrt4OEqJzPZcmo+aSf0A05sH6ht1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jtd1qMFiyR+5OAXS9+M1bweSIjiB62oeWW0gcEYOZ2d7k63nJSzV+yBc2HUOLuA1I
         V8LW0gl5qPaRx7txfxr/p6aoHmXrboDdl1n8nLjA/RRtb4taxRZUDh8JFr7XqHLQwF
         lSsoiAnJoENUUmgoVliAGoTCCIXnZH5A5D9LiIkk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Hernandez <mhernandez@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 62/80] scsi: qla2xxx: Added support for MPI and PEP regions for ISP28XX
Date:   Thu, 19 Dec 2019 19:34:54 +0100
Message-Id: <20191219183135.337522801@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183031.278083125@linuxfoundation.org>
References: <20191219183031.278083125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Hernandez <mhernandez@marvell.com>

commit a530bf691f0e4691214562c165e6c8889dc51e57 upstream.

This patch adds support for MPI/PEP region updates which is required with
secure flash updates for ISP28XX.

Fixes: 3f006ac342c0 ("scsi: qla2xxx: Secure flash update support for ISP28XX")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20191203223657.22109-3-hmadhani@marvell.com
Signed-off-by: Michael Hernandez <mhernandez@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/qla2xxx/qla_fw.h  |    4 ++++
 drivers/scsi/qla2xxx/qla_sup.c |   27 ++++++++++++++++++++++-----
 2 files changed, 26 insertions(+), 5 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -1523,6 +1523,10 @@ struct qla_flt_header {
 #define FLT_REG_NVRAM_SEC_28XX_1	0x10F
 #define FLT_REG_NVRAM_SEC_28XX_2	0x111
 #define FLT_REG_NVRAM_SEC_28XX_3	0x113
+#define FLT_REG_MPI_PRI_28XX		0xD3
+#define FLT_REG_MPI_SEC_28XX		0xF0
+#define FLT_REG_PEP_PRI_28XX		0xD1
+#define FLT_REG_PEP_SEC_28XX		0xF1
 
 struct qla_flt_region {
 	uint16_t code;
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -2725,8 +2725,11 @@ qla28xx_write_flash_data(scsi_qla_host_t
 		ql_log(ql_log_warn + ql_dbg_verbose, vha, 0xffff,
 		    "Region %x is secure\n", region.code);
 
-		if (region.code == FLT_REG_FW ||
-		    region.code == FLT_REG_FW_SEC_27XX) {
+		switch (region.code) {
+		case FLT_REG_FW:
+		case FLT_REG_FW_SEC_27XX:
+		case FLT_REG_MPI_PRI_28XX:
+		case FLT_REG_MPI_SEC_28XX:
 			fw_array = dwptr;
 
 			/* 1st fw array */
@@ -2757,9 +2760,23 @@ qla28xx_write_flash_data(scsi_qla_host_t
 				buf_size_without_sfub += risc_size;
 				fw_array += risc_size;
 			}
-		} else {
-			ql_log(ql_log_warn + ql_dbg_verbose, vha, 0xffff,
-			    "Secure region %x not supported\n",
+			break;
+
+		case FLT_REG_PEP_PRI_28XX:
+		case FLT_REG_PEP_SEC_28XX:
+			fw_array = dwptr;
+
+			/* 1st fw array */
+			risc_size = be32_to_cpu(fw_array[3]);
+			risc_attr = be32_to_cpu(fw_array[9]);
+
+			buf_size_without_sfub = risc_size;
+			fw_array += risc_size;
+			break;
+
+		default:
+			ql_log(ql_log_warn + ql_dbg_verbose, vha,
+			    0xffff, "Secure region %x not supported\n",
 			    region.code);
 			rval = QLA_COMMAND_ERROR;
 			goto done;


