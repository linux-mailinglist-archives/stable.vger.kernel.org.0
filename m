Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7047B4F4382
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244004AbiDEMVW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343795AbiDEKjl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:39:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1460EE9C;
        Tue,  5 Apr 2022 03:24:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1838B81C8A;
        Tue,  5 Apr 2022 10:24:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8D8C385A0;
        Tue,  5 Apr 2022 10:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649154278;
        bh=k2K05ZusXB1yui8ELCVKPSk66ktYEN2DSCtlB+QuBFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AK0KQB1vV+YkPtGrGQh1uafIZUaBpu+FRwhd7I99YWQOzbWp2A+xf4cWr3+aCjH/o
         QJrv63Sme/ah6JqP5l3wU2cWUCZ/stu9Ab1EgojdzpWWcUS8vY8oFLbTDxplvVlO5m
         hwOen8bFyNZth01tr36JCaKPVS1pElO5zKXnj2x8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 521/599] scsi: qla2xxx: Fix device reconnect in loop topology
Date:   Tue,  5 Apr 2022 09:33:35 +0200
Message-Id: <20220405070314.343853551@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
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

commit 8ad4be3d15cf144b5834bdb00d5bbe4050938dc7 upstream.

A device logout in loop topology initiates a device connection teardown
which loses the FW device handle. In loop topo, the device handle is not
regrabbed leading to device login failures and eventually to loss of the
device. Fix this by taking the main login path that does it.

Link: https://lore.kernel.org/r/20220110050218.3958-11-njavali@marvell.com
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_init.c |   15 +++++++++++++++
 drivers/scsi/qla2xxx/qla_os.c   |    5 +++++
 2 files changed, 20 insertions(+)

--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -953,6 +953,9 @@ static void qla24xx_handle_gnl_done_even
 				set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 			}
 			break;
+		case ISP_CFG_NL:
+			qla24xx_fcport_handle_login(vha, fcport);
+			break;
 		default:
 			break;
 		}
@@ -1480,6 +1483,11 @@ static void qla_chk_n2n_b4_login(struct
 	u8 login = 0;
 	int rc;
 
+	ql_dbg(ql_dbg_disc, vha, 0x307b,
+	    "%s %8phC DS %d LS %d lid %d retries=%d\n",
+	    __func__, fcport->port_name, fcport->disc_state,
+	    fcport->fw_login_state, fcport->loop_id, fcport->login_retry);
+
 	if (qla_tgt_mode_enabled(vha))
 		return;
 
@@ -5377,6 +5385,13 @@ qla2x00_configure_local_loop(scsi_qla_ho
 			memcpy(fcport->node_name, new_fcport->node_name,
 			    WWN_SIZE);
 			fcport->scan_state = QLA_FCPORT_FOUND;
+			if (fcport->login_retry == 0) {
+				fcport->login_retry = vha->hw->login_retry_count;
+				ql_dbg(ql_dbg_disc, vha, 0x2135,
+				    "Port login retry %8phN, lid 0x%04x retry cnt=%d.\n",
+				    fcport->port_name, fcport->loop_id,
+				    fcport->login_retry);
+			}
 			found++;
 			break;
 		}
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5391,6 +5391,11 @@ void qla2x00_relogin(struct scsi_qla_hos
 					ea.fcport = fcport;
 					qla24xx_handle_relogin_event(vha, &ea);
 				} else if (vha->hw->current_topology ==
+					 ISP_CFG_NL &&
+					IS_QLA2XXX_MIDTYPE(vha->hw)) {
+					(void)qla24xx_fcport_handle_login(vha,
+									fcport);
+				} else if (vha->hw->current_topology ==
 				    ISP_CFG_NL) {
 					fcport->login_retry--;
 					status =


