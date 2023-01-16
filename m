Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21EC866C8FB
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233803AbjAPQpe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:45:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233767AbjAPQo5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:44:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D17BF2FCC6
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:32:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F86561059
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:32:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 838B6C433D2;
        Mon, 16 Jan 2023 16:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886735;
        bh=qgRQMPUO1Uc+cH74o/UKEo8XOXmapK+SQ9IzDbHibi4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TpMACKXd3QtxFkbrx6kLms235E9QpkKtr5ExwWf5mOeEhEbsvchs/qy2X1/56iMUk
         n3tzcArguO2yAdTj0Vgua2p4Cn5WYMwuVvvkC4btF33o3vGNSLUI2KDzg+YN+kZkVX
         YpotWnBKmTMmVpnrxHL55mW06w6+8kF7ajV1F94U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-fsd@tesla.com,
        Smitha T Murthy <smitha.t@samsung.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 541/658] media: s5p-mfc: Clear workbit to handle error condition
Date:   Mon, 16 Jan 2023 16:50:29 +0100
Message-Id: <20230116154934.286752047@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Smitha T Murthy <smitha.t@samsung.com>

[ Upstream commit d3f3c2fe54e30b0636496d842ffbb5ad3a547f9b ]

During error on CLOSE_INSTANCE command, ctx_work_bits was not getting
cleared. During consequent mfc execution NULL pointer dereferencing of
this context led to kernel panic. This patch fixes this issue by making
sure to clear ctx_work_bits always.

Fixes: 818cd91ab8c6 ("[media] s5p-mfc: Extract open/close MFC instance commands")
Cc: stable@vger.kernel.org
Cc: linux-fsd@tesla.com
Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
index da138c314963..58822ec5370e 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
@@ -468,8 +468,10 @@ void s5p_mfc_close_mfc_inst(struct s5p_mfc_dev *dev, struct s5p_mfc_ctx *ctx)
 	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 	/* Wait until instance is returned or timeout occurred */
 	if (s5p_mfc_wait_for_done_ctx(ctx,
-				S5P_MFC_R2H_CMD_CLOSE_INSTANCE_RET, 0))
+				S5P_MFC_R2H_CMD_CLOSE_INSTANCE_RET, 0)){
+		clear_work_bit_irqsave(ctx);
 		mfc_err("Err returning instance\n");
+	}
 
 	/* Free resources */
 	s5p_mfc_hw_call(dev->mfc_ops, release_codec_buffers, ctx);
-- 
2.35.1



