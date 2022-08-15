Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3F0859364B
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343665AbiHOTMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343597AbiHOTJH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:09:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B83440BDD;
        Mon, 15 Aug 2022 11:35:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A17460FB8;
        Mon, 15 Aug 2022 18:35:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8692FC433C1;
        Mon, 15 Aug 2022 18:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588556;
        bh=hTRS1tqejUoIqcG1ti54Lman6PjQTp4st0trKhr/PfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ji2ocTmXyjsK6i4uYsRXOtTdo/zUkMY8PZCzXDrMkztOfXbZM9i2z1cwL+amL+jtQ
         qNXcLKTT6AU9hOyv8+Fpdhav83MDoCNCdimiXCOS5EpGFcCLUmjvD0mtQGG+8Je08w
         ef+rc7Jg4tf4N0p5oB+S0D1FxN7JuQJwlDcUxpQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 424/779] scsi: qla2xxx: edif: Fix no logout on delete for N2N
Date:   Mon, 15 Aug 2022 20:01:08 +0200
Message-Id: <20220815180355.383340875@linuxfoundation.org>
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

[ Upstream commit ec538eb838f334453b10e7e9b260f0c358018a37 ]

The driver failed to send implicit logout on session delete. For edif, this
failed to flush any lingering SA index in FW.

Set a flag to turn on implicit logout early in the session recovery to make
sure the logout will go out in case of error.

Link: https://lore.kernel.org/r/20220608115849.16693-8-njavali@marvell.com
Fixes: 4de067e5df12 ("scsi: qla2xxx: edif: Add N2N support for EDIF")
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 46c879923da1..42ce4e1fe744 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2882,6 +2882,9 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, int res)
 	    sp->name, res, sp->handle, fcport->d_id.b24, fcport->port_name);
 
 	fcport->flags &= ~(FCF_ASYNC_SENT|FCF_ASYNC_ACTIVE);
+	/* For edif, set logout on delete to ensure any residual key from FW is flushed.*/
+	fcport->logout_on_delete = 1;
+	fcport->chip_reset = vha->hw->base_qpair->chip_reset;
 
 	if (sp->flags & SRB_WAKEUP_ON_COMP)
 		complete(&lio->u.els_plogi.comp);
-- 
2.35.1



