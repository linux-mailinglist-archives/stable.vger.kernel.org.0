Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6E40371BBF
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbhECQsA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:48:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:50840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232236AbhECQp5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:45:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F911616E8;
        Mon,  3 May 2021 16:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059969;
        bh=OmAsP+tYBJDtFQWqX428dKjCzbn7jC2wicgTcopdX3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A8xMyMPER8sftYIk0RI3NFeFswbk7WZGs0kyMj7RtyKj/muySUmPh8LHT4G2rRVwe
         Gn4Q+zorVmfhkT5Ps1bs1J/afv31nVxQ0EQAnc2ggHm94hN8hu6CB3jSzxwTRtE6mU
         t+ZR+4aUxuE1NyDOA3wYsQcY8cQj4wohObUjVBgGDM57yb5Zzqh5n2wF1tJi/ENTH3
         QCMP1vzmR8lgyF3dcVOAzoEDbkavXkcwA/67pIqlToVmhECFH2tBCk1dzEJELDh1s2
         9VT4F04yQ4A336PASCFpF0O3bkp+GVA6WZHzfPV0zM79peX2ipQxStZbAixgSXppaz
         g2RLar3sGFx+w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Quinn Tran <qutran@marvell.com>,
        Mike Christie <michael.christie@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Daniel Wagner <dwagner@suse.de>, Lee Duncan <lduncan@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 039/100] scsi: qla2xxx: Always check the return value of qla24xx_get_isp_stats()
Date:   Mon,  3 May 2021 12:37:28 -0400
Message-Id: <20210503163829.2852775-39-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163829.2852775-1-sashal@kernel.org>
References: <20210503163829.2852775-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit a2b2cc660822cae08c351c7f6b452bfd1330a4f7 ]

This patch fixes the following Coverity warning:

    CID 361199 (#1 of 1): Unchecked return value (CHECKED_RETURN)
    3. check_return: Calling qla24xx_get_isp_stats without checking return
    value (as is done elsewhere 4 out of 5 times).

Link: https://lore.kernel.org/r/20210320232359.941-7-bvanassche@acm.org
Cc: Quinn Tran <qutran@marvell.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Lee Duncan <lduncan@suse.com>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_attr.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index ab45ac1e5a72..6a2c4a6fcded 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2855,6 +2855,8 @@ qla2x00_reset_host_stats(struct Scsi_Host *shost)
 	vha->qla_stats.jiffies_at_last_reset = get_jiffies_64();
 
 	if (IS_FWI2_CAPABLE(ha)) {
+		int rval;
+
 		stats = dma_alloc_coherent(&ha->pdev->dev,
 		    sizeof(*stats), &stats_dma, GFP_KERNEL);
 		if (!stats) {
@@ -2864,7 +2866,11 @@ qla2x00_reset_host_stats(struct Scsi_Host *shost)
 		}
 
 		/* reset firmware statistics */
-		qla24xx_get_isp_stats(base_vha, stats, stats_dma, BIT_0);
+		rval = qla24xx_get_isp_stats(base_vha, stats, stats_dma, BIT_0);
+		if (rval != QLA_SUCCESS)
+			ql_log(ql_log_warn, vha, 0x70de,
+			       "Resetting ISP statistics failed: rval = %d\n",
+			       rval);
 
 		dma_free_coherent(&ha->pdev->dev, sizeof(*stats),
 		    stats, stats_dma);
-- 
2.30.2

