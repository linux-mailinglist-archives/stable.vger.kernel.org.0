Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6CEE126D49
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbfLSSkB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:40:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:58590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727016AbfLSSkA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:40:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 228DF20716;
        Thu, 19 Dec 2019 18:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780799;
        bh=Oumn+Gt3hM6JkMsZl4AjSWEZE4hwvtsd2P3a1SY+M2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SIf9MIVHCl7up2haaMyDxZ3bo7kzKDlt7nFmnQ9hv7WQIfXNgJV27qcvoQygicEnm
         IZZef3d1fNnUAp1kSK4GIxZLbkdOIgn+LycVg2mlby/YeV1opkS0Yy9ioR5iRySqqu
         xZ63QXC6LZq6ngz1GvBdJi25GCVPNka3Xypjq1/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 123/162] scsi: zfcp: trace channel log even for FCP command responses
Date:   Thu, 19 Dec 2019 19:33:51 +0100
Message-Id: <20191219183215.251422659@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183150.477687052@linuxfoundation.org>
References: <20191219183150.477687052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steffen Maier <maier@linux.ibm.com>

[ Upstream commit 100843f176109af94600e500da0428e21030ca7f ]

While v2.6.26 commit b75db73159cc ("[SCSI] zfcp: Add qtcb dump to hba debug
trace") is right that we don't want to flood the (payload) trace ring
buffer, we don't trace successful FCP command responses by default.  So we
can include the channel log for problem determination with failed responses
of any FSF request type.

Fixes: b75db73159cc ("[SCSI] zfcp: Add qtcb dump to hba debug trace")
Fixes: a54ca0f62f95 ("[SCSI] zfcp: Redesign of the debug tracing for HBA records.")
Cc: <stable@vger.kernel.org> #2.6.38+
Link: https://lore.kernel.org/r/e37597b5c4ae123aaa85fd86c23a9f71e994e4a9.1572018132.git.bblock@linux.ibm.com
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/scsi/zfcp_dbf.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_dbf.c b/drivers/s390/scsi/zfcp_dbf.c
index b6caad0fee24c..c53ea0ac5f460 100644
--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -93,11 +93,9 @@ void zfcp_dbf_hba_fsf_res(char *tag, int level, struct zfcp_fsf_req *req)
 	memcpy(rec->u.res.fsf_status_qual, &q_head->fsf_status_qual,
 	       FSF_STATUS_QUALIFIER_SIZE);
 
-	if (req->fsf_command != FSF_QTCB_FCP_CMND) {
-		rec->pl_len = q_head->log_length;
-		zfcp_dbf_pl_write(dbf, (char *)q_pref + q_head->log_start,
-				  rec->pl_len, "fsf_res", req->req_id);
-	}
+	rec->pl_len = q_head->log_length;
+	zfcp_dbf_pl_write(dbf, (char *)q_pref + q_head->log_start,
+			  rec->pl_len, "fsf_res", req->req_id);
 
 	debug_event(dbf->hba, level, rec, sizeof(*rec));
 	spin_unlock_irqrestore(&dbf->hba_lock, flags);
-- 
2.20.1



