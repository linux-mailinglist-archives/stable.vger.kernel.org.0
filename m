Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C427E15ED39
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390451AbgBNQGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:06:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:56986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390445AbgBNQGc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:06:32 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF8942067D;
        Fri, 14 Feb 2020 16:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696391;
        bh=0ClC5Ce9A0hpCTejMRmvsxMFVgbMtAAuKwnE4q/+jSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WsTx5SyNNUciTSpmUE11HsBYDl3nnsZlyzA6Rjof93uhYiYfPUP5cJc5+LrYdEQxD
         6iGRJNO5h21AGrWAI5JPSg7LsPxSxRG1Rx7z6Y5zmQVBpq9dhMt4rRQ+V9BkI/Gv1m
         iQ2a1ED7/wpmzFMcY0Wc+S9RkZADwZmPV031Kq6g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 217/459] scsi: lpfc: Fix: Rework setting of fdmi symbolic node name registration
Date:   Fri, 14 Feb 2020 10:57:47 -0500
Message-Id: <20200214160149.11681-217-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit df9166bfa7750bade5737ffc91fbd432e0354442 ]

This patch reworks the fdmi symbolic node name data for the following two
issues:

 - Correcting extraneous periods following the DV and HN fdmi data fields.

 - Avoiding buffer overflow issues when formatting the data.

The fix to the fist issue is to just remove the characters.

The fix to the second issue has all data being staged in temporary storage
before being moved to the real buffer.

Link: https://lore.kernel.org/r/20191218235808.31922-3-jsmart2021@gmail.com
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_ct.c | 42 +++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index f883fac2d2b1d..f81d1453eefbd 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1477,33 +1477,35 @@ int
 lpfc_vport_symbolic_node_name(struct lpfc_vport *vport, char *symbol,
 	size_t size)
 {
-	char fwrev[FW_REV_STR_SIZE];
-	int n;
+	char fwrev[FW_REV_STR_SIZE] = {0};
+	char tmp[MAXHOSTNAMELEN] = {0};
 
-	lpfc_decode_firmware_rev(vport->phba, fwrev, 0);
+	memset(symbol, 0, size);
 
-	n = scnprintf(symbol, size, "Emulex %s", vport->phba->ModelName);
-	if (size < n)
-		return n;
+	scnprintf(tmp, sizeof(tmp), "Emulex %s", vport->phba->ModelName);
+	if (strlcat(symbol, tmp, size) >= size)
+		goto buffer_done;
 
-	n += scnprintf(symbol + n, size - n, " FV%s", fwrev);
-	if (size < n)
-		return n;
+	lpfc_decode_firmware_rev(vport->phba, fwrev, 0);
+	scnprintf(tmp, sizeof(tmp), " FV%s", fwrev);
+	if (strlcat(symbol, tmp, size) >= size)
+		goto buffer_done;
 
-	n += scnprintf(symbol + n, size - n, " DV%s.",
-		      lpfc_release_version);
-	if (size < n)
-		return n;
+	scnprintf(tmp, sizeof(tmp), " DV%s", lpfc_release_version);
+	if (strlcat(symbol, tmp, size) >= size)
+		goto buffer_done;
 
-	n += scnprintf(symbol + n, size - n, " HN:%s.",
-		      init_utsname()->nodename);
-	if (size < n)
-		return n;
+	scnprintf(tmp, sizeof(tmp), " HN:%s", init_utsname()->nodename);
+	if (strlcat(symbol, tmp, size) >= size)
+		goto buffer_done;
 
 	/* Note :- OS name is "Linux" */
-	n += scnprintf(symbol + n, size - n, " OS:%s",
-		      init_utsname()->sysname);
-	return n;
+	scnprintf(tmp, sizeof(tmp), " OS:%s", init_utsname()->sysname);
+	strlcat(symbol, tmp, size);
+
+buffer_done:
+	return strnlen(symbol, size);
+
 }
 
 static uint32_t
-- 
2.20.1

