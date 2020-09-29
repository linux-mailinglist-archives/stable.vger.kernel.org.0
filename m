Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 103D027C95D
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730288AbgI2MKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:10:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:58104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730199AbgI2Lhe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:34 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 355F823A05;
        Tue, 29 Sep 2020 11:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378552;
        bh=/gBWoETwuYWm1um0PUFQmHE9oEDYYiuetdPEynALY6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pu6ZFtrssYbR+GY4TExXnsDwIQv/kDyW4AWXdvvSKpfj7SjlvCDwcMV6bqO4p2m5w
         67CScK7WNuqO00EEKrxQcXDFDXSoOHJSwu+vz4jBaTqHTHmckrkCH3naVfEnoPrnCT
         gPlAPKkbSaQhZYqabCWSjYAtu00ft1PAnUYacOe0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bean Huo <beanhuo@micron.com>,
        Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 055/245] scsi: ufs: Fix a race condition in the tracing code
Date:   Tue, 29 Sep 2020 12:58:26 +0200
Message-Id: <20200929105949.678679321@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit eacf36f5bebde5089dddb3d5bfcbeab530b01f8a ]

Starting execution of a command before tracing a command may cause the
completion handler to free data while it is being traced. Fix this race by
tracing a command before it is submitted.

Cc: Bean Huo <beanhuo@micron.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20191224220248.30138-5-bvanassche@acm.org
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index faf1959981784..b2cbdd01ab10b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1910,12 +1910,12 @@ void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
 {
 	hba->lrb[task_tag].issue_time_stamp = ktime_get();
 	hba->lrb[task_tag].compl_time_stamp = ktime_set(0, 0);
+	ufshcd_add_command_trace(hba, task_tag, "send");
 	ufshcd_clk_scaling_start_busy(hba);
 	__set_bit(task_tag, &hba->outstanding_reqs);
 	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 	/* Make sure that doorbell is committed immediately */
 	wmb();
-	ufshcd_add_command_trace(hba, task_tag, "send");
 }
 
 /**
-- 
2.25.1



