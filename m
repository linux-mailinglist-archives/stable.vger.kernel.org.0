Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5844F03D8
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 16:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbiDBOVQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 10:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356158AbiDBOVQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 10:21:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A71DA12D0B1
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 07:19:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B9A7B80159
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 14:19:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7BFDC340EC;
        Sat,  2 Apr 2022 14:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648909161;
        bh=0vYapcCdsxJ1A9qqQIXy3OQ1qbk+jUjqo12RBytotzY=;
        h=Subject:To:Cc:From:Date:From;
        b=WY343OIkrdqKJBZc3IFHQRnZrfBoH9n79ClwWzjOObrQDs9zeJ/Z6ugy9R4Vh6+Gf
         djYnFM8ffKJ7+KQwNJNVxbMXLBZ6zRHbJAUoOxUC9+SR0rm7FvIUhB3ulpgprfeAgJ
         PGa1ra0bc3kE+fI0IIbX8om17snb1ysOymsXmBDg=
Subject: FAILED: patch "[PATCH] scsi: qla2xxx: Fix hang due to session stuck" failed to apply to 4.9-stable tree
To:     qutran@marvell.com, himanshu.madhani@oracle.com,
        martin.petersen@oracle.com, njavali@marvell.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 02 Apr 2022 16:19:18 +0200
Message-ID: <16489091587089@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c02aada06d19a215c8291bd968a99a270e96f734 Mon Sep 17 00:00:00 2001
From: Quinn Tran <qutran@marvell.com>
Date: Thu, 10 Mar 2022 01:25:58 -0800
Subject: [PATCH] scsi: qla2xxx: Fix hang due to session stuck

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

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index bab2f665b6c2..8aa1cccebab1 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -5438,4 +5438,8 @@ struct ql_vnd_tgt_stats_resp {
 #include "qla_gbl.h"
 #include "qla_dbg.h"
 #include "qla_inline.h"
+
+#define IS_SESSION_DELETED(_fcport) (_fcport->disc_state == DSC_DELETE_PEND || \
+				      _fcport->disc_state == DSC_DELETED)
+
 #endif
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index e468b05f90c0..5dfaa4d39cec 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -575,6 +575,14 @@ qla2x00_async_adisc(struct scsi_qla_host *vha, fc_port_t *fcport,
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
 
@@ -1338,8 +1346,15 @@ int qla24xx_async_gpdb(struct scsi_qla_host *vha, fc_port_t *fcport, u8 opt)
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

