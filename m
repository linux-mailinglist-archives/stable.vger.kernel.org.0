Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8786658058
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233243AbiL1QRg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:17:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234439AbiL1QQb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:16:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05FFC1A073
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:14:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9687761542
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:14:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC658C433D2;
        Wed, 28 Dec 2022 16:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244054;
        bh=dMN5Q7m52tojfegZXymmSIt4atun6xby12AgY7U1aCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QhNsbSbAG3vnC0jbRBKTupNcoW58d72yy46O3K1fznfya18UgsVs3wnzsi3GoX+WA
         ypqbnjMo6dAYvnLoT8exe4u3ZzIyK/7UC/l2bGxy6Ls5lKpNgC0/mlZWN/xy5w/B9S
         f5Trw5I5Emc2sbMkV5WffvgnshaF1xuz4VnOelwY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Arun Easi <arun.easi@qlogic.com>,
        Giridhar Malavali <giridhar.malavali@qlogic.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0602/1146] scsi: qla2xxx: Fix set-but-not-used variable warnings
Date:   Wed, 28 Dec 2022 15:35:41 +0100
Message-Id: <20221228144346.524800032@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 4fb2169d66b837a2986f569f5d5b81f79e6e4a4c ]

Fix the following two compiler warnings:

drivers/scsi/qla2xxx/qla_init.c: In function ‘qla24xx_async_abort_cmd’:
drivers/scsi/qla2xxx/qla_init.c:171:17: warning: variable ‘bail’ set but not used [-Wunused-but-set-variable]
  171 |         uint8_t bail;
      |                 ^~~~
drivers/scsi/qla2xxx/qla_init.c: In function ‘qla2x00_async_tm_cmd’:
drivers/scsi/qla2xxx/qla_init.c:2023:17: warning: variable ‘bail’ set but not used [-Wunused-but-set-variable]
 2023 |         uint8_t bail;
      |                 ^~~~

Cc: Arun Easi <arun.easi@qlogic.com>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
Fixes: feafb7b1714c ("[SCSI] qla2xxx: Fix vport delete issues")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20221031224818.2607882-1-bvanassche@acm.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_def.h    | 22 +++++++++++-----------
 drivers/scsi/qla2xxx/qla_init.c   |  6 ++----
 drivers/scsi/qla2xxx/qla_inline.h |  4 +---
 drivers/scsi/qla2xxx/qla_os.c     |  4 +---
 4 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 802eec6407d9..a26a373be9da 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -5136,17 +5136,17 @@ struct secure_flash_update_block_pk {
 		(test_bit(ISP_ABORT_NEEDED, &ha->dpc_flags) || \
 			 test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags))
 
-#define QLA_VHA_MARK_BUSY(__vha, __bail) do {		\
-	atomic_inc(&__vha->vref_count);			\
-	mb();						\
-	if (__vha->flags.delete_progress) {		\
-		atomic_dec(&__vha->vref_count);		\
-		wake_up(&__vha->vref_waitq);		\
-		__bail = 1;				\
-	} else {					\
-		__bail = 0;				\
-	}						\
-} while (0)
+static inline bool qla_vha_mark_busy(scsi_qla_host_t *vha)
+{
+	atomic_inc(&vha->vref_count);
+	mb();
+	if (vha->flags.delete_progress) {
+		atomic_dec(&vha->vref_count);
+		wake_up(&vha->vref_waitq);
+		return true;
+	}
+	return false;
+}
 
 #define QLA_VHA_MARK_NOT_BUSY(__vha) do {		\
 	atomic_dec(&__vha->vref_count);			\
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index e12db95de688..631993504a76 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -168,7 +168,6 @@ int qla24xx_async_abort_cmd(srb_t *cmd_sp, bool wait)
 	struct srb_iocb *abt_iocb;
 	srb_t *sp;
 	int rval = QLA_FUNCTION_FAILED;
-	uint8_t bail;
 
 	/* ref: INIT for ABTS command */
 	sp = qla2xxx_get_qpair_sp(cmd_sp->vha, cmd_sp->qpair, cmd_sp->fcport,
@@ -176,7 +175,7 @@ int qla24xx_async_abort_cmd(srb_t *cmd_sp, bool wait)
 	if (!sp)
 		return QLA_MEMORY_ALLOC_FAILED;
 
-	QLA_VHA_MARK_BUSY(vha, bail);
+	qla_vha_mark_busy(vha);
 	abt_iocb = &sp->u.iocb_cmd;
 	sp->type = SRB_ABT_CMD;
 	sp->name = "abort";
@@ -2020,14 +2019,13 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t flags, uint32_t lun,
 	struct srb_iocb *tm_iocb;
 	srb_t *sp;
 	int rval = QLA_FUNCTION_FAILED;
-	uint8_t bail;
 
 	/* ref: INIT */
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp)
 		goto done;
 
-	QLA_VHA_MARK_BUSY(vha, bail);
+	qla_vha_mark_busy(vha);
 	sp->type = SRB_TM_CMD;
 	sp->name = "tmf";
 	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha),
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index db17f7f410cd..5185dc5daf80 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -225,11 +225,9 @@ static inline srb_t *
 qla2x00_get_sp(scsi_qla_host_t *vha, fc_port_t *fcport, gfp_t flag)
 {
 	srb_t *sp = NULL;
-	uint8_t bail;
 	struct qla_qpair *qpair;
 
-	QLA_VHA_MARK_BUSY(vha, bail);
-	if (unlikely(bail))
+	if (unlikely(qla_vha_mark_busy(vha)))
 		return NULL;
 
 	qpair = vha->hw->base_qpair;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 2c85f3cce726..96ba1398f20c 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5069,13 +5069,11 @@ struct qla_work_evt *
 qla2x00_alloc_work(struct scsi_qla_host *vha, enum qla_work_type type)
 {
 	struct qla_work_evt *e;
-	uint8_t bail;
 
 	if (test_bit(UNLOADING, &vha->dpc_flags))
 		return NULL;
 
-	QLA_VHA_MARK_BUSY(vha, bail);
-	if (bail)
+	if (qla_vha_mark_busy(vha))
 		return NULL;
 
 	e = kzalloc(sizeof(struct qla_work_evt), GFP_ATOMIC);
-- 
2.35.1



