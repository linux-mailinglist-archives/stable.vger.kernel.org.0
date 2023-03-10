Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEC3A6B44A5
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbjCJO0i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:26:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232298AbjCJOZ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:25:58 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9098121424
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:24:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 84148CE290B
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:24:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F2BCC433EF;
        Fri, 10 Mar 2023 14:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458290;
        bh=dFFnYWNH6p6V0I14njU81TTx5Jya2NBou9Ite9yM/Tk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IHwthOL3mjWoV7sblHLyzhivmL8dGtgUt+t745k3E2a6avfLySSfjoRqn8WA2xS54
         arZnyQ53Gy0GhIcS3rFGUrXRfeExqZHu+C5uROGvVbFkDOnVhUeCdjuCyWauJais0n
         MyeXIWvtCLxRvcJ1uaTEhBNFBShWTOgfLmhCDebo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.19 186/252] scsi: qla2xxx: Fix link failure in NPIV environment
Date:   Fri, 10 Mar 2023 14:39:16 +0100
Message-Id: <20230310133724.545186458@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

commit b1ae65c082f74536ec292b15766f2846f0238373 upstream.

User experienced symptoms of adapter failure in NPIV environment. NPIV
hosts were allowed to trigger chip reset back to back due to NPIV link
state being slow to come online.

Fix link failure in NPIV environment by removing NPIV host from directly
being able to perform chip reset.

 kernel: qla2xxx [0000:04:00.1]-6009:261: Loop down - aborting ISP.
 kernel: qla2xxx [0000:04:00.1]-6009:262: Loop down - aborting ISP.
 kernel: qla2xxx [0000:04:00.1]-6009:281: Loop down - aborting ISP.
 kernel: qla2xxx [0000:04:00.1]-6009:285: Loop down - aborting ISP

Fixes: 0d6e61bc6a4f ("[SCSI] qla2xxx: Correct various NPIV issues.")
Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_os.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -6384,7 +6384,7 @@ qla2x00_timer(struct timer_list *t)
 
 		/* if the loop has been down for 4 minutes, reinit adapter */
 		if (atomic_dec_and_test(&vha->loop_down_timer) != 0) {
-			if (!(vha->device_flags & DFLG_NO_CABLE)) {
+			if (!(vha->device_flags & DFLG_NO_CABLE) && !vha->vp_idx) {
 				ql_log(ql_log_warn, vha, 0x6009,
 				    "Loop down - aborting ISP.\n");
 


