Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5D246C0732
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 01:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbjCTAzj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 20:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbjCTAzL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 20:55:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 286E01F907;
        Sun, 19 Mar 2023 17:54:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5828611D6;
        Mon, 20 Mar 2023 00:53:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F80CC4339C;
        Mon, 20 Mar 2023 00:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679273608;
        bh=4TpS2ck6/FTfQW0o83O+XR+ySNUdGqlztpf3ktSMs/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RJjBgBFetgk+y4HrSE9+Ah+OEBGJwooCiuEhr2ZBxZcx/vLqvHsWxOdF9u2P0j+TU
         mph62uNZxIHmuf01gF5XyUa9R9euNO7Z8mWztn/dLJbNHzCrTfN2ft8vpmN2kbU/po
         FpDs+zpneqL379RwZhfXSgvWTHQehoxCcn46CWfP2fhETSSsC44iVF9CK0K8uQduIJ
         8Q2TUnim4r8MftgAUkC0OUbciIWPKn9W85679Pfd+ANGxqMPNDSLRhCfTP32bkFfEZ
         fwr6wicvGdmvej/6ISZd6wWHy/xhQ+X/t2pWlt80HNab9fUC0McF9ey/bXXxxGp/0X
         t75CxuZO1QQ0g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, njavali@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 11/30] scsi: qla2xxx: Add option to disable FC2 Target support
Date:   Sun, 19 Mar 2023 20:52:36 -0400
Message-Id: <20230320005258.1428043-11-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320005258.1428043-1-sashal@kernel.org>
References: <20230320005258.1428043-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Wagner <dwagner@suse.de>

[ Upstream commit 877b03795fcf29ff2e2351f7e574ecc9b9c51732 ]

Commit 44c57f205876 ("scsi: qla2xxx: Changes to support FCP2 Target") added
support for FC2 Targets. Unfortunately, there are older setups which break
with this new feature enabled.

Allow to disable it via module option.

Link: https://lore.kernel.org/r/20230208152014.109214-1-dwagner@suse.de
Signed-off-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_gbl.h  |  1 +
 drivers/scsi/qla2xxx/qla_init.c |  3 ++-
 drivers/scsi/qla2xxx/qla_os.c   | 10 +++++++++-
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index e3256e721be14..ee54207fc5319 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -192,6 +192,7 @@ extern int ql2xsecenable;
 extern int ql2xenforce_iocb_limit;
 extern int ql2xabts_wait_nvme;
 extern u32 ql2xnvme_queues;
+extern int ql2xfc2target;
 
 extern int qla2x00_loop_reset(scsi_qla_host_t *);
 extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 8f2a968793913..d506eb3a9b639 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1841,7 +1841,8 @@ void qla2x00_handle_rscn(scsi_qla_host_t *vha, struct event_arg *ea)
 	case RSCN_PORT_ADDR:
 		fcport = qla2x00_find_fcport_by_nportid(vha, &ea->id, 1);
 		if (fcport) {
-			if (fcport->flags & FCF_FCP2_DEVICE &&
+			if (ql2xfc2target &&
+			    fcport->flags & FCF_FCP2_DEVICE &&
 			    atomic_read(&fcport->state) == FCS_ONLINE) {
 				ql_dbg(ql_dbg_disc, vha, 0x2115,
 				       "Delaying session delete for FCP2 portid=%06x %8phC ",
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 2d86f804872bf..0dc50b1b3dde5 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -360,6 +360,13 @@ MODULE_PARM_DESC(ql2xnvme_queues,
 	"1 - Minimum number of queues supported\n"
 	"8 - Default value");
 
+int ql2xfc2target = 1;
+module_param(ql2xfc2target, int, 0444);
+MODULE_PARM_DESC(qla2xfc2target,
+		  "Enables FC2 Target support. "
+		  "0 - FC2 Target support is disabled. "
+		  "1 - FC2 Target support is enabled (default).");
+
 static struct scsi_transport_template *qla2xxx_transport_template = NULL;
 struct scsi_transport_template *qla2xxx_transport_vport_template = NULL;
 
@@ -4075,7 +4082,8 @@ qla2x00_mark_all_devices_lost(scsi_qla_host_t *vha)
 	    "Mark all dev lost\n");
 
 	list_for_each_entry(fcport, &vha->vp_fcports, list) {
-		if (fcport->loop_id != FC_NO_LOOP_ID &&
+		if (ql2xfc2target &&
+		    fcport->loop_id != FC_NO_LOOP_ID &&
 		    (fcport->flags & FCF_FCP2_DEVICE) &&
 		    fcport->port_type == FCT_TARGET &&
 		    !qla2x00_reset_active(vha)) {
-- 
2.39.2

