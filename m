Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA2F4F3483
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237834AbiDEInY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241118AbiDEIcv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773B515FC5;
        Tue,  5 Apr 2022 01:28:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B55EB81BB1;
        Tue,  5 Apr 2022 08:28:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85713C385A1;
        Tue,  5 Apr 2022 08:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147282;
        bh=n6zyPSIkFvCLdD5kBxfGwkFctlLJmjTygZHO/L9jPmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VQZ1WBV8VT70h/RqjJAU/X+MYi8j0KE1AgtbQi0vHY+CegS0LzC6RZD0Gj7BCNRha
         4TGYBybsn3kcOhHHrHgu+XF/KaxTS2BDc3D/hqwW/PGGYd7Y32VLuzHxBDxsysYBTz
         2ople1gqFchIN8RApGg5D134HPbGyIqzyVn8iydg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ewan Milne <emilne@redhat.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.17 1068/1126] scsi: qla2xxx: Add qla2x00_async_done() for async routines
Date:   Tue,  5 Apr 2022 09:30:15 +0200
Message-Id: <20220405070438.805070642@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Saurav Kashyap <skashyap@marvell.com>

commit 49b729f58e7a98a006a8a0c1dcca8a1a4f58d2a8 upstream.

This done routine will delete the timer and check for its return value and
decrease the reference count accordingly. This prevents boot hangs reported
after commit 31e6cdbe0eae ("scsi: qla2xxx: Implement ref count for SRB")
was merged.

Link: https://lore.kernel.org/r/20220208093946.4471-1-njavali@marvell.com
Fixes: 31e6cdbe0eae ("scsi: qla2xxx: Implement ref count for SRB")
Reported-by: Ewan Milne <emilne@redhat.com>
Tested-by: Ewan D. Milne <emilne@redhat.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_iocb.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2560,6 +2560,20 @@ qla24xx_tm_iocb(srb_t *sp, struct tsk_mg
 	}
 }
 
+static void
+qla2x00_async_done(struct srb *sp, int res)
+{
+	if (del_timer(&sp->u.iocb_cmd.timer)) {
+		/*
+		 * Successfully cancelled the timeout handler
+		 * ref: TMR
+		 */
+		if (kref_put(&sp->cmd_kref, qla2x00_sp_release))
+			return;
+	}
+	sp->async_done(sp, res);
+}
+
 void
 qla2x00_sp_release(struct kref *kref)
 {
@@ -2573,7 +2587,8 @@ qla2x00_init_async_sp(srb_t *sp, unsigne
 		     void (*done)(struct srb *sp, int res))
 {
 	timer_setup(&sp->u.iocb_cmd.timer, qla2x00_sp_timeout, 0);
-	sp->done = done;
+	sp->done = qla2x00_async_done;
+	sp->async_done = done;
 	sp->free = qla2x00_sp_free;
 	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
 	sp->u.iocb_cmd.timer.expires = jiffies + tmo * HZ;


