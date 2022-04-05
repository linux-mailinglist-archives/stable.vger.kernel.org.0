Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08AD14F2DE2
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353870AbiDEKJl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345872AbiDEJXH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:23:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34744A5E8D;
        Tue,  5 Apr 2022 02:12:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C647561527;
        Tue,  5 Apr 2022 09:12:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF47C385A2;
        Tue,  5 Apr 2022 09:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149943;
        bh=m7G20AubjvcX73uuvdxB1UoNXmtJuvwEgYN+98yPEXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JbmDxpelTCX1Ok1gIedzMdHZM6VIHrP1gnNEGXyysLQmouGs1RS4wqgxewtKRedio
         3oWm9jxuou6r+jCdEKKjLwl6VkPpgSM8ZRPInLunhBel28XMLXCBu/U5HdAyqbhUBt
         KXRTmPYyU9uDe5K5L48Tuk6p0TGK0Pc1suxRaKpk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.16 0897/1017] scsi: qla2xxx: Reduce false trigger to login
Date:   Tue,  5 Apr 2022 09:30:10 +0200
Message-Id: <20220405070420.852885310@linuxfoundation.org>
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

commit d2646eed7b19a206912f49101178cbbaa507256c upstream.

While a session is in the middle of a relogin, a late RSCN can be delivered
from switch. RSCN trigger fabric scan where the scan logic can trigger
another session login while a login is in progress.  Reduce the extra
trigger to prevent multiple logins to the same session.

Link: https://lore.kernel.org/r/20220310092604.22950-10-njavali@marvell.com
Fixes: bee8b84686c4 ("scsi: qla2xxx: Reduce redundant ADISC command for RSCNs")
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_init.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1644,7 +1644,8 @@ int qla24xx_fcport_handle_login(struct s
 	    fcport->login_gen, fcport->loop_id, fcport->scan_state,
 	    fcport->fc4_type);
 
-	if (fcport->scan_state != QLA_FCPORT_FOUND)
+	if (fcport->scan_state != QLA_FCPORT_FOUND ||
+	    fcport->disc_state == DSC_DELETE_PEND)
 		return 0;
 
 	if ((fcport->loop_id != FC_NO_LOOP_ID) &&
@@ -1665,7 +1666,7 @@ int qla24xx_fcport_handle_login(struct s
 	if (vha->host->active_mode == MODE_TARGET && !N2N_TOPO(vha->hw))
 		return 0;
 
-	if (fcport->flags & FCF_ASYNC_SENT) {
+	if (fcport->flags & (FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE)) {
 		set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 		return 0;
 	}


