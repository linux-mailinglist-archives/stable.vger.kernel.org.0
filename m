Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8872167116
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 08:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729663AbgBUHvD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:51:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:48166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728602AbgBUHvC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:51:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D59620801;
        Fri, 21 Feb 2020 07:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271461;
        bh=6z/t0VhggveAqMfKd+GXVB1VM3eyWMPeYQwd11GIHLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MoF3SSDUamvraDZFIq8E2BdVO3EapRJLf3BSnW6NsYdcX0uROte3xZaRLHU7r1yTI
         jFN3dSsk9PPEtRhQ/Mh57h/FVNABVMzbqH68ARHNxDmN5Uti0F4Lfq3CQu4kfjArRm
         bCCshXT/c94CdHIDJ+9zgHRkkuzlQeRR6VhoZk3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 175/399] scsi: lpfc: Fix: Rework setting of fdmi symbolic node name registration
Date:   Fri, 21 Feb 2020 08:38:20 +0100
Message-Id: <20200221072419.672458726@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 99c9bb249758c..1b4dbb28fb419 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1493,33 +1493,35 @@ int
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



