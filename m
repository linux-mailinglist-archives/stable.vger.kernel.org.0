Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 797B14F457A
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 00:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381121AbiDEMYj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345168AbiDEKkp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:40:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB74C22C;
        Tue,  5 Apr 2022 03:26:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B8D7B81B18;
        Tue,  5 Apr 2022 10:26:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6EF5C385A0;
        Tue,  5 Apr 2022 10:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649154377;
        bh=0Vq7vJRdob4ZU/b7s+kXri72eyuTWPYUpF6OazvvaDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bipKaNWysUcLwH2wH4uGUGgmfag3VcK18FjkTJPwd4cRXBiTjv6jjoLKaGXbHAWRm
         QsGFkrYnQqeVopAP6VpEu9/kc3WRvqLhR0HRzNYWTFpJ2shEgyRhRKnwkbv15mMb4Z
         SpechxjMmya/epTqZfJMuVcG1sYP6Q3iQ+lHsxR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 529/599] scsi: qla2xxx: Fix N2N inconsistent PLOGI
Date:   Tue,  5 Apr 2022 09:33:43 +0200
Message-Id: <20220405070314.582133434@linuxfoundation.org>
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
@@ -2910,6 +2910,7 @@ static void qla2x00_els_dcmd2_sp_done(sr
 					set_bit(ISP_ABORT_NEEDED,
 					    &vha->dpc_flags);
 					qla2xxx_wake_dpc(vha);
+					break;
 				}
 				fallthrough;
 			default:
@@ -2919,9 +2920,7 @@ static void qla2x00_els_dcmd2_sp_done(sr
 				    fw_status[0], fw_status[1], fw_status[2]);
 
 				fcport->flags &= ~FCF_ASYNC_SENT;
-				qla2x00_set_fcport_disc_state(fcport,
-				    DSC_LOGIN_FAILED);
-				set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
+				qlt_schedule_sess_for_deletion(fcport);
 				break;
 			}
 			break;
@@ -2933,8 +2932,7 @@ static void qla2x00_els_dcmd2_sp_done(sr
 			    fw_status[0], fw_status[1], fw_status[2]);
 
 			sp->fcport->flags &= ~FCF_ASYNC_SENT;
-			qla2x00_set_fcport_disc_state(fcport, DSC_LOGIN_FAILED);
-			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
+			qlt_schedule_sess_for_deletion(fcport);
 			break;
 		}
 


