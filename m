Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0839C416EBB
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 11:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244892AbhIXJSp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 05:18:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244462AbhIXJSp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 05:18:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F133B603E9;
        Fri, 24 Sep 2021 09:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632475032;
        bh=tZiFwcLLALcy0Z5F5rf2ZIML52CggYnTAR9MhKqEguk=;
        h=Subject:To:Cc:From:Date:From;
        b=2hSblBwlo28piTUHot8Z2DsvwdJU9NTBMzXHT2zk9AmKTD4nNpANbaMB3eK9UCsIe
         RL9RqzC5J1QaKxAqBUgihGpI0f0+jKrpvnN7kHMRuSJlxGU5OudLhnYH1GVUlBJRib
         MHCs61yfflIJT5Lj5FcEEM16N4717Fwg9ScjNuCA=
Subject: FAILED: patch "[PATCH] scsi: target: Fix sense key for invalid EXTENDED COPY request" failed to apply to 4.14-stable tree
To:     s.samoylenko@yadro.com, ddiss@suse.de, k.shelekhin@yadro.com,
        martin.petersen@oracle.com, r.bolshakov@yadro.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 24 Sep 2021 11:17:02 +0200
Message-ID: <1632475022145100@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0394b5048efd73b04276979d014a67f30c0ad699 Mon Sep 17 00:00:00 2001
From: Sergey Samoylenko <s.samoylenko@yadro.com>
Date: Tue, 3 Aug 2021 17:54:10 +0300
Subject: [PATCH] scsi: target: Fix sense key for invalid EXTENDED COPY request

TCM fails to pass the following tests in libiscsi:

  SCSI.ExtendedCopy.DescrType
  SCSI.ExtendedCopy.DescrLimits
  SCSI.ExtendedCopy.ParamHdr
  SCSI.ExtendedCopy.ValidSegDescr
  SCSI.ExtendedCopy.ValidTgtDescr

The xcopy code always returns the same NOT READY sense key for all detected
errors. Change the sense key for invalid requests to ILLEGAL REQUEST, and
for aborted transfers to COPY ABORTED.

Link: https://lore.kernel.org/r/20210803145410.80147-3-s.samoylenko@yadro.com
Fixes: d877d7275be3 ("target: Fix a deadlock between the XCOPY code and iSCSI session shutdown")
Reviewed-by: David Disseldorp <ddiss@suse.de>
Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
Reviewed-by: Konstantin Shelekhin <k.shelekhin@yadro.com>
Signed-off-by: Sergey Samoylenko <s.samoylenko@yadro.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 0f1319336f3e..d4fe7cb2bd00 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -674,12 +674,16 @@ static void target_xcopy_do_work(struct work_struct *work)
 	unsigned int max_sectors;
 	int rc = 0;
 	unsigned short nolb, max_nolb, copied_nolb = 0;
+	sense_reason_t sense_rc;
 
-	if (target_parse_xcopy_cmd(xop) != TCM_NO_SENSE)
+	sense_rc = target_parse_xcopy_cmd(xop);
+	if (sense_rc != TCM_NO_SENSE)
 		goto err_free;
 
-	if (WARN_ON_ONCE(!xop->src_dev) || WARN_ON_ONCE(!xop->dst_dev))
+	if (WARN_ON_ONCE(!xop->src_dev) || WARN_ON_ONCE(!xop->dst_dev)) {
+		sense_rc = TCM_INVALID_PARAMETER_LIST;
 		goto err_free;
+	}
 
 	src_dev = xop->src_dev;
 	dst_dev = xop->dst_dev;
@@ -762,20 +766,20 @@ static void target_xcopy_do_work(struct work_struct *work)
 	return;
 
 out:
+	/*
+	 * The XCOPY command was aborted after some data was transferred.
+	 * Terminate command with CHECK CONDITION status, with the sense key
+	 * set to COPY ABORTED.
+	 */
+	sense_rc = TCM_COPY_TARGET_DEVICE_NOT_REACHABLE;
 	xcopy_pt_undepend_remotedev(xop);
 	target_free_sgl(xop->xop_data_sg, xop->xop_data_nents);
 
 err_free:
 	kfree(xop);
-	/*
-	 * Don't override an error scsi status if it has already been set
-	 */
-	if (ec_cmd->scsi_status == SAM_STAT_GOOD) {
-		pr_warn_ratelimited("target_xcopy_do_work: rc: %d, Setting X-COPY"
-			" CHECK_CONDITION -> sending response\n", rc);
-		ec_cmd->scsi_status = SAM_STAT_CHECK_CONDITION;
-	}
-	target_complete_cmd(ec_cmd, ec_cmd->scsi_status);
+	pr_warn_ratelimited("target_xcopy_do_work: rc: %d, sense: %u, XCOPY operation failed\n",
+			   rc, sense_rc);
+	target_complete_cmd_with_sense(ec_cmd, SAM_STAT_CHECK_CONDITION, sense_rc);
 }
 
 /*

