Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164C8328D36
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241052AbhCATHw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:07:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:34110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240856AbhCATBU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:01:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25B8064FCD;
        Mon,  1 Mar 2021 17:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621020;
        bh=19kSdxDrdAy+LHoXVzpuhX/sGuKQMIgL21+05tkWEp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iA+iu2eVsYu2JX8iF9idWPD+5mFN3u5KogJB5fW9HwWWZSsKxerKax9IleCKvpTdg
         tZHreOFKTXwYTIKS59UQTuRrXFv6e/3hAdXLv5BeyZ3MYj4yjqTno3vzYH6PZ8in1l
         LORGVAmjHzWEAYXTrqbE/worRGnKS7v+KcMH7s+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 334/775] scsi: ufs: Fix a possible NULL pointer issue
Date:   Mon,  1 Mar 2021 17:08:22 +0100
Message-Id: <20210301161218.125439378@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Can Guo <cang@codeaurora.org>

[ Upstream commit fb7afe24ba1b7e27483be7d2ac3ed002e67eecd5 ]

During system resume/suspend, hba could be NULL. In this case, do not touch
eh_sem.

Fixes: 88a92d6ae4fe ("scsi: ufs: Serialize eh_work with system PM events and async scan")
Link: https://lore.kernel.org/r/1610594010-7254-2-git-send-email-cang@codeaurora.org
Acked-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index fb32d122f2e38..728168cd18f55 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -94,6 +94,8 @@
 		       16, 4, buf, __len, false);                        \
 } while (0)
 
+static bool early_suspend;
+
 int ufshcd_dump_regs(struct ufs_hba *hba, size_t offset, size_t len,
 		     const char *prefix)
 {
@@ -8939,8 +8941,14 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
 	int ret = 0;
 	ktime_t start = ktime_get();
 
+	if (!hba) {
+		early_suspend = true;
+		return 0;
+	}
+
 	down(&hba->eh_sem);
-	if (!hba || !hba->is_powered)
+
+	if (!hba->is_powered)
 		return 0;
 
 	if ((ufs_get_pm_lvl_to_dev_pwr_mode(hba->spm_lvl) ==
@@ -8989,9 +8997,12 @@ int ufshcd_system_resume(struct ufs_hba *hba)
 	int ret = 0;
 	ktime_t start = ktime_get();
 
-	if (!hba) {
-		up(&hba->eh_sem);
+	if (!hba)
 		return -EINVAL;
+
+	if (unlikely(early_suspend)) {
+		early_suspend = false;
+		down(&hba->eh_sem);
 	}
 
 	if (!hba->is_powered || pm_runtime_suspended(hba->dev))
-- 
2.27.0



