Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01BA64F3BCB
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245034AbiDEMCO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357995AbiDEK1j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:27:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA56D5554;
        Tue,  5 Apr 2022 03:12:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C80061777;
        Tue,  5 Apr 2022 10:12:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DFD6C385A1;
        Tue,  5 Apr 2022 10:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153548;
        bh=F2QB7kb0dawbt9xWarnKA2zPFQV/q0hPhE2v5d7TAd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q4b1H1dPaw6Y6MmJSmRZXUTn5Y/P460uPE8LSePfHb5nAARZVQ3mYQvi09CUE/bbM
         8THe8K829zoUrW5HhelnhaNAKxrbrw/7mxQhMcGlj5P3GX6A0MTRQJbtej+RBW25bR
         tLYiSYptvbFr5VwnzjMjdOJwYCarMSIh+AMPwtOg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 261/599] drm/bridge: Fix free wrong object in sii8620_init_rcp_input_dev
Date:   Tue,  5 Apr 2022 09:29:15 +0200
Message-Id: <20220405070306.605611656@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 7c442e76c06cb1bef16a6c523487438175584eea ]

rc_dev is allocated by rc_allocate_device(), and doesn't assigned to
ctx->rc_dev before calling  rc_free_device(ctx->rc_dev).
So it should call rc_free_device(rc_dev);

Fixes: e25f1f7c94e1 ("drm/bridge/sii8620: add remote control support")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20211227092522.21755-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/sil-sii8620.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/sil-sii8620.c b/drivers/gpu/drm/bridge/sil-sii8620.c
index 843265d7f1b1..ec7745c31da0 100644
--- a/drivers/gpu/drm/bridge/sil-sii8620.c
+++ b/drivers/gpu/drm/bridge/sil-sii8620.c
@@ -2120,7 +2120,7 @@ static void sii8620_init_rcp_input_dev(struct sii8620 *ctx)
 	if (ret) {
 		dev_err(ctx->dev, "Failed to register RC device\n");
 		ctx->error = ret;
-		rc_free_device(ctx->rc_dev);
+		rc_free_device(rc_dev);
 		return;
 	}
 	ctx->rc_dev = rc_dev;
-- 
2.34.1



