Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD4D14F2F55
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355540AbiDEKUR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345874AbiDEJXH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:23:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B95A56E6;
        Tue,  5 Apr 2022 02:12:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0BA3B818F3;
        Tue,  5 Apr 2022 09:12:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 149C0C385A9;
        Tue,  5 Apr 2022 09:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149940;
        bh=cMqtRYjZEQdWC8J/EteWdfFdurSZ5k0jH4EvAFujZW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tZ7kT0VnjkvpBKO0aXn2cHTYPQ0JRmQ5sM4s1S06jAnHnvNgVgMGfgs7cNsb2vKN7
         vqorNwGqFowEOgA5QEAuqNEUKDlJeR5mlTcKxBqeyBgb0ocCR8kuiVG35lMh5rwb1u
         5xmoGNUnTCiLFMu7u7gufe4SuHckj553nGPbN7Ro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.16 0896/1017] scsi: qla2xxx: Fix stuck session of PRLI reject
Date:   Tue,  5 Apr 2022 09:30:09 +0200
Message-Id: <20220405070420.823540439@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

commit f3502e2e98a92981601edc3dadf4b0f43c79836b upstream.

Remove stale recovery code that prevents normal path recovery.

Link: https://lore.kernel.org/r/20220310092604.22950-11-njavali@marvell.com
Fixes: 1cbc0efcd9be ("scsi: qla2xxx: Fix retry for PRLI RJT with reason of BUSY")
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_init.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2104,13 +2104,6 @@ qla24xx_handle_prli_done_event(struct sc
 		qla24xx_post_gpdb_work(vha, ea->fcport, 0);
 		break;
 	default:
-		if ((ea->iop[0] == LSC_SCODE_ELS_REJECT) &&
-		    (ea->iop[1] == 0x50000)) {   /* reson 5=busy expl:0x0 */
-			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
-			ea->fcport->fw_login_state = DSC_LS_PLOGI_COMP;
-			break;
-		}
-
 		sp = ea->sp;
 		ql_dbg(ql_dbg_disc, vha, 0x2118,
 		       "%s %d %8phC priority %s, fc4type %x prev try %s\n",


