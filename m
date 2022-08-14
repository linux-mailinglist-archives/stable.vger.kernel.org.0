Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A834591F7C
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 12:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbiHNKOy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 06:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiHNKOx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 06:14:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D704205C3
        for <stable@vger.kernel.org>; Sun, 14 Aug 2022 03:14:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1ADE660F73
        for <stable@vger.kernel.org>; Sun, 14 Aug 2022 10:14:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 230AEC433C1;
        Sun, 14 Aug 2022 10:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660472091;
        bh=OU3ZEYlBJWnns706bfpXvZ/d2CW3hnwgo7Mx/3l9b9E=;
        h=Subject:To:Cc:From:Date:From;
        b=zGtmtoIbvPg+oa7IgaeZmpmkWl6avEjT3v8a1VKNeouJJy7Q2CZsyukwkxaeS0zJr
         f50sZD+DgL2N61jvm4syaKM1TRShxf5qIwh/HEvpT2z7EBZV7IyI5X2E0XszVaJ90w
         k8vjkjdI5o518/6QHUoauleDUFSalD6xs5r0xXKo=
Subject: FAILED: patch "[PATCH] scsi: qla2xxx: Fix losing target when it reappears during" failed to apply to 5.10-stable tree
To:     aeasi@marvell.com, martin.petersen@oracle.com, njavali@marvell.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 14 Aug 2022 12:14:48 +0200
Message-ID: <166047208816645@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 118b0c863c8f5629cc5271fc24d72d926e0715d9 Mon Sep 17 00:00:00 2001
From: Arun Easi <aeasi@marvell.com>
Date: Wed, 15 Jun 2022 22:35:04 -0700
Subject: [PATCH] scsi: qla2xxx: Fix losing target when it reappears during
 delete

FC target disappeared during port perturbation tests due to a race that
tramples target state.  Fix the issue by adding state checks before
proceeding.

Link: https://lore.kernel.org/r/20220616053508.27186-8-njavali@marvell.com
Fixes: 44c57f205876 ("scsi: qla2xxx: Changes to support FCP2 Target")
Cc: stable@vger.kernel.org
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 8b87fefda423..feca9e44b21c 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2714,17 +2714,24 @@ qla2x00_dev_loss_tmo_callbk(struct fc_rport *rport)
 	if (!fcport)
 		return;
 
-	/* Now that the rport has been deleted, set the fcport state to
-	   FCS_DEVICE_DEAD */
-	qla2x00_set_fcport_state(fcport, FCS_DEVICE_DEAD);
+
+	/*
+	 * Now that the rport has been deleted, set the fcport state to
+	 * FCS_DEVICE_DEAD, if the fcport is still lost.
+	 */
+	if (fcport->scan_state != QLA_FCPORT_FOUND)
+		qla2x00_set_fcport_state(fcport, FCS_DEVICE_DEAD);
 
 	/*
 	 * Transport has effectively 'deleted' the rport, clear
 	 * all local references.
 	 */
 	spin_lock_irqsave(host->host_lock, flags);
-	fcport->rport = fcport->drport = NULL;
-	*((fc_port_t **)rport->dd_data) = NULL;
+	/* Confirm port has not reappeared before clearing pointers. */
+	if (rport->port_state != FC_PORTSTATE_ONLINE) {
+		fcport->rport = fcport->drport = NULL;
+		*((fc_port_t **)rport->dd_data) = NULL;
+	}
 	spin_unlock_irqrestore(host->host_lock, flags);
 
 	if (test_bit(ABORT_ISP_ACTIVE, &fcport->vha->dpc_flags))
@@ -2757,9 +2764,12 @@ qla2x00_terminate_rport_io(struct fc_rport *rport)
 	/*
 	 * At this point all fcport's software-states are cleared.  Perform any
 	 * final cleanup of firmware resources (PCBs and XCBs).
+	 *
+	 * Attempt to cleanup only lost devices.
 	 */
 	if (fcport->loop_id != FC_NO_LOOP_ID) {
-		if (IS_FWI2_CAPABLE(fcport->vha->hw)) {
+		if (IS_FWI2_CAPABLE(fcport->vha->hw) &&
+		    fcport->scan_state != QLA_FCPORT_FOUND) {
 			if (fcport->loop_id != FC_NO_LOOP_ID)
 				fcport->logout_on_delete = 1;
 
@@ -2769,7 +2779,7 @@ qla2x00_terminate_rport_io(struct fc_rport *rport)
 				       __LINE__);
 				qlt_schedule_sess_for_deletion(fcport);
 			}
-		} else {
+		} else if (!IS_FWI2_CAPABLE(fcport->vha->hw)) {
 			qla2x00_port_logout(fcport->vha, fcport);
 		}
 	}

