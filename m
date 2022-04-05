Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02FAA4F2A36
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 12:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245640AbiDEI4m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240609AbiDEIcM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11DC775E48;
        Tue,  5 Apr 2022 01:24:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A8E4B81B92;
        Tue,  5 Apr 2022 08:24:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCF2FC385A0;
        Tue,  5 Apr 2022 08:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147074;
        bh=cMqtRYjZEQdWC8J/EteWdfFdurSZ5k0jH4EvAFujZW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HpaJI5ScOCcPDv2fpUznB3va1/MMDMUq9v5CaOuGFKrd2+oe21vw3huCCx3p+O2rp
         QlQauPnwznaEO/XLKuoDCLuAq68BDa4tbvRjlmkuy8lTxb4ent81fXEn43s8gI52i1
         ich5QAMaXM+jdnH64s/ey+oH+a4RE5xV6b5OIaWo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.17 0991/1126] scsi: qla2xxx: Fix stuck session of PRLI reject
Date:   Tue,  5 Apr 2022 09:28:58 +0200
Message-Id: <20220405070436.582506710@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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


