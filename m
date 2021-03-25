Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC8BC348F25
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbhCYL0P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:26:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:34012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229659AbhCYLZg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:25:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A203B61A27;
        Thu, 25 Mar 2021 11:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671536;
        bh=AXPvgc8rnjsjw3t8kmfYQ+BD6xkcDOA2DFusWRVn+7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mstQHK5iumvbWyYb2dkIqCk+y2O7Iu4FnBubLx3HzhgCdGvQGUKcV3eRG0+C9HLIb
         kpil23jh0RvHeJk+iu1MT5pGmduq7H2OCicpIR2xgrBevqYvqgOqa9fpd4xej5+vPO
         1553rDXbOT/PlFAfy7DfYIpuqvqSvABS7gZdju6DjSQMSj8ScYgg9AaIM4xSC64D91
         SiOlSzp/IsCQ0teyfVaoWKtYfT+tmfyaeGpWqG9ELkLtdb/ei1hu7TJKAstPhnXX0I
         rpY3B81KvM6ct09nMt89TfcixBLld2Bxe+BqeScb2i5/Hkq2jm38iaxAglcfE/yeV8
         4Ope6zuiuwyVg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexey Dobriyan <adobriyan@gmail.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 28/44] scsi: qla2xxx: Fix broken #endif placement
Date:   Thu, 25 Mar 2021 07:24:43 -0400
Message-Id: <20210325112459.1926846-28-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112459.1926846-1-sashal@kernel.org>
References: <20210325112459.1926846-1-sashal@kernel.org>
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
index 10e5e6c8087d..01620f3eab39 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -116,7 +116,6 @@
 	(min(1270, ((ql) > 0) ? (QLA_TGT_DATASEGS_PER_CMD_24XX + \
 		QLA_TGT_DATASEGS_PER_CONT_24XX*((ql) - 1)) : 0))
 #endif
-#endif
 
 #define GET_TARGET_ID(ha, iocb) ((HAS_EXTENDED_IDS(ha))			\
 			 ? le16_to_cpu((iocb)->u.isp2x.target.extended)	\
@@ -244,6 +243,7 @@ struct ctio_to_2xxx {
 #ifndef CTIO_RET_TYPE
 #define CTIO_RET_TYPE	0x17		/* CTIO return entry */
 #define ATIO_TYPE7 0x06 /* Accept target I/O entry for 24xx */
+#endif
 
 struct fcp_hdr {
 	uint8_t  r_ctl;
-- 
2.30.1

