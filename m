Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE5F5944AE
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347108AbiHOWDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241861AbiHOV75 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:59:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A8BE29;
        Mon, 15 Aug 2022 12:35:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A304F61089;
        Mon, 15 Aug 2022 19:34:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5A8FC433C1;
        Mon, 15 Aug 2022 19:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592094;
        bh=ULVdn1u+eHqJzYIKptQEe/KzAAMdb1EsJ3McvUFHKhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V3rsYfWnwQGGG5wmUB3yfESpFCtgvqfmFSg1PKWtzpRouIiK0xrutWTIE+6E+K6Xb
         iOUrY93RHQU7jPQVEQOnXmyerHvGUnbP5ZbxKGJPT0JcyPgEFSs+7nmzU2C2io0CdL
         Vh2cI6sFRlENpVhAvQQHO5u638m7tP2HqzW2hhvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0733/1095] scsi: qla2xxx: Check correct variable in qla24xx_async_gffid()
Date:   Mon, 15 Aug 2022 20:02:12 +0200
Message-Id: <20220815180459.721095427@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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



