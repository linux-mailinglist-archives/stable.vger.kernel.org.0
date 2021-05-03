Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD8E8371C84
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232544AbhECQxE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:53:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:33084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232412AbhECQvB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:51:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1698C61939;
        Mon,  3 May 2021 16:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060092;
        bh=+2PqsMbt1OO7ePqfSQb4d+qn1YLMvEYmk7VdMXbtj7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dCkcYKDbbBXPzPWF52tO9nwGhVQK+XbXIbF9ccNBaCgRIU3n6SBECAqD569Y0omUb
         cGrl5pTcPwDDWrsdhfcNiy/yf3/dgFvewwYOqZjT8tDeoRozwzdmowc070qByhqpnr
         ZSD181QtSHqc4BUvlDEU+kRX7f+8oKRg3IgI7GWKcEOa1NsNtgbox9gxjpRS20dYMv
         oB9bBn8HueHQXbqbgp95B+EAaQISxesXmpYP3w1GVg4ivyEOzO/Sp+H56p6hsBWti/
         WE6nEFkHXpSjr2uyDpfxa9uFMYG8nTdkeSL1toh5ICjVt5K6qyg+GZ5Pa/Pi3suOWn
         5Spvyy8Q0CTEQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Quinn Tran <qutran@marvell.com>,
        Mike Christie <michael.christie@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Daniel Wagner <dwagner@suse.de>, Lee Duncan <lduncan@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 15/35] scsi: qla2xxx: Always check the return value of qla24xx_get_isp_stats()
Date:   Mon,  3 May 2021 12:40:49 -0400
Message-Id: <20210503164109.2853838-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503164109.2853838-1-sashal@kernel.org>
References: <20210503164109.2853838-1-sashal@kernel.org>
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
index 0ab9d2fd4a14..d46a10d24ed4 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1934,6 +1934,8 @@ qla2x00_reset_host_stats(struct Scsi_Host *shost)
 	vha->qla_stats.jiffies_at_last_reset = get_jiffies_64();
 
 	if (IS_FWI2_CAPABLE(ha)) {
+		int rval;
+
 		stats = dma_alloc_coherent(&ha->pdev->dev,
 		    sizeof(*stats), &stats_dma, GFP_KERNEL);
 		if (!stats) {
@@ -1943,7 +1945,11 @@ qla2x00_reset_host_stats(struct Scsi_Host *shost)
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

