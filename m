Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56C5A599F8A
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351338AbiHSQHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351679AbiHSQGU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:06:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777021EC5C;
        Fri, 19 Aug 2022 08:55:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E99D36174E;
        Fri, 19 Aug 2022 15:55:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7965C433C1;
        Fri, 19 Aug 2022 15:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924515;
        bh=tMmXL/qGN8JSHOlxpl85Dsz797mO7n/oV3gAG5EougU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eIqW+cPdwa2ia9pyn/ILp4Hv96ndisLUucM/amxtnCLjtQhukX914CpoAOnQNc7N3
         Bl4efvqQg7QFVyLezfQTmS41qz1wNpm0QgTF9urW1TZKzDImmzsGfvWTQcmVNVRQ2y
         fe0NSmJTYdlGNvBgJTHLvSTY3/ti43mtYEJlKyWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 196/545] drm/vc4: dsi: Register dsi0 as the correct vc4 encoder type
Date:   Fri, 19 Aug 2022 17:39:26 +0200
Message-Id: <20220819153838.136072639@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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
index 2cedf1cf6758..8e2d5c4237ae 100644
--- a/drivers/gpu/drm/vc4/vc4_dsi.c
+++ b/drivers/gpu/drm/vc4/vc4_dsi.c
@@ -1488,7 +1488,8 @@ static int vc4_dsi_bind(struct device *dev, struct device *master, void *data)
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&dsi->bridge_chain);
-	vc4_dsi_encoder->base.type = VC4_ENCODER_TYPE_DSI1;
+	vc4_dsi_encoder->base.type = dsi->variant->port ?
+			VC4_ENCODER_TYPE_DSI1 : VC4_ENCODER_TYPE_DSI0;
 	vc4_dsi_encoder->dsi = dsi;
 	dsi->encoder = &vc4_dsi_encoder->base.base;
 
-- 
2.35.1



