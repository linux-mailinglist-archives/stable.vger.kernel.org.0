Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 563934FB4F6
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 09:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242696AbiDKHe2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 03:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245469AbiDKHe1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 03:34:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEC933D4A2
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 00:32:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B3A661449
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 07:32:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EAB6C385A5;
        Mon, 11 Apr 2022 07:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649662332;
        bh=hIuRAoykLqp70bAI53kz7UiKf5uzAkmj9htOZ7m76O4=;
        h=Subject:To:Cc:From:Date:From;
        b=R3pmSygbwNp5wZyMIJo+NcIzCx5HoIOiVIqBoxn5YY/ghde6+Tb4Nl7uEjFQzmX0A
         4mxv+0slx06LuBcFEzvlSv2uYZKyMI+KVT3vNbtP+R44JlyNTH9UVZfsHuWInUUEqf
         xar4V79rh3IY7moAoY86xRTELItprKL7dfYsUvrs=
Subject: FAILED: patch "[PATCH] scsi: lpfc: Fix broken SLI4 abort path" failed to apply to 5.15-stable tree
To:     jsmart2021@gmail.com, dick.kennedy@broadcom.com,
        martin.petersen@oracle.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Apr 2022 09:31:59 +0200
Message-ID: <164966231911081@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7294a9bcaa7ee0d3b96aab1a277317315fd46f09 Mon Sep 17 00:00:00 2001
From: James Smart <jsmart2021@gmail.com>
Date: Wed, 23 Mar 2022 13:55:44 -0700
Subject: [PATCH] scsi: lpfc: Fix broken SLI4 abort path

There was a merge error in ther 14.2.0.0 patches that resulted in the SLI4
path using the SLI3 issue_abort_iotag() routine. This resulted in txcmplq
corruption.

Fix to use the SLI4 routine when SLI4.

Link: https://lore.kernel.org/r/20220323205545.81814-2-jsmart2021@gmail.com
Fixes: 31a59f75702f ("scsi: lpfc: SLI path split: Refactor Abort paths")
Cc: <stable@vger.kernel.org> # v5.2+
Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 3c132604fd91..ba9dbb51b75f 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5929,13 +5929,15 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 	}
 
 	lpfc_cmd->waitq = &waitq;
-	if (phba->sli_rev == LPFC_SLI_REV4)
+	if (phba->sli_rev == LPFC_SLI_REV4) {
 		spin_unlock(&pring_s4->ring_lock);
-	else
+		ret_val = lpfc_sli4_issue_abort_iotag(phba, iocb,
+						      lpfc_sli_abort_fcp_cmpl);
+	} else {
 		pring = &phba->sli.sli3_ring[LPFC_FCP_RING];
-
-	ret_val = lpfc_sli_issue_abort_iotag(phba, pring, iocb,
-					     lpfc_sli_abort_fcp_cmpl);
+		ret_val = lpfc_sli_issue_abort_iotag(phba, pring, iocb,
+						     lpfc_sli_abort_fcp_cmpl);
+	}
 
 	/* Make sure HBA is alive */
 	lpfc_issue_hb_tmo(phba);

