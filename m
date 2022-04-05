Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEEE14F39F4
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378906AbiDELjo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354195AbiDEKMP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:12:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67AF452E7C;
        Tue,  5 Apr 2022 02:58:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A097B81B18;
        Tue,  5 Apr 2022 09:58:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92BE2C385A1;
        Tue,  5 Apr 2022 09:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152701;
        bh=n6zyPSIkFvCLdD5kBxfGwkFctlLJmjTygZHO/L9jPmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MZPPJBgI9AIlOcBs/rK/flSSH3mO4pmSTfyfUjR0r6P/UOnveedrYERVu5V2RJpPQ
         EaSsFmNC3xv5WylzvHaF1cf+sUbT1Bb0qvtKWXUqxwP+hzyt3qUjAnZAhf+QoXesfO
         i4rCA+YSr6d1CwSlWwyW+o6rpZcV+bvRb1rVokd0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ewan Milne <emilne@redhat.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 865/913] scsi: qla2xxx: Add qla2x00_async_done() for async routines
Date:   Tue,  5 Apr 2022 09:32:07 +0200
Message-Id: <20220405070405.752209504@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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


