Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E03984F03E4
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 16:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243673AbiDBOXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 10:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236168AbiDBOXO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 10:23:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA2512E15E
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 07:21:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B943615A6
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 14:21:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B1EC340EC;
        Sat,  2 Apr 2022 14:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648909282;
        bh=NC9uvBT5Pu/jrb+9ZqvwAEHagC+qjpqVm/kS/wiPmNw=;
        h=Subject:To:Cc:From:Date:From;
        b=Es0kwQTbRGjHlsawGB67xnULn9v4yy2PnPgbYDs3eHyL9J/C/yMGEl27XJc1zyHHC
         lO/1JIo8wTLn4WWutrs+7zwBvwBl/TVt1zKXUtOrv7U4RpNgpep/OiUAztbNRye+vd
         ExY6/PCPA7kWVoS7F489v6NbmSvaiVUX3C1zVgro=
Subject: FAILED: patch "[PATCH] scsi: qla2xxx: Fix stuck session of PRLI reject" failed to apply to 5.4-stable tree
To:     qutran@marvell.com, himanshu.madhani@oracle.com,
        martin.petersen@oracle.com, njavali@marvell.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 02 Apr 2022 16:21:11 +0200
Message-ID: <164890927176207@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f3502e2e98a92981601edc3dadf4b0f43c79836b Mon Sep 17 00:00:00 2001
From: Quinn Tran <qutran@marvell.com>
Date: Thu, 10 Mar 2022 01:26:01 -0800
Subject: [PATCH] scsi: qla2xxx: Fix stuck session of PRLI reject

Remove stale recovery code that prevents normal path recovery.

Link: https://lore.kernel.org/r/20220310092604.22950-11-njavali@marvell.com
Fixes: 1cbc0efcd9be ("scsi: qla2xxx: Fix retry for PRLI RJT with reason of BUSY")
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 7f5b5811c23d..3f3417a3e891 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2105,13 +2105,6 @@ qla24xx_handle_prli_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
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

