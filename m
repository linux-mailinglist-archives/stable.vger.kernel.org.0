Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 925EF4446A9
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 18:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233070AbhKCRKT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 13:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233024AbhKCRKR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Nov 2021 13:10:17 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31411C061203
        for <stable@vger.kernel.org>; Wed,  3 Nov 2021 10:07:41 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id o14so3005547pfu.10
        for <stable@vger.kernel.org>; Wed, 03 Nov 2021 10:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8PZdsIgJ7o56oudhsOIKiAeNLgKu9PFgrqrBHXJbLAE=;
        b=jTLkI2qiLoMk3mhIAcG2QBo3TCoHT4cuvNl3BHq07EzQb3l9GXFc7uMZhmNlXbcJY+
         r7stJfGZlc73iFJbeU7Oh+iYruQvRyBH/4Mz3V2bJE7Snqxi8hObvScZ77IxTUuE6Qic
         tSlmyuHaPJD7uRnj0LX4av+Al3jG8JOeZ234WWM6u6goXKFXdLBg6OcYBE5VCLLo+89R
         hwuAO00euVp5+jWI5V6aFHcmoHtSW2UiGMzu2vUJCdDAqnCkqcXVMLzeus9jz/81d2sA
         gpxI2lzvnMuKwQGK5Vs+Uw7tZHFZ4y7DdldW4R4bgxajtUOsM2/23Juxaxd6UlWVBnJs
         OGDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8PZdsIgJ7o56oudhsOIKiAeNLgKu9PFgrqrBHXJbLAE=;
        b=wdF0TKtqlXB8arwTULa+niqsYRtWWDSKCe7BEwUYTXYwGkERRRaLkUywFhyzoAUPYA
         yJLZPTjWzn0iRUmKiiJSpn/pYr6K3XG968+4UFge7WoZLl4qi8sH5YWE6acphlmgTBlp
         TGgsB4I1d6mpsjZQ4B4Wk5eDAfOeya9ipw19f/7iGU2nSQkzfUlzrbTWrhI+8ZCUvAl2
         8cPJe7HEbMVM9JNjrBYyDrDJkr9EaTjCwl7DWI+BsahlLkzqhoGFbnv+LFwZv1VSdQl7
         gAYStlqdBk2Y3NQVofiHkPg7EUJmN87IRLJIBFeohJS/qTKLvSEJ7xJZETZhzjtuZs+r
         pq6w==
X-Gm-Message-State: AOAM530j4isgBXAA++zDxSgnonDFIrA1YbJPTyqobaErUdCIrqjLJ6kb
        y9r5NltoJvh0Cgsk0n5DLicQFQ==
X-Google-Smtp-Source: ABdhPJywslGu8/XLLI7D32OSa9abMUfDu7BG0N+nJrTal3Y8saV3vwt2xSi7bYdo00rfgsmqhZ7U4g==
X-Received: by 2002:a62:6411:0:b0:44c:bf9f:f584 with SMTP id y17-20020a626411000000b0044cbf9ff584mr45439674pfb.29.1635959260670;
        Wed, 03 Nov 2021 10:07:40 -0700 (PDT)
Received: from localhost.localdomain ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id k14sm3110810pff.64.2021.11.03.10.07.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 10:07:40 -0700 (PDT)
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
To:     Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org
Cc:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        Christoph Hellwig <hch@lst.de>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+5516b30f5401d4dcbcae@syzkaller.appspotmail.com
Subject: [PATCH v2 2/2] scsi: core: remove command size deduction from scsi_setup_scsi_cmnd
Date:   Wed,  3 Nov 2021 10:06:59 -0700
Message-Id: <20211103170659.22151-2-tadeusz.struk@linaro.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211103170659.22151-1-tadeusz.struk@linaro.org>
References: <20211103170659.22151-1-tadeusz.struk@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

No need to deduce command size in scsi_setup_scsi_cmnd() anymore
as appropriate checks have been added to scsi_fill_sghdr_rq() function
and the cmd_len should never be zero here.
The code to do that wasn't correct anyway, as it used uninitialized
cmd->cmnd, which caused a null-ptr-deref if the command size was zero
as in the trace below. Fix this by removing the unneeded code.

KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 PID: 1822 Comm: repro Not tainted 5.15.0 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-4.fc34 04/01/2014
Call Trace:
 blk_mq_dispatch_rq_list+0x7c7/0x12d0
 __blk_mq_sched_dispatch_requests+0x244/0x380
 blk_mq_sched_dispatch_requests+0xf0/0x160
 __blk_mq_run_hw_queue+0xe8/0x160
 __blk_mq_delay_run_hw_queue+0x252/0x5d0
 blk_mq_run_hw_queue+0x1dd/0x3b0
 blk_mq_sched_insert_request+0x1ff/0x3e0
 blk_execute_rq_nowait+0x173/0x1e0
 blk_execute_rq+0x15c/0x540
 sg_io+0x97c/0x1370
 scsi_ioctl+0xe16/0x28e0
 sd_ioctl+0x134/0x170
 blkdev_ioctl+0x362/0x6e0
 block_ioctl+0xb0/0xf0
 vfs_ioctl+0xa7/0xf0
 do_syscall_64+0x3d/0xb0
 entry_SYSCALL_64_after_hwframe+0x44/0xae
---[ end trace 8b086e334adef6d2 ]---
Kernel panic - not syncing: Fatal exception

Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: James E.J. Bottomley <jejb@linux.ibm.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: <linux-scsi@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <stable@vger.kernel.org> # 5.15, 5.14, 5.10
Fixes: 2ceda20f0a99a74a82b78870f3b3e5fa93087a7f
Reported-by: syzbot+5516b30f5401d4dcbcae@syzkaller.appspotmail.com
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
---
Changes in v2:
- prune trace dump according to feedback
---
 drivers/scsi/scsi_lib.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 572673873ddf..e026da7549be 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1174,8 +1174,6 @@ static blk_status_t scsi_setup_scsi_cmnd(struct scsi_device *sdev,
 	}
 
 	cmd->cmd_len = scsi_req(req)->cmd_len;
-	if (cmd->cmd_len == 0)
-		cmd->cmd_len = scsi_command_size(cmd->cmnd);
 	cmd->cmnd = scsi_req(req)->cmd;
 	cmd->transfersize = blk_rq_bytes(req);
 	cmd->allowed = scsi_req(req)->retries;
-- 
2.33.1

