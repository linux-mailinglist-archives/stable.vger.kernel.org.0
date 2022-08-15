Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B316559489D
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354132AbiHOXnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354309AbiHOXlv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:41:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFFBD2BB3D;
        Mon, 15 Aug 2022 13:12:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D51FB80EA8;
        Mon, 15 Aug 2022 20:12:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE144C433C1;
        Mon, 15 Aug 2022 20:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594325;
        bh=FXcmKym8+v4WXGSA74E5HXWL4LuU9++qS5FPtliBTcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OUQuOgTgNUx/mWwte9jS/zaCdCmzcGalG/0gQ9i8EzwTFVyKNOItf65fEqhTwv423
         AYR2GqCAc3AMPi/fehsrmWdtPZtoQrIqIusCR4D8Gb5MQqRlG6ORJynH2dCxJOPNzu
         /fYVAeTsiOBU+jp4sX5PwabijoG4CqF8yOQFuw5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0414/1157] drm/vc4: dsi: Add correct stop condition to vc4_dsi_encoder_disable iteration
Date:   Mon, 15 Aug 2022 19:56:10 +0200
Message-Id: <20220815180456.212255791@linuxfoundation.org>
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

[ Upstream commit 7bcb9c8d0bc9f3cab8ac2634b056c2e6b63945ca ]

vc4_dsi_encoder_disable is partially an open coded version of
drm_bridge_chain_disable, but it missed a termination condition
in the loop for ->disable which meant that no post_disable
calls were made.

Add in the termination clause.

Fixes: 033bfe7538a1 ("drm/vc4: dsi: Fix bridge chain handling")
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Link: https://lore.kernel.org/r/20220613144800.326124-17-maxime@cerno.tech
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_dsi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/vc4/vc4_dsi.c b/drivers/gpu/drm/vc4/vc4_dsi.c
index 333ea96fcde4..b7b2c76770dc 100644
--- a/drivers/gpu/drm/vc4/vc4_dsi.c
+++ b/drivers/gpu/drm/vc4/vc4_dsi.c
@@ -803,6 +803,9 @@ static void vc4_dsi_encoder_disable(struct drm_encoder *encoder)
 	list_for_each_entry_reverse(iter, &dsi->bridge_chain, chain_node) {
 		if (iter->funcs->disable)
 			iter->funcs->disable(iter);
+
+		if (iter == dsi->bridge)
+			break;
 	}
 
 	vc4_dsi_ulps(dsi, true);
-- 
2.35.1



