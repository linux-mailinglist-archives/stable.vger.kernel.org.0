Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0B6594956
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354094AbiHOXnD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:43:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354300AbiHOXlt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:41:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7BDD2A954;
        Mon, 15 Aug 2022 13:11:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6FEEBB80EAD;
        Mon, 15 Aug 2022 20:11:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A092C433C1;
        Mon, 15 Aug 2022 20:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594309;
        bh=KcEV8SKvsjL468XkPQvCHNAT9nTCGEg25sQJaScv6vE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZKGzdOFGSrVb+3zARUOaLbGjxnSJfQoemiGxeBAdPzBhCO4NkDKkhugm65OlHk1SZ
         pRJCizB/kFqCpR5NF39xKfmbXHH+jCaYR7/lw4RrkgZ7F3ClAAkvW4ZEO4ujZcXP4B
         30AR2C4pDT9vVdANoZUWkKs69FSqQwHxa/AooAXA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0412/1157] drm/vc4: dsi: Register dsi0 as the correct vc4 encoder type
Date:   Mon, 15 Aug 2022 19:56:08 +0200
Message-Id: <20220815180456.117894646@linuxfoundation.org>
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

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit 4d9273c978d4c1af15d7874c10c732ec83d444d0 ]

vc4_dsi was registering both dsi0 and dsi1 as VC4_ENCODER_TYPE_DSI1
which seemed to work OK for a single DSI display, but fails
if there are two DSI displays connected.

Update to register the correct type.

Fixes: 4078f5757144 ("drm/vc4: Add DSI driver")
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Link: https://lore.kernel.org/r/20220613144800.326124-15-maxime@cerno.tech
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_dsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_dsi.c b/drivers/gpu/drm/vc4/vc4_dsi.c
index 81a6c4e9576d..97a258c934af 100644
--- a/drivers/gpu/drm/vc4/vc4_dsi.c
+++ b/drivers/gpu/drm/vc4/vc4_dsi.c
@@ -1518,7 +1518,8 @@ static int vc4_dsi_bind(struct device *dev, struct device *master, void *data)
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&dsi->bridge_chain);
-	vc4_dsi_encoder->base.type = VC4_ENCODER_TYPE_DSI1;
+	vc4_dsi_encoder->base.type = dsi->variant->port ?
+			VC4_ENCODER_TYPE_DSI1 : VC4_ENCODER_TYPE_DSI0;
 	vc4_dsi_encoder->dsi = dsi;
 	dsi->encoder = &vc4_dsi_encoder->base.base;
 
-- 
2.35.1



