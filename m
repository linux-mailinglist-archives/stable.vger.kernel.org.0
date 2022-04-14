Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B91D45012AE
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244859AbiDNNgV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343619AbiDNN3m (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:29:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35851AFB1C;
        Thu, 14 Apr 2022 06:25:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C50B760C14;
        Thu, 14 Apr 2022 13:24:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2692C385A1;
        Thu, 14 Apr 2022 13:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942699;
        bh=DvO4Q6O1F3LvL6SxTGWGFwRMZo0rx/7YfcpZ+33sstM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v3maDFtUOODx6gnvQ3dunUTy1d5dz2PCteVgzpDijlQs1XbHigV3rWob3Zk6zH0Uz
         9PhBEK+84yU7Kbff1JVTdmGSzjNdf/qI+UscxRAxxQB1/eUFHmTMw+nYxWmXd8wnux
         /x2QKqQ3po/vtOL8mCtlCjbHEFT29NhuiDB/4UR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.19 228/338] scsi: qla2xxx: Fix hang due to session stuck
Date:   Thu, 14 Apr 2022 15:12:11 +0200
Message-Id: <20220414110845.380562740@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
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
@@ -4655,4 +4655,8 @@ struct sff_8247_a0 {
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
@@ -891,6 +891,14 @@ int qla24xx_async_gnl(struct scsi_qla_ho
 	unsigned long flags;
 	u16 *mb;
 
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
 
@@ -1121,8 +1129,15 @@ int qla24xx_async_gpdb(struct scsi_qla_h
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
 		    "%s: %8phC - not sending command.\n",
 		    __func__, fcport->port_name);


