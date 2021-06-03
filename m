Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC21D399EA6
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 12:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbhFCKRF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 06:17:05 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:46472 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229665AbhFCKRE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Jun 2021 06:17:04 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 153AAftD011018;
        Thu, 3 Jun 2021 03:15:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=ddVl/R29tkM6ZNpj7fH9z0F9r1phP0HIjU6aSM3ozis=;
 b=adzKI0LsZBHTivRKl+TjkPW+2mBLi4XLbzTlntE9Dqgt458PmWTv6jTfLcuyZpZD20kK
 IjuLzFRBOxrVdjqpRlFRa+Cyiaoc2pgx0+IZd8ijXUPeXSmQUgcdA2DSx/Fs10128Zds
 dVR07R+LAL78YmrPtvf9RkSePfvR2QuJKAQaxviYTzDFaL3UEwHWpGLnVhCcixfpEoGW
 gelRCCoB57ejc2VtwSamoTeejvvXDWW9D25d3IRRyDwdNmedZbN0xomIGGRlnZg78kgM
 5w62wyItb0SEYHxtHrYtSSPKN1rhMxo1GfgGpJMfT15mx6ZwuUNZ++xmAEE/HgtBZeCr WQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 38xhym26cj-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 03 Jun 2021 03:15:19 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Jun
 2021 03:15:17 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 3 Jun 2021 03:15:17 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id F2C383F7062;
        Thu,  3 Jun 2021 03:15:16 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 153AFGWO007893;
        Thu, 3 Jun 2021 03:15:16 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 153AFGwY007884;
        Thu, 3 Jun 2021 03:15:16 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>,
        <stable@vger.kernel.org>
Subject: [PATCH V2 2/2] libfc: Corrected the condition check and invalid argument passed
Date:   Thu, 3 Jun 2021 03:14:04 -0700
Message-ID: <20210603101404.7841-3-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210603101404.7841-1-jhasan@marvell.com>
References: <20210603101404.7841-1-jhasan@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: pKTO6-LT5VnuWaMsDEnVM4nO4MY9OicS
X-Proofpoint-GUID: pKTO6-LT5VnuWaMsDEnVM4nO4MY9OicS
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-03_06:2021-06-02,2021-06-03 signatures=0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

 -In correct condition check was leading to data corruption
  and so the invalid argument.

Fixes: 8fd9efca86d0 ("scsi: libfc: Work around -Warray-bounds warning")
Signed-off-by: Javed Hasan <jhasan@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
CC: stable@vger.kernel.org
---
Changes in v2:
 - Added stable@vger.kernel.org in cc
---
 drivers/scsi/libfc/fc_encode.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libfc/fc_encode.h b/drivers/scsi/libfc/fc_encode.h
index 602c97a651bc..9ea4ceadb559 100644
--- a/drivers/scsi/libfc/fc_encode.h
+++ b/drivers/scsi/libfc/fc_encode.h
@@ -166,9 +166,11 @@ static inline int fc_ct_ns_fill(struct fc_lport *lport,
 static inline void fc_ct_ms_fill_attr(struct fc_fdmi_attr_entry *entry,
 				    const char *in, size_t len)
 {
-	int copied = strscpy(entry->value, in, len);
-	if (copied > 0)
-		memset(entry->value, copied, len - copied);
+	int copied;
+
+	copied = strscpy((char *)&entry->value, in, len);
+	if (copied > 0 && (copied + 1) < len)
+		memset((entry->value + copied + 1), 0, len - copied - 1);
 }
 
 /**
-- 
2.26.2

