Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2B49595065
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbiHPEmD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231795AbiHPEk0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:40:26 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57021A50D0;
        Mon, 15 Aug 2022 13:31:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A8D6CCE1345;
        Mon, 15 Aug 2022 20:31:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96331C433C1;
        Mon, 15 Aug 2022 20:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595498;
        bh=ULVdn1u+eHqJzYIKptQEe/KzAAMdb1EsJ3McvUFHKhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xm8jB3pjjGvX/q25U/ifYlzgQOEyxKGLYwtiYC1iFcz+Pa92CoH5jPMeVjRPtaVG6
         q/Rl2VPd1uQ1K/e08SPwrqe5swlD0JYnddnLBzFDxCtgn/ZniWO8NBEZbIHhqZ8QV4
         yTKQkY9S/KwvCYLhScWjzAzpHtpN38mMzzusKOcE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0783/1157] scsi: qla2xxx: Check correct variable in qla24xx_async_gffid()
Date:   Mon, 15 Aug 2022 20:02:19 +0200
Message-Id: <20220815180510.811465162@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 7c33e477bd883f79cccec418980cb8f7f2d50347 ]

There is a copy and paste bug here.  It should check ".rsp" instead of
".req".  The error message is copy and pasted as well so update that too.

Link: https://lore.kernel.org/r/YrK1A/t3L6HKnswO@kili
Fixes: 9c40c36e75ff ("scsi: qla2xxx: edif: Reduce Initiator-Initiator thrashing")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_gs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 574251b2e0ef..c914b5df9c12 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3386,9 +3386,9 @@ int qla24xx_async_gffid(scsi_qla_host_t *vha, fc_port_t *fcport, bool wait)
 				sp->u.iocb_cmd.u.ctarg.rsp_allocated_size,
 				&sp->u.iocb_cmd.u.ctarg.rsp_dma,
 	    GFP_KERNEL);
-	if (!sp->u.iocb_cmd.u.ctarg.req) {
+	if (!sp->u.iocb_cmd.u.ctarg.rsp) {
 		ql_log(ql_log_warn, vha, 0xd041,
-		       "%s: Failed to allocate ct_sns request.\n",
+		       "%s: Failed to allocate ct_sns response.\n",
 		       __func__);
 		goto done_free_sp;
 	}
-- 
2.35.1



