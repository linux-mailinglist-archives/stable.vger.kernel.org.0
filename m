Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE7B594197
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345028AbiHOVZa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345214AbiHOVXp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:23:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD59E7244;
        Mon, 15 Aug 2022 12:22:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DDB061029;
        Mon, 15 Aug 2022 19:22:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DAE1C433C1;
        Mon, 15 Aug 2022 19:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591346;
        bh=M/ohy5nRZZWVPrSGlZ5Tz1xX6F3zlQOz05L6jXLL4YU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WRxdqRwRZuYTP+DfOynBEeWoJO8cH3Uc/kJxuKKcDn1BdtQfJw0qXiff89OhzU/ji
         uBoKMrdIKfl7Ia6S70bBh7EuC+BWYOned97B6qZcbN+lrXwlSQZ4bS6SHPN05AQcK4
         zehys4GCuM6stl9XIrMzDT69+vorqa7NtOrDqTsA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0551/1095] scsi: qla2xxx: edif: Fix potential stuck session in sa update
Date:   Mon, 15 Aug 2022 19:59:10 +0200
Message-Id: <20220815180452.349253008@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
index d9e3f145b162..166647d4ab27 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -2332,6 +2332,7 @@ edif_doorbell_show(struct device *dev, struct device_attribute *attr,
 
 static void qla_noop_sp_done(srb_t *sp, int res)
 {
+	sp->fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
 	/* ref: INIT */
 	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 }
@@ -2356,7 +2357,8 @@ qla24xx_issue_sa_replace_iocb(scsi_qla_host_t *vha, struct qla_work_evt *e)
 	if (!sa_ctl) {
 		ql_dbg(ql_dbg_edif, vha, 0x70e6,
 		    "sa_ctl allocation failed\n");
-		return -ENOMEM;
+		rval =  -ENOMEM;
+		goto done;
 	}
 
 	fcport = sa_ctl->fcport;
@@ -2366,7 +2368,8 @@ qla24xx_issue_sa_replace_iocb(scsi_qla_host_t *vha, struct qla_work_evt *e)
 	if (!sp) {
 		ql_dbg(ql_dbg_edif, vha, 0x70e6,
 		 "SRB allocation failed\n");
-		return -ENOMEM;
+		rval = -ENOMEM;
+		goto done;
 	}
 
 	fcport->flags |= FCF_ASYNC_SENT;
@@ -2395,9 +2398,17 @@ qla24xx_issue_sa_replace_iocb(scsi_qla_host_t *vha, struct qla_work_evt *e)
 
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



