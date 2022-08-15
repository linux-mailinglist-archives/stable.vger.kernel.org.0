Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD7A593887
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245428AbiHOTHT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343549AbiHOTGg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:06:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A654F18F;
        Mon, 15 Aug 2022 11:35:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0DD8B8106C;
        Mon, 15 Aug 2022 18:35:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47C5EC433C1;
        Mon, 15 Aug 2022 18:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588510;
        bh=FA8gCMNgw+Mhv8s7WRCL66F4pG7UoLvoA7yC6pWc+/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wXV1JQf+/RuQ/yWpK/w8F+D3fYivlgYMtfzG1Pq9PfEZuOeHniuiue+nWB3wJs34V
         gToPxMUJK5YyBjYVUm7If+n3Rj/wYOQfys434DVdW+NYKZc1jid8edVhCY1fDQy0oR
         m/7taGHUrzJvdTB+WBSb507uitHSSfBuoX3qB4QQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 396/779] scsi: qla2xxx: edif: Reduce connection thrash
Date:   Mon, 15 Aug 2022 20:00:40 +0200
Message-Id: <20220815180354.201904358@linuxfoundation.org>
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

[ Upstream commit 91f6f5fbe87ba834133fcc61d34881cb8ec9e518 ]

On ipsec start by remote port, target port may use RSCN to trigger
initiator to relogin. If driver is already in the process of a relogin,
then ignore the RSCN and allow the current relogin to continue. This
reduces thrashing of the connection.

Link: https://lore.kernel.org/r/20211026115412.27691-10-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_attr.c |  7 ++++++-
 drivers/scsi/qla2xxx/qla_edif.h |  4 ++++
 drivers/scsi/qla2xxx/qla_init.c | 24 ++++++++++++++++++++++--
 3 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index d3534e7f2d21..bd4ebc1b5c1e 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2754,7 +2754,12 @@ qla2x00_terminate_rport_io(struct fc_rport *rport)
 			if (fcport->loop_id != FC_NO_LOOP_ID)
 				fcport->logout_on_delete = 1;
 
-			qlt_schedule_sess_for_deletion(fcport);
+			if (!EDIF_NEGOTIATION_PENDING(fcport)) {
+				ql_dbg(ql_dbg_disc, fcport->vha, 0x911e,
+				       "%s %d schedule session deletion\n", __func__,
+				       __LINE__);
+				qlt_schedule_sess_for_deletion(fcport);
+			}
 		} else {
 			qla2x00_port_logout(fcport->vha, fcport);
 		}
diff --git a/drivers/scsi/qla2xxx/qla_edif.h b/drivers/scsi/qla2xxx/qla_edif.h
index 32800bfb32a3..2517005fb08c 100644
--- a/drivers/scsi/qla2xxx/qla_edif.h
+++ b/drivers/scsi/qla2xxx/qla_edif.h
@@ -133,4 +133,8 @@ struct enode {
 	 _s->disc_state == DSC_DELETED || \
 	 !_s->edif.app_sess_online))
 
+#define EDIF_NEGOTIATION_PENDING(_fcport) \
+	((_fcport->vha.e_dbell.db_flags & EDB_ACTIVE) && \
+	 (_fcport->disc_state == DSC_LOGIN_AUTH_PEND))
+
 #endif	/* __QLA_EDIF_H */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index be150fc76dba..09ddaa8cb653 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1825,8 +1825,28 @@ void qla2x00_handle_rscn(scsi_qla_host_t *vha, struct event_arg *ea)
 					fcport->d_id.b24, fcport->port_name);
 				return;
 			}
-			fcport->scan_needed = 1;
-			fcport->rscn_gen++;
+
+			if (vha->hw->flags.edif_enabled && vha->e_dbell.db_flags & EDB_ACTIVE) {
+				/*
+				 * On ipsec start by remote port, Target port
+				 * may use RSCN to trigger initiator to
+				 * relogin. If driver is already in the
+				 * process of a relogin, then ignore the RSCN
+				 * and allow the current relogin to continue.
+				 * This reduces thrashing of the connection.
+				 */
+				if (atomic_read(&fcport->state) == FCS_ONLINE) {
+					/*
+					 * If state = online, then set scan_needed=1 to do relogin.
+					 * Otherwise we're already in the middle of a relogin
+					 */
+					fcport->scan_needed = 1;
+					fcport->rscn_gen++;
+				}
+			} else {
+				fcport->scan_needed = 1;
+				fcport->rscn_gen++;
+			}
 		}
 		break;
 	case RSCN_AREA_ADDR:
-- 
2.35.1



