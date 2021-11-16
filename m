Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3030B452F7D
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 11:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234304AbhKPKwI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 05:52:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234313AbhKPKwF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 05:52:05 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27913C061746
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 02:49:08 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id r23so1364594pgu.13
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 02:49:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9md8a1aLAFQgFA+cts5xRlXwM6EHVaLa/gL7qBkqXYY=;
        b=V7hW6yV5UL0gv9PzTmsp0Ksd2af7QacOnp14PQalJVtkND222wj9fhoWqxHkFlNZuR
         Jw08xqqN2ia9hg9oH0xVUYj/EUyRsOERePiHgN4WKGY+RCAWtAMqLQAtjHmaG5l1zxjW
         oHO/NqBrjR2MxtOYOh4HIFIWaSfMdnphOBcrpV/rJIRkag23/ja6x2v52V2E25xxvvPK
         suQKmCfXlwPwy3bd4Sl+wd0zev/ixFjcud+DOeTHKN1D8QW+8KPQptWuR9KC7zJIO6X0
         Ezvd+67uFcNecctwG4/WWXU39tZg1hy+1RFqFiHAeeexMxN9Dt6ztz0gDnBkztwltJlj
         wCKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9md8a1aLAFQgFA+cts5xRlXwM6EHVaLa/gL7qBkqXYY=;
        b=3ddPTVaQGkE7M3Gl/zz96xs29K/CZROcLwheQvbGPk6D5TbfayUDurMFklx6DLFN3q
         z697N1TxI3VE004hC7n2el9Ng5MS0m0ePkJ62qC16j3C1V4H+awgOPqFQBsPuM4wUnhZ
         QN3EgldvrLYVsM/Sa3IS9uStcsVQ9PSVNEdoNlnAGJIU69nXeXEoD3yiATagzLGfKpkO
         2JV9LSZe0vUOCSkY8AXkbZBNfaD70F5rIj5CJckaBSShFzN4bbI5zJZS0YqrUoECH2TL
         0FZzcAX8eiZW8KOdzauG46BpJQhSevRG6gDgVZTDb1JRmj7hhHShO1RNlLvL5nu1D2hB
         JROg==
X-Gm-Message-State: AOAM531RezlYuDe1mGjUu3TEok54dtNgUEsIWA2Wmz88vA1uMEJUpkPz
        IF0tuBGcxoNfj0sqFs9Dg7g=
X-Google-Smtp-Source: ABdhPJyYRC8MnXKF9pKHev/a4gTvvv+MZPS8jsolGojmEVYri7A8MHBLn0yhrSvat0Flh4DzRJYigg==
X-Received: by 2002:a05:6a00:1349:b0:4a0:2f9:e3ab with SMTP id k9-20020a056a00134900b004a002f9e3abmr39466961pfu.80.1637059747743;
        Tue, 16 Nov 2021 02:49:07 -0800 (PST)
Received: from lenovo.spreadtrum.com ([117.18.48.102])
        by smtp.gmail.com with ESMTPSA id p2sm2024375pja.55.2021.11.16.02.49.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Nov 2021 02:49:07 -0800 (PST)
From:   Orson Zhai <orsonzhai@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>, Can Guo <cang@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>, orson.zhai@gmail.com,
        Orson Zhai <orson.zhai@unisoc.com>
Subject: [PATCH 2/2] scsi: ufs: Fix tm request when non-fatal error happens
Date:   Tue, 16 Nov 2021 18:48:31 +0800
Message-Id: <1637059711-11746-3-git-send-email-orsonzhai@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1637059711-11746-1-git-send-email-orsonzhai@gmail.com>
References: <1637059711-11746-1-git-send-email-orsonzhai@gmail.com>
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

Change-Id: I8a422b1f0e3152191f576548cc371a1a41115f59
Link: https://lore.kernel.org/r/20210107185316.788815-3-jaegeuk@kernel.org
Fixes: 69a6c269c097 ("scsi: ufs: Use blk_{get,put}_request() to allocate and free TMFs")
Reviewed-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Orson Zhai <orson.zhai@unisoc.com>
---
 drivers/scsi/ufs/ufshcd.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a5d4ee6..4004506 100644
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
@@ -5661,9 +5662,13 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
 		intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
 	}
 
-	if (enabled_intr_status && retval == IRQ_NONE) {
-		dev_err(hba->dev, "%s: Unhandled interrupt 0x%08x\n",
-					__func__, intr_status);
+	if (enabled_intr_status && retval == IRQ_NONE &&
+				!ufshcd_eh_in_progress(hba)) {
+		dev_err(hba->dev, "%s: Unhandled interrupt 0x%08x (0x%08x, 0x%08x)\n",
+					__func__,
+					intr_status,
+					hba->ufs_stats.last_intr_status,
+					enabled_intr_status);
 		ufshcd_dump_regs(hba, 0, UFSHCI_REG_SPACE_SIZE, "host_regs: ");
 	}
 
@@ -5705,7 +5710,10 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
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

