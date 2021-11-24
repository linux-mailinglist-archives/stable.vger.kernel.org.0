Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB2E45C41C
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351235AbhKXNp3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:45:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:33718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350783AbhKXNms (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:42:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73F3363262;
        Wed, 24 Nov 2021 12:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758706;
        bh=kSrgevceoNCKczVS7XbBJ8B1MvgwYQIW+ZrycOJJmuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EQBZl4QuMguUPoDk5W68+0nbKmSzlwExw9G8zEAIeIFsIqXgbPLViWtSIOftTUR0L
         R/XzWHvxt/YeVRn/J4LqwlUiyzVtZwr1Trpb7VskteHLcbrum6DmRNnS36QNSE2fuR
         8B+VFIB9QgDa99hLHoNzA+JfpW7hwLr3JLwMu9Jg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 145/154] scsi: ufs: core: Fix task management completion timeout race
Date:   Wed, 24 Nov 2021 12:59:01 +0100
Message-Id: <20211124115707.176769699@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/ufs/ufshcd.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6280,11 +6280,6 @@ static int __ufshcd_issue_tm_cmd(struct
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


