Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E396656FCB9
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233562AbiGKJrU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233561AbiGKJqr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:46:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEEE7AA839;
        Mon, 11 Jul 2022 02:22:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3246861363;
        Mon, 11 Jul 2022 09:22:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44279C341CE;
        Mon, 11 Jul 2022 09:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531371;
        bh=472lZAJbgmvRdN1CwPSC6F/zqCZdJ5jdrQ+tHuhEiMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tzLYhUYapY6/408rqQ6FsTwwg9ebSUwJdPtfFuatoS1/oHe1X8X1kIBTSnucN0ZXH
         qxWSJCGsLkeza5sOoKoPovFVRRi46Hg/fG7deCV5Pni9gR9B5CNakaeBTU9NQPIUOo
         tEnu4N2zhaBaYcWtFA7gckqqV0zurpT6xOZhP/w0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 080/230] scsi: qla2xxx: Fix laggy FC remote port session recovery
Date:   Mon, 11 Jul 2022 11:05:36 +0200
Message-Id: <20220711090606.345572573@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit 713b415726f100f6644971e75ebfe1edbef1a390 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_def.h |  1 +
 drivers/scsi/qla2xxx/qla_os.c  | 20 +++++++++++++++++---
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 0589ab8e6467..303ad60d1d49 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -4621,6 +4621,7 @@ struct qla_hw_data {
 	struct workqueue_struct *wq;
 	struct work_struct heartbeat_work;
 	struct qlfc_fw fw_buf;
+	unsigned long last_heartbeat_run_jiffies;
 
 	/* FCP_CMND priority support */
 	struct qla_fcp_prio_cfg *fcp_prio_cfg;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index b224326bacee..12958aea893f 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -7205,7 +7205,7 @@ static bool qla_do_heartbeat(struct scsi_qla_host *vha)
 	return do_heartbeat;
 }
 
-static void qla_heart_beat(struct scsi_qla_host *vha)
+static void qla_heart_beat(struct scsi_qla_host *vha, u16 dpc_started)
 {
 	struct qla_hw_data *ha = vha->hw;
 
@@ -7215,8 +7215,19 @@ static void qla_heart_beat(struct scsi_qla_host *vha)
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
@@ -7407,6 +7418,8 @@ qla2x00_timer(struct timer_list *t)
 		start_dpc++;
 	}
 
+	/* borrowing w to signify dpc will run */
+	w = 0;
 	/* Schedule the DPC routine if needed */
 	if ((test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags) ||
 	    test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags) ||
@@ -7439,9 +7452,10 @@ qla2x00_timer(struct timer_list *t)
 		    test_bit(RELOGIN_NEEDED, &vha->dpc_flags),
 		    test_bit(PROCESS_PUREX_IOCB, &vha->dpc_flags));
 		qla2xxx_wake_dpc(vha);
+		w = 1;
 	}
 
-	qla_heart_beat(vha);
+	qla_heart_beat(vha, w);
 
 	qla2x00_restart_timer(vha, WATCH_INTERVAL);
 }
-- 
2.35.1



