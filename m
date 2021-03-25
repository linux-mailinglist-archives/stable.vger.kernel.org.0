Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69E2234908E
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbhCYLgE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:36:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:41898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231539AbhCYLdh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:33:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E603B61A8E;
        Thu, 25 Mar 2021 11:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671721;
        bh=I2wM7d8m3gQj4oCpdlaDJdwdAUqStOU4cVPfVyEn7II=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e6r/jfglyMAWkvGo1hTgk+4Wre0vjFMGCHdtCdUEhTYAFUnnLXQDAr1st1Xb4Z/AS
         AwWKQhJucOUdUKWs85VzdR626tYhWz0Y920SwyvOimRDl3TBJt8jOMp2baPCsR3Fok
         Y5CLQULpY46drcC5P1pv1uEeRQffYSyfPqoCdAH8Usfp8Gvv5qmZpekNjnTFi5+8dX
         OZMJRKxhsRTCZm1r1yv3kmv5BXzxwJGksTbKpVhJpWBaqJKDhSwTxKsVb9Op1SMajY
         QKDhauVuSXIuElRAczxab/A8xnDg4u4E/i+cFsa30pK32Z7Bp9QjbEecfDs1jMSKmP
         P0ZShkoDOYRbA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexey Dobriyan <adobriyan@gmail.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 07/10] scsi: qla2xxx: Fix broken #endif placement
Date:   Thu, 25 Mar 2021 07:28:28 -0400
Message-Id: <20210325112832.1928898-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112832.1928898-1-sashal@kernel.org>
References: <20210325112832.1928898-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>

[ Upstream commit 5999b9e5b1f8a2f5417b755130919b3ac96f5550 ]

Only half of the file is under include guard because terminating #endif
is placed too early.

Link: https://lore.kernel.org/r/YE4snvoW1SuwcXAn@localhost.localdomain
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_target.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index bca584ae45b7..7a6fafa8ba56 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -112,7 +112,6 @@
 	(min(1270, ((ql) > 0) ? (QLA_TGT_DATASEGS_PER_CMD_24XX + \
 		QLA_TGT_DATASEGS_PER_CONT_24XX*((ql) - 1)) : 0))
 #endif
-#endif
 
 #define GET_TARGET_ID(ha, iocb) ((HAS_EXTENDED_IDS(ha))			\
 			 ? le16_to_cpu((iocb)->u.isp2x.target.extended)	\
@@ -323,6 +322,7 @@ struct ctio_to_2xxx {
 #ifndef CTIO_RET_TYPE
 #define CTIO_RET_TYPE	0x17		/* CTIO return entry */
 #define ATIO_TYPE7 0x06 /* Accept target I/O entry for 24xx */
+#endif
 
 struct fcp_hdr {
 	uint8_t  r_ctl;
-- 
2.30.1

