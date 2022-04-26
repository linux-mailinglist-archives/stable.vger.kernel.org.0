Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B58B50F4FD
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242241AbiDZIkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345821AbiDZIje (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:39:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EF8AA146A;
        Tue, 26 Apr 2022 01:31:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE77C617D2;
        Tue, 26 Apr 2022 08:31:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F73C385A4;
        Tue, 26 Apr 2022 08:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961906;
        bh=zzLxfROdWq0Cc24SvURJjLlL4V9CEWV5ldpGU7FrGoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bQ5fPhZ5OdtwlhhW5iYXmXmWovwhX2B0mYoNmABC4VaZe7yGYS8CigAJuurI8kGjd
         /Mx17SQaVLDMmJBlun1cV69lH/Md0vSTlvF3B03ZeAEbxOI5kK1kol168r7jQF0Eza
         dZlIHShC1RlELlPZd7y3kHF2oFnd+y3sbVUgZZQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 43/62] drm/vc4: Use pm_runtime_resume_and_get to fix pm_runtime_get_sync() usage
Date:   Tue, 26 Apr 2022 10:21:23 +0200
Message-Id: <20220426081738.457734060@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081737.209637816@linuxfoundation.org>
References: <20220426081737.209637816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 3d0b93d92a2790337aa9d18cb332d02356a24126 ]

If the device is already in a runtime PM enabled state
pm_runtime_get_sync() will return 1.

Also, we need to call pm_runtime_put_noidle() when pm_runtime_get_sync()
fails, so use pm_runtime_resume_and_get() instead. this function
will handle this.

Fixes: 4078f5757144 ("drm/vc4: Add DSI driver")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20220420135008.2757-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_dsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_dsi.c b/drivers/gpu/drm/vc4/vc4_dsi.c
index c78fa8144776..0983949cc8c9 100644
--- a/drivers/gpu/drm/vc4/vc4_dsi.c
+++ b/drivers/gpu/drm/vc4/vc4_dsi.c
@@ -831,7 +831,7 @@ static void vc4_dsi_encoder_enable(struct drm_encoder *encoder)
 	unsigned long phy_clock;
 	int ret;
 
-	ret = pm_runtime_get_sync(dev);
+	ret = pm_runtime_resume_and_get(dev);
 	if (ret) {
 		DRM_ERROR("Failed to runtime PM enable on DSI%d\n", dsi->port);
 		return;
-- 
2.35.1



