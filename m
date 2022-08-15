Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C497959387E
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245308AbiHOTHI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343537AbiHOTGe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:06:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87904F18A;
        Mon, 15 Aug 2022 11:35:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B6D0B8105D;
        Mon, 15 Aug 2022 18:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14424C433C1;
        Mon, 15 Aug 2022 18:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588507;
        bh=xuBhzV4jFujLSQZDG0nTbqRsXfUJtHiN4aWTe+yiPow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zdfv9y/FVl7WqxznSHJIdSYn13LxpUwJ5+MtsDq+w+cx7j6S9k6H8736stQBR4dHS
         9FlWnNl+Hjj+AGpBBpxKo5TlPM9JM3ZeKYyBhj8N4aggSEcU54H9o82FM7S6OpQ/K3
         KnVTfxCU7ZuMl4XUZ81fUdrYnHckpuyDGrkWFD7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 395/779] scsi: qla2xxx: edif: Fix potential stuck session in sa update
Date:   Mon, 15 Aug 2022 20:00:39 +0200
Message-Id: <20220815180354.155378571@linuxfoundation.org>
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

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit e0fb8ce2bb9e52c846e54ad2c58b5b7beb13eb09 ]

When a thread is in the process of reestablish a session, a flag is set to
prevent multiple threads/triggers from doing the same task. This flag was
left on, and any attempt to relogin was locked out. Clear this flag if the
attempt has failed.

Link: https://lore.kernel.org/r/20220607044627.19563-6-njavali@marvell.com
Fixes: dd30706e73b7 ("scsi: qla2xxx: edif: Add key update")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_edif.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index e42141635377..4be876dd9f6b 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -2187,6 +2187,7 @@ edif_doorbell_show(struct device *dev, struct device_attribute *attr,
 
 static void qla_noop_sp_done(srb_t *sp, int res)
 {
+	sp->fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
 	/* ref: INIT */
 	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 }
@@ -2211,7 +2212,8 @@ qla24xx_issue_sa_replace_iocb(scsi_qla_host_t *vha, struct qla_work_evt *e)
 	if (!sa_ctl) {
 		ql_dbg(ql_dbg_edif, vha, 0x70e6,
 		    "sa_ctl allocation failed\n");
-		return -ENOMEM;
+		rval =  -ENOMEM;
+		goto done;
 	}
 
 	fcport = sa_ctl->fcport;
@@ -2221,7 +2223,8 @@ qla24xx_issue_sa_replace_iocb(scsi_qla_host_t *vha, struct qla_work_evt *e)
 	if (!sp) {
 		ql_dbg(ql_dbg_edif, vha, 0x70e6,
 		 "SRB allocation failed\n");
-		return -ENOMEM;
+		rval = -ENOMEM;
+		goto done;
 	}
 
 	fcport->flags |= FCF_ASYNC_SENT;
@@ -2250,9 +2253,17 @@ qla24xx_issue_sa_replace_iocb(scsi_qla_host_t *vha, struct qla_work_evt *e)
 
 	rval = qla2x00_start_sp(sp);
 
-	if (rval != QLA_SUCCESS)
+	if (rval != QLA_SUCCESS) {
 		rval = QLA_FUNCTION_FAILED;
+		goto done_free_sp;
+	}
 
+	return rval;
+done_free_sp:
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
+	fcport->flags &= ~FCF_ASYNC_SENT;
+done:
+	fcport->flags &= ~FCF_ASYNC_ACTIVE;
 	return rval;
 }
 
-- 
2.35.1



