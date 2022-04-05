Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5B84F3086
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239635AbiDEJOh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244916AbiDEIwr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:52:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EBE62495C;
        Tue,  5 Apr 2022 01:46:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC637B81C19;
        Tue,  5 Apr 2022 08:46:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F317C385A1;
        Tue,  5 Apr 2022 08:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148375;
        bh=ej8YD3xB5V9woQICwarpd25mwtsSDI1jBorcXHF2D0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DCL5pr7US6Vohpk0TRa27dnzxku1bLcr1LzFeNYQggFWd0dtPTvrIPAIZFUQ54W//
         G7MqEEb54son5U/3FVlG1hOvJGToeIuh+bRlU71l+63BT2bIenn3M7+R2i5rXekt+G
         2Zi/5EOCTbK/17HnOUGyL+I8qj9cnOXwav/SLGNk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhou Qingyang <zhou1615@umn.edu>,
        Pratyush Yadav <p.yadav@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0333/1017] media: ti-vpe: cal: Fix a NULL pointer dereference in cal_ctx_v4l2_init_formats()
Date:   Tue,  5 Apr 2022 09:20:46 +0200
Message-Id: <20220405070404.166454645@linuxfoundation.org>
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

From: Zhou Qingyang <zhou1615@umn.edu>

[ Upstream commit abd77889851d2ead0d0c9c4d29f1808801477b00 ]

In cal_ctx_v4l2_init_formats(), devm_kzalloc() is assigned to
ctx->active_fmt and there is a dereference of it after that, which could
lead to NULL pointer dereference on failure of devm_kzalloc().

Fix this bug by adding a NULL check of ctx->active_fmt.

This bug was found by a static analyzer.

Builds with 'make allyesconfig' show no new warnings, and our static
analyzer no longer warns about this code.

Fixes: 7168155002cf ("media: ti-vpe: cal: Move format handling to cal.c and expose helpers")
Signed-off-by: Zhou Qingyang <zhou1615@umn.edu>
Reviewed-by: Pratyush Yadav <p.yadav@ti.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/ti-vpe/cal-video.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/ti-vpe/cal-video.c b/drivers/media/platform/ti-vpe/cal-video.c
index 7799da1cc261..3e936a2ca36c 100644
--- a/drivers/media/platform/ti-vpe/cal-video.c
+++ b/drivers/media/platform/ti-vpe/cal-video.c
@@ -823,6 +823,9 @@ static int cal_ctx_v4l2_init_formats(struct cal_ctx *ctx)
 	/* Enumerate sub device formats and enable all matching local formats */
 	ctx->active_fmt = devm_kcalloc(ctx->cal->dev, cal_num_formats,
 				       sizeof(*ctx->active_fmt), GFP_KERNEL);
+	if (!ctx->active_fmt)
+		return -ENOMEM;
+
 	ctx->num_active_fmt = 0;
 
 	for (j = 0, i = 0; ; ++j) {
-- 
2.34.1



