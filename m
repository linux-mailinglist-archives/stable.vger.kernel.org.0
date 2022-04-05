Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBDCB4F39A5
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354731AbiDELgz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353550AbiDEKIM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:08:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A68EDC1C98;
        Tue,  5 Apr 2022 02:55:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 365A461500;
        Tue,  5 Apr 2022 09:55:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4650DC385A2;
        Tue,  5 Apr 2022 09:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152517;
        bh=Vsh+HEtCiPguM+o61XlDzjkagD1hYteDwNcaJuONtvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rFe/RGRUbsAYnNf9urz6+6SzPzexwCkdyRjLsD+sVjDsTD5LS4ehW2t4j0sdSV8lH
         6MkWSvYXuKj3ITqN0G1BSdV5H5Voxw3GaUDVc1gx+IGbkfCG9dphW3TCdInLBB9Mhw
         d2yiQYysyV/hrDjmWMiJnjHi6JHKEtMRV7mS52qU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 805/913] scsi: qla2xxx: Fix N2N inconsistent PLOGI
Date:   Tue,  5 Apr 2022 09:31:07 +0200
Message-Id: <20220405070403.961799345@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

From: Quinn Tran <qutran@marvell.com>

commit c13ce47c64ea8f14e77eecb40d1e7c2ac667f898 upstream.

For N2N topology, ELS Passthrough is used to send PLOGI. On failure of ELS
pass through PLOGI, driver flipped over to using LLIOCB PLOGI for N2N. This
is not consistent. Delete the session to restart the connection where ELS
pass through PLOGI would be used consistently.

Link: https://lore.kernel.org/r/20220310092604.22950-7-njavali@marvell.com
Fixes: c76ae845ea83 ("scsi: qla2xxx: Add error handling for PLOGI ELS passthrough")
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_iocb.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2943,6 +2943,7 @@ static void qla2x00_els_dcmd2_sp_done(sr
 					set_bit(ISP_ABORT_NEEDED,
 					    &vha->dpc_flags);
 					qla2xxx_wake_dpc(vha);
+					break;
 				}
 				fallthrough;
 			default:
@@ -2952,9 +2953,7 @@ static void qla2x00_els_dcmd2_sp_done(sr
 				    fw_status[0], fw_status[1], fw_status[2]);
 
 				fcport->flags &= ~FCF_ASYNC_SENT;
-				qla2x00_set_fcport_disc_state(fcport,
-				    DSC_LOGIN_FAILED);
-				set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
+				qlt_schedule_sess_for_deletion(fcport);
 				break;
 			}
 			break;
@@ -2966,8 +2965,7 @@ static void qla2x00_els_dcmd2_sp_done(sr
 			    fw_status[0], fw_status[1], fw_status[2]);
 
 			sp->fcport->flags &= ~FCF_ASYNC_SENT;
-			qla2x00_set_fcport_disc_state(fcport, DSC_LOGIN_FAILED);
-			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
+			qlt_schedule_sess_for_deletion(fcport);
 			break;
 		}
 


