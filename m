Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9762497D93
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 12:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237180AbiAXLDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 06:03:37 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41142 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237178AbiAXLDh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 06:03:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 323A2B80ECB
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 11:03:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B9E3C340E1;
        Mon, 24 Jan 2022 11:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643022215;
        bh=uT7LpsGEtF6+jKXnYHZc/3XMml0cs5nvIe2mWWjAMqs=;
        h=Subject:To:Cc:From:Date:From;
        b=s3LNvIZJQSljTbncBLXZqu3Ge6nXpex94yXG1RqseJD22CNxUjO05rBVBU50qRNlE
         ZJT51Bbeuu39f6C22H/BpqavCXbtIQuxZQhqKrwJk9445VW16L4Dph5Yi5EFMAoww6
         qmsSxaju63vNH5kqTFrBchX8Hw4kUfhj8RgxwpE4=
Subject: FAILED: patch "[PATCH] scsi: ufs: Improve SCSI abort handling further" failed to apply to 4.9-stable tree
To:     bvanassche@acm.org, adrian.hunter@intel.com, beanhuo@micron.com,
        martin.petersen@oracle.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 12:03:07 +0100
Message-ID: <16430221873573@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1fbaa02dfd05229312404aaef8bc9317b4ff8750 Mon Sep 17 00:00:00 2001
From: Bart Van Assche <bvanassche@acm.org>
Date: Fri, 3 Dec 2021 15:19:46 -0800
Subject: [PATCH] scsi: ufs: Improve SCSI abort handling further

Release resources when aborting a command. Make sure that aborted commands
are completed once by clearing the corresponding tag bit from
hba->outstanding_reqs. This patch is an improved version of commit
3ff1f6b6ba6f ("scsi: ufs: core: Improve SCSI abort handling").

Link: https://lore.kernel.org/r/20211203231950.193369-14-bvanassche@acm.org
Fixes: 7a3e97b0dc4b ("[SCSI] ufshcd: UFS Host controller driver")
Tested-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 5a641610dd74..06954a6e9d5d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6984,6 +6984,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
 	unsigned long flags;
 	int err = FAILED;
+	bool outstanding;
 	u32 reg;
 
 	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
@@ -7061,6 +7062,17 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		goto release;
 	}
 
+	/*
+	 * Clear the corresponding bit from outstanding_reqs since the command
+	 * has been aborted successfully.
+	 */
+	spin_lock_irqsave(&hba->outstanding_lock, flags);
+	outstanding = __test_and_clear_bit(tag, &hba->outstanding_reqs);
+	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
+
+	if (outstanding)
+		ufshcd_release_scsi_cmd(hba, lrbp);
+
 	err = SUCCESS;
 
 release:

