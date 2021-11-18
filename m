Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13C1C455D7C
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 15:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232513AbhKROLA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 09:11:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbhKROLA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 09:11:00 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C686C061570
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 06:08:00 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id z6so4143281plk.6
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 06:08:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+6IH5lOa89ENCeNMt5PtIy8jRMzTRLBjN5Xo1H+u68c=;
        b=ZgrJ50DuKk2FA7DX1k1ddxSOUDZ4/5Qyvm2pWDxy1OmgfSSsnXYEQpEtwyPMPc5Oh0
         R5WuW6xMaALPwkoNipi/gc8b3VWcWyKeRpDBkDY9w8FCstoqw8IGVvkiu1g14vDmsWZM
         xrySj1/eYtddWS5voFCS1KQoz3ehcG+LCosNWnG94VNlu6vAMapaba35WNKLOD1pOXUk
         VwIgivKnzTU0q3/Imdelwv5bCO2kJaoor6mxJFfR9xlW4McY4xoIpYXhO3aMf0W7q0Yq
         R1YxKoRKDMBIk8ry3VvY+5TK51uKzbGpD36NGmadnlgU1oFMVVO5oqMgr6aINIbdpsi6
         aHNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+6IH5lOa89ENCeNMt5PtIy8jRMzTRLBjN5Xo1H+u68c=;
        b=NCFE36rPG9AVLeGHpIdCa+ZAlgtmQ22zFJoyMUfHluA9ORTgHjheFu+4bypYIFm8e3
         qRFNLTUrdNN9Ts46Mq40zbCJVo+5V3gANAxs9tIoim3kEG3uXWr6ygRsq2UIW5iA8Jwt
         KHGi8mqc1HDTKndWGvs+OOmqthVZ0eB7MsQeFHGNpQIcoDuRfJDjNIayTz3kjHBW67my
         +kxdPNPQM5hwyf5NAyRNXtnOD+vv1wzOn8c2A3W6A1d6vAJOTGpI9LWVj0mp+gQIhvXY
         RUPaaG3TPDHL1g2JjHzQZwxI9utxIcOlWDHxI5iP6W2waxo7S2cg35/rTU2OJr3Idx/y
         cFoA==
X-Gm-Message-State: AOAM532Jos5GdzEfkg7xitkNQz1wx1d9SQYOSVq4cdIvMt5b3TNxAyyP
        HMZM/bjngMQvRryKhcr466U=
X-Google-Smtp-Source: ABdhPJzs3+7EZDz5JSLhL+wXEqwWYZh5/t3CYRFKymI0YkJjfpP+h8e/KONY78Vak7F/+WDhOwtSVA==
X-Received: by 2002:a17:902:b718:b0:143:72b7:409e with SMTP id d24-20020a170902b71800b0014372b7409emr66422354pls.28.1637244479745;
        Thu, 18 Nov 2021 06:07:59 -0800 (PST)
Received: from lenovo.spreadtrum.com ([117.18.48.102])
        by smtp.gmail.com with ESMTPSA id h196sm3510717pfe.216.2021.11.18.06.07.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Nov 2021 06:07:59 -0800 (PST)
From:   Orson Zhai <orsonzhai@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>, Can Guo <cang@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>, orson.zhai@gmail.com,
        Orson Zhai <orson.zhai@unisoc.com>
Subject: [PATCH v2 2/2] scsi: ufs: Fix tm request when non-fatal error happens
Date:   Thu, 18 Nov 2021 22:07:02 +0800
Message-Id: <1637244422-29190-3-git-send-email-orsonzhai@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1637244422-29190-1-git-send-email-orsonzhai@gmail.com>
References: <1637244422-29190-1-git-send-email-orsonzhai@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit eeb1b55b6e25c5f7265ff45cd050f3bc2cc423a4 ]

When non-fatal error like line-reset happens, ufshcd_err_handler() starts
to abort tasks by ufshcd_try_to_abort_task(). When it tries to issue a task
management request, we hit two warnings:

WARNING: CPU: 7 PID: 7 at block/blk-core.c:630 blk_get_request+0x68/0x70
WARNING: CPU: 4 PID: 157 at block/blk-mq-tag.c:82 blk_mq_get_tag+0x438/0x46c

After fixing the above warnings we hit another tm_cmd timeout which may be
caused by unstable controller state:

__ufshcd_issue_tm_cmd: task management cmd 0x80 timed-out

Then, ufshcd_err_handler() enters full reset, and kernel gets stuck. It
turned out ufshcd_print_trs() printed too many messages on console which
requires CPU locks. Likewise hba->silence_err_logs, we need to avoid too
verbose messages. This is actually not an error case.

Link: https://lore.kernel.org/r/20210107185316.788815-3-jaegeuk@kernel.org
Fixes: 69a6c269c097 ("scsi: ufs: Use blk_{get,put}_request() to allocate and free TMFs")
Reviewed-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
[Zhai: remove an item of debug print not available in v5.4]
Signed-off-by: Orson Zhai <orson.zhai@unisoc.com>
---
 drivers/scsi/ufs/ufshcd.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a5d4ee6..29c7a76 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4748,7 +4748,8 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		break;
 	} /* end of switch */
 
-	if ((host_byte(result) != DID_OK) && !hba->silence_err_logs)
+	if ((host_byte(result) != DID_OK) &&
+	    (host_byte(result) != DID_REQUEUE) && !hba->silence_err_logs)
 		ufshcd_print_trs(hba, 1 << lrbp->task_tag, true);
 	return result;
 }
@@ -5661,9 +5662,12 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
 		intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
 	}
 
-	if (enabled_intr_status && retval == IRQ_NONE) {
-		dev_err(hba->dev, "%s: Unhandled interrupt 0x%08x\n",
-					__func__, intr_status);
+	if (enabled_intr_status && retval == IRQ_NONE &&
+				!ufshcd_eh_in_progress(hba)) {
+		dev_err(hba->dev, "%s: Unhandled interrupt 0x%08x (-, 0x%08x)\n",
+					__func__,
+					intr_status,
+					enabled_intr_status);
 		ufshcd_dump_regs(hba, 0, UFSHCI_REG_SPACE_SIZE, "host_regs: ");
 	}
 
@@ -5705,7 +5709,10 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	/*
 	 * blk_get_request() is used here only to get a free tag.
 	 */
-	req = blk_get_request(q, REQ_OP_DRV_OUT, BLK_MQ_REQ_RESERVED);
+	req = blk_get_request(q, REQ_OP_DRV_OUT, 0);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+
 	req->end_io_data = &wait;
 	ufshcd_hold(hba, false);
 
-- 
2.7.4

