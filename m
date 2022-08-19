Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0F8C59A3C5
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350445AbiHSQmE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353857AbiHSQlJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:41:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4D2B12578F;
        Fri, 19 Aug 2022 09:09:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC6CD61639;
        Fri, 19 Aug 2022 16:08:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D570C43141;
        Fri, 19 Aug 2022 16:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925332;
        bh=qBJun0bWQYxXyX9cv6OKocqYB+O1BIvrD1jsikgfFIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Far5wnp31bNbkUbATA0TOtUdbhp6VurU6CnHw227cul447uu3RRtgPG2ouiw8AB/l
         T5GO9iVI+70UTiaOOyS8Rv0aluLFTeKtQL/mw10vnwShcLug2G42wLdPHlVUslcC6g
         wctB0TQD2QRV2Id99rc9ZtZd1IlReVILHXApUakw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Battersby <tonyb@cybernetics.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 440/545] scsi: qla2xxx: Fix discovery issues in FC-AL topology
Date:   Fri, 19 Aug 2022 17:43:30 +0200
Message-Id: <20220819153849.113964391@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

From: Arun Easi <aeasi@marvell.com>

commit 47ccb113cead905bdc236571bf8ac6fed90321b3 upstream.

A direct attach tape device, when gets swapped with another, was not
discovered. Fix this by looking at loop map and reinitialize link if there
are devices present.

Link: https://lore.kernel.org/linux-scsi/baef87c3-5dad-3b47-44c1-6914bfc90108@cybernetics.com/
Link: https://lore.kernel.org/r/20220713052045.10683-8-njavali@marvell.com
Cc: stable@vger.kernel.org
Reported-by: Tony Battersby <tonyb@cybernetics.com>
Tested-by: Tony Battersby <tonyb@cybernetics.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_gbl.h  |    3 ++-
 drivers/scsi/qla2xxx/qla_init.c |   29 +++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_mbx.c  |    5 ++++-
 3 files changed, 35 insertions(+), 2 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -405,7 +405,8 @@ extern int
 qla2x00_get_resource_cnts(scsi_qla_host_t *);
 
 extern int
-qla2x00_get_fcal_position_map(scsi_qla_host_t *ha, char *pos_map);
+qla2x00_get_fcal_position_map(scsi_qla_host_t *ha, char *pos_map,
+		u8 *num_entries);
 
 extern int
 qla2x00_get_link_status(scsi_qla_host_t *, uint16_t, struct link_statistics *,
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5270,6 +5270,22 @@ static int qla2x00_configure_n2n_loop(sc
 	return QLA_FUNCTION_FAILED;
 }
 
+static void
+qla_reinitialize_link(scsi_qla_host_t *vha)
+{
+	int rval;
+
+	atomic_set(&vha->loop_state, LOOP_DOWN);
+	atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
+	rval = qla2x00_full_login_lip(vha);
+	if (rval == QLA_SUCCESS) {
+		ql_dbg(ql_dbg_disc, vha, 0xd050, "Link reinitialized\n");
+	} else {
+		ql_dbg(ql_dbg_disc, vha, 0xd051,
+			"Link reinitialization failed (%d)\n", rval);
+	}
+}
+
 /*
  * qla2x00_configure_local_loop
  *	Updates Fibre Channel Device Database with local loop devices.
@@ -5321,6 +5337,19 @@ qla2x00_configure_local_loop(scsi_qla_ho
 		spin_unlock_irqrestore(&vha->work_lock, flags);
 
 		if (vha->scan.scan_retry < MAX_SCAN_RETRIES) {
+			u8 loop_map_entries = 0;
+			int rc;
+
+			rc = qla2x00_get_fcal_position_map(vha, NULL,
+						&loop_map_entries);
+			if (rc == QLA_SUCCESS && loop_map_entries > 1) {
+				/*
+				 * There are devices that are still not logged
+				 * in. Reinitialize to give them a chance.
+				 */
+				qla_reinitialize_link(vha);
+				return QLA_FUNCTION_FAILED;
+			}
 			set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
 			set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
 		}
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3017,7 +3017,8 @@ qla2x00_get_resource_cnts(scsi_qla_host_
  *	Kernel context.
  */
 int
-qla2x00_get_fcal_position_map(scsi_qla_host_t *vha, char *pos_map)
+qla2x00_get_fcal_position_map(scsi_qla_host_t *vha, char *pos_map,
+		u8 *num_entries)
 {
 	int rval;
 	mbx_cmd_t mc;
@@ -3057,6 +3058,8 @@ qla2x00_get_fcal_position_map(scsi_qla_h
 
 		if (pos_map)
 			memcpy(pos_map, pmap, FCAL_MAP_SIZE);
+		if (num_entries)
+			*num_entries = pmap[0];
 	}
 	dma_pool_free(ha->s_dma_pool, pmap, pmap_dma);
 


