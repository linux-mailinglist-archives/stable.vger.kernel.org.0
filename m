Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D70445A25B
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 13:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236413AbhKWMWo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 07:22:44 -0500
Received: from mga11.intel.com ([192.55.52.93]:15358 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233576AbhKWMWn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 07:22:43 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10176"; a="232501968"
X-IronPort-AV: E=Sophos;i="5.87,257,1631602800"; 
   d="scan'208";a="232501968"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2021 04:19:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,257,1631602800"; 
   d="scan'208";a="509007728"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.76])
  by fmsmga007.fm.intel.com with ESMTP; 23 Nov 2021 04:19:34 -0800
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     stable@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 5.10 2/2] scsi: ufs: core: Fix task management completion timeout race
Date:   Tue, 23 Nov 2021 14:19:30 +0200
Message-Id: <20211123121930.1464738-3-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211123121930.1464738-1-adrian.hunter@intel.com>
References: <20211123121930.1464738-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 886fe2915cce6658b0fc19e64b82879325de61ea upstream.

__ufshcd_issue_tm_cmd() clears req->end_io_data after timing out, which
races with the completion function ufshcd_tmc_handler() which expects
req->end_io_data to have a value.

Note __ufshcd_issue_tm_cmd() and ufshcd_tmc_handler() are already
synchronized using hba->tmf_rqs and hba->outstanding_tasks under the
host_lock spinlock.

It is also not necessary (nor typical) to clear req->end_io_data because
the block layer does it before allocating out requests e.g. via
blk_get_request().

So fix by not clearing it.

Link: https://lore.kernel.org/r/20211108064815.569494-2-adrian.hunter@intel.com
Fixes: f5ef336fd2e4 ("scsi: ufs: core: Fix task management completion")
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
[Adrian: Backport to v5.10]
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/scsi/ufs/ufshcd.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 5fd0a6ed181c..e3a9a02cadf5 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6280,11 +6280,6 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	err = wait_for_completion_io_timeout(&wait,
 			msecs_to_jiffies(TM_CMD_TIMEOUT));
 	if (!err) {
-		/*
-		 * Make sure that ufshcd_compl_tm() does not trigger a
-		 * use-after-free.
-		 */
-		req->end_io_data = NULL;
 		ufshcd_add_tm_upiu_trace(hba, task_tag, "tm_complete_err");
 		dev_err(hba->dev, "%s: task management cmd 0x%.2x timed-out\n",
 				__func__, tm_function);
-- 
2.25.1

