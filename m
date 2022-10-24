Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86DB160AFCF
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 17:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbiJXP6K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 11:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231610AbiJXP5h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 11:57:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C1575491;
        Mon, 24 Oct 2022 07:52:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4748FB816A3;
        Mon, 24 Oct 2022 12:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A516EC433C1;
        Mon, 24 Oct 2022 12:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614613;
        bh=/NdS3g71STJA3Pftdp1Yvvm9X41utaI30ce2S5p5+E4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pCjIGIDUoMFnuZXSwQokhuRzWF76MvBlU2NdzTZ5E2i1BBipVnWBRY2CdI6YU0s9L
         ZwHijxtU6mw45ki86vTJwRi4UU6JXIi/I3TdwtoX7c1SpiCW0mHMDbbSi3yKgQUkHm
         +TQWrWh7yM/RRZqaORVqNG/zMh/Y8xW0XlyRRugE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zeng Jingxiang <linuszeng@tencent.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 328/390] gpu: lontium-lt9611: Fix NULL pointer dereference in lt9611_connector_init()
Date:   Mon, 24 Oct 2022 13:32:05 +0200
Message-Id: <20221024113036.976751511@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zeng Jingxiang <linuszeng@tencent.com>

[ Upstream commit ef8886f321c5dab8124b9153d25afa2a71d05323 ]

A NULL check for bridge->encoder shows that it may be NULL, but it
already been dereferenced on all paths leading to the check.
812	if (!bridge->encoder) {

Dereference the pointer bridge->encoder.
810	drm_connector_attach_encoder(&lt9611->connector, bridge->encoder);

Signed-off-by: Zeng Jingxiang <linuszeng@tencent.com>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220727073119.1578972-1-zengjx95@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/lontium-lt9611.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/lontium-lt9611.c b/drivers/gpu/drm/bridge/lontium-lt9611.c
index 29b1ce2140ab..1dcc28a4d853 100644
--- a/drivers/gpu/drm/bridge/lontium-lt9611.c
+++ b/drivers/gpu/drm/bridge/lontium-lt9611.c
@@ -816,13 +816,14 @@ static int lt9611_connector_init(struct drm_bridge *bridge, struct lt9611 *lt961
 
 	drm_connector_helper_add(&lt9611->connector,
 				 &lt9611_bridge_connector_helper_funcs);
-	drm_connector_attach_encoder(&lt9611->connector, bridge->encoder);
 
 	if (!bridge->encoder) {
 		DRM_ERROR("Parent encoder object not found");
 		return -ENODEV;
 	}
 
+	drm_connector_attach_encoder(&lt9611->connector, bridge->encoder);
+
 	return 0;
 }
 
-- 
2.35.1



