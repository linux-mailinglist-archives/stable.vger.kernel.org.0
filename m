Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3264F03DD
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 16:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356168AbiDBOVd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 10:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356158AbiDBOVc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 10:21:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E07E812D0B1
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 07:19:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4163C615A5
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 14:19:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53F0AC340EC;
        Sat,  2 Apr 2022 14:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648909179;
        bh=2PaPRAm+xd4Fl7dRqGgc1RxuhmRXHVCKERCe4iax2p8=;
        h=Subject:To:Cc:From:Date:From;
        b=HhQuDyumSq4MJ9glsKFI/xPeZGnnCWmQHGYT4K3a8w8jmA5vJwxr0kdDesdg0fSwf
         JisSU32LyMEw48pkEdJbK8Q8/9Q37CUM87144w2MgdF/ztMiu2e8kuJ4KSXHIunwV0
         IzqlPSpa/Aunfw2rzLuQ0OKATGLfI2Q5QHCgBpoI=
Subject: FAILED: patch "[PATCH] scsi: qla2xxx: Fix laggy FC remote port session recovery" failed to apply to 5.15-stable tree
To:     qutran@marvell.com, himanshu.madhani@oracle.com,
        martin.petersen@oracle.com, njavali@marvell.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 02 Apr 2022 16:19:37 +0200
Message-ID: <1648909177183161@kroah.com>
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

From 713b415726f100f6644971e75ebfe1edbef1a390 Mon Sep 17 00:00:00 2001
From: Quinn Tran <qutran@marvell.com>
Date: Thu, 10 Mar 2022 01:25:59 -0800
Subject: [PATCH] scsi: qla2xxx: Fix laggy FC remote port session recovery

For session recovery, driver relies on the dpc thread to initiate certain
operations. The dpc thread runs exclusively without the Mailbox interface
being occupied. A recent code change for heartbeat check via mailbox cmd 0
is preventing the dpc thread from carrying out its operation. This patch
allows the higher priority error recovery to run first before running the
lower priority heartbeat check.

Link: https://lore.kernel.org/r/20220310092604.22950-9-njavali@marvell.com
Fixes: d94d8158e184 ("scsi: qla2xxx: Add heartbeat check")
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 8aa1cccebab1..d76c0e9f114c 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -4624,6 +4624,7 @@ struct qla_hw_data {
 	struct workqueue_struct *wq;
 	struct work_struct heartbeat_work;
 	struct qlfc_fw fw_buf;
+	unsigned long last_heartbeat_run_jiffies;
 
 	/* FCP_CMND priority support */
 	struct qla_fcp_prio_cfg *fcp_prio_cfg;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 9c4f2b38b34e..81451c11eef4 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -7215,7 +7215,7 @@ static bool qla_do_heartbeat(struct scsi_qla_host *vha)
 	return do_heartbeat;
 }
 
-static void qla_heart_beat(struct scsi_qla_host *vha)
+static void qla_heart_beat(struct scsi_qla_host *vha, u16 dpc_started)
 {
 	struct qla_hw_data *ha = vha->hw;
 
@@ -7225,8 +7225,19 @@ static void qla_heart_beat(struct scsi_qla_host *vha)
 	if (vha->hw->flags.eeh_busy || qla2x00_chip_is_down(vha))
 		return;
 
-	if (qla_do_heartbeat(vha))
+	/*
+	 * dpc thread cannot run if heartbeat is running at the same time.
+	 * We also do not want to starve heartbeat task. Therefore, do
+	 * heartbeat task at least once every 5 seconds.
+	 */
+	if (dpc_started &&
+	    time_before(jiffies, ha->last_heartbeat_run_jiffies + 5 * HZ))
+		return;
+
+	if (qla_do_heartbeat(vha)) {
+		ha->last_heartbeat_run_jiffies = jiffies;
 		queue_work(ha->wq, &ha->heartbeat_work);
+	}
 }
 
 /**************************************************************************
@@ -7417,6 +7428,8 @@ qla2x00_timer(struct timer_list *t)
 		start_dpc++;
 	}
 
+	/* borrowing w to signify dpc will run */
+	w = 0;
 	/* Schedule the DPC routine if needed */
 	if ((test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags) ||
 	    test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags) ||
@@ -7449,9 +7462,10 @@ qla2x00_timer(struct timer_list *t)
 		    test_bit(RELOGIN_NEEDED, &vha->dpc_flags),
 		    test_bit(PROCESS_PUREX_IOCB, &vha->dpc_flags));
 		qla2xxx_wake_dpc(vha);
+		w = 1;
 	}
 
-	qla_heart_beat(vha);
+	qla_heart_beat(vha, w);
 
 	qla2x00_restart_timer(vha, WATCH_INTERVAL);
 }

