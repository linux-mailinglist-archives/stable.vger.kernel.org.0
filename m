Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E36CA4F3FDD
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353473AbiDEMWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344429AbiDEKjs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:39:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259932BB21;
        Tue,  5 Apr 2022 03:25:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D216FB81C8A;
        Tue,  5 Apr 2022 10:25:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E94CC385A0;
        Tue,  5 Apr 2022 10:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649154311;
        bh=bsogIIyNX9MIbiSags7L1UOyBmoamMHwJ1JzvDC/GJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ate5Wuxhcylp5fu6r5WuFheK2l0qRte9F1kODSp8dXaLAzYGUWN66AptqlTjeAoZY
         ZEj+NFevfvMJWNb6jTPUYGjjI45uOIaseTUeWRVqa1gPe5ajaU4GFAiIUD+1w4aRgm
         u5qRWEejOxatRsR30Tva6EVOYL+Yk3BNJIdHdI04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 527/599] scsi: qla2xxx: Fix hang due to session stuck
Date:   Tue,  5 Apr 2022 09:33:41 +0200
Message-Id: <20220405070314.522972647@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,PDS_OTHER_BAD_TLD,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

commit c02aada06d19a215c8291bd968a99a270e96f734 upstream.

User experienced device lost. The log shows Get port data base command was
queued up, failed, and requeued again. Every time it is requeued, it set
the FCF_ASYNC_ACTIVE. This prevents any recovery code from occurring
because driver thinks a recovery is in progress for this session. In
essence, this session is hung.  The reason it gets into this place is the
session deletion got in front of this call due to link perturbation.

Break the requeue cycle and exit.  The session deletion code will trigger a
session relogin.

Link: https://lore.kernel.org/r/20220310092604.22950-8-njavali@marvell.com
Fixes: 726b85487067 ("qla2xxx: Add framework for async fabric discovery")
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_def.h  |    4 ++++
 drivers/scsi/qla2xxx/qla_init.c |   19 +++++++++++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -5175,4 +5175,8 @@ struct sff_8247_a0 {
 #include "qla_gbl.h"
 #include "qla_dbg.h"
 #include "qla_inline.h"
+
+#define IS_SESSION_DELETED(_fcport) (_fcport->disc_state == DSC_DELETE_PEND || \
+				      _fcport->disc_state == DSC_DELETED)
+
 #endif
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -570,6 +570,14 @@ qla2x00_async_adisc(struct scsi_qla_host
 	struct srb_iocb *lio;
 	int rval = QLA_FUNCTION_FAILED;
 
+	if (IS_SESSION_DELETED(fcport)) {
+		ql_log(ql_log_warn, vha, 0xffff,
+		       "%s: %8phC is being delete - not sending command.\n",
+		       __func__, fcport->port_name);
+		fcport->flags &= ~FCF_ASYNC_ACTIVE;
+		return rval;
+	}
+
 	if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT))
 		return rval;
 
@@ -1316,8 +1324,15 @@ int qla24xx_async_gpdb(struct scsi_qla_h
 	struct port_database_24xx *pd;
 	struct qla_hw_data *ha = vha->hw;
 
-	if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT) ||
-	    fcport->loop_id == FC_NO_LOOP_ID) {
+	if (IS_SESSION_DELETED(fcport)) {
+		ql_log(ql_log_warn, vha, 0xffff,
+		       "%s: %8phC is being delete - not sending command.\n",
+		       __func__, fcport->port_name);
+		fcport->flags &= ~FCF_ASYNC_ACTIVE;
+		return rval;
+	}
+
+	if (!vha->flags.online || fcport->flags & FCF_ASYNC_SENT) {
 		ql_log(ql_log_warn, vha, 0xffff,
 		    "%s: %8phC online %d flags %x - not sending command.\n",
 		    __func__, fcport->port_name, vha->flags.online, fcport->flags);


