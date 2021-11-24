Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A77045C5C6
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350518AbhKXOAo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:00:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:48818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355715AbhKXN6r (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:58:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61531633E4;
        Wed, 24 Nov 2021 13:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759304;
        bh=DiKEAg+dsedmYiM4WdwOUIsQ6xl8P9mde9FqPqhOz+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uUkCQtk+ZiEBRBikpac8hAe1Ukkha44q74LzAbHQdEIhkEdOEzSx/Il8x+CKaaEX3
         l/l5v12V/m2MwL/o+fkgBO9GIZ1cUAyVroqIzfwd3CLF+VHlVC+XpTCPXRA28lRDj8
         f2XaNoeYjW5bVGd3I+59wI1mo3CZjbbEk+2BZ6rQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 154/279] scsi: ufs: core: Fix task management completion timeout race
Date:   Wed, 24 Nov 2021 12:57:21 +0100
Message-Id: <20211124115724.087924020@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 886fe2915cce6658b0fc19e64b82879325de61ea ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 325a15186e950..3d0da8b3fed8a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6541,11 +6541,6 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	err = wait_for_completion_io_timeout(&wait,
 			msecs_to_jiffies(TM_CMD_TIMEOUT));
 	if (!err) {
-		/*
-		 * Make sure that ufshcd_compl_tm() does not trigger a
-		 * use-after-free.
-		 */
-		req->end_io_data = NULL;
 		ufshcd_add_tm_upiu_trace(hba, task_tag, UFS_TM_ERR);
 		dev_err(hba->dev, "%s: task management cmd 0x%.2x timed-out\n",
 				__func__, tm_function);
-- 
2.33.0



