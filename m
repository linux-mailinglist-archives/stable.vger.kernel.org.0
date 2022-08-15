Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C12B593AE4
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344831AbiHOTrg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344820AbiHOTo4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:44:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7FAD6C77C;
        Mon, 15 Aug 2022 11:48:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07649B81085;
        Mon, 15 Aug 2022 18:48:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BF20C433D6;
        Mon, 15 Aug 2022 18:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589310;
        bh=za6LKnhUJdxSuV7U5K0XsjjVK4rZw9f/Aesz5mtYlSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pplMujBReiJ/GsvOrHu+8ctGBQhBDkbAG3obKxsnImzYlsqz05QmtpYhESvzcp8iK
         yTuAKA1YBGpW7Lb4luHbbYrAXf+ZdtXcS38Uu/0gvZgKI5gwXeCN6gmYU4YY4vnpCh
         xUmriG/889kRAdsqXfJUx6/tZIvqEob64esDX+hQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 679/779] scsi: qla2xxx: Fix losing target when it reappears during delete
Date:   Mon, 15 Aug 2022 20:05:23 +0200
Message-Id: <20220815180406.381381897@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Arun Easi <aeasi@marvell.com>

commit 118b0c863c8f5629cc5271fc24d72d926e0715d9 upstream.

FC target disappeared during port perturbation tests due to a race that
tramples target state.  Fix the issue by adding state checks before
proceeding.

Link: https://lore.kernel.org/r/20220616053508.27186-8-njavali@marvell.com
Fixes: 44c57f205876 ("scsi: qla2xxx: Changes to support FCP2 Target")
Cc: stable@vger.kernel.org
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_attr.c |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2705,17 +2705,24 @@ qla2x00_dev_loss_tmo_callbk(struct fc_rp
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
@@ -2748,9 +2755,12 @@ qla2x00_terminate_rport_io(struct fc_rpo
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
 
@@ -2760,7 +2770,7 @@ qla2x00_terminate_rport_io(struct fc_rpo
 				       __LINE__);
 				qlt_schedule_sess_for_deletion(fcport);
 			}
-		} else {
+		} else if (!IS_FWI2_CAPABLE(fcport->vha->hw)) {
 			qla2x00_port_logout(fcport->vha, fcport);
 		}
 	}


