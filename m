Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBE15412D2
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356875AbiFGTy3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358435AbiFGTw3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:52:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9BC3134E13;
        Tue,  7 Jun 2022 11:20:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1589460DB7;
        Tue,  7 Jun 2022 18:20:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2562AC385A2;
        Tue,  7 Jun 2022 18:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626027;
        bh=+8F/Tet6mZM8QNlTLNyZ2Z7lnuWP8SnBe/1jqtVQNrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yYWHu+bjwns2fhsilxal2je4gHh/HWaxyj4xmPSuIGk+Hz9a/2o5XlRFUrPHSbZLd
         yvymbNckAQenS0upy/ufe+/15J2gWYZYJjugEMCYXPqRXl50/kvs8Rdf2J4XvdlnhU
         1H4vA8W5EFAGcTJ93gKN2tnS9QTTyOuk/lov19ME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Belin <nbelin@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 231/772] drm: bridge: it66121: Fix the register page length
Date:   Tue,  7 Jun 2022 18:57:03 +0200
Message-Id: <20220607164955.839858002@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Belin <nbelin@baylibre.com>

[ Upstream commit 003a1bd6a2a55c16cb2451153533dbedb12bebec ]

Set the register page length or window length to
0x100 according to the documentation.

Fixes: 988156dc2fc9 ("drm: bridge: add it66121 driver")
Signed-off-by: Nicolas Belin <nbelin@baylibre.com>
Acked-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220316135733.173950-3-nbelin@baylibre.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ite-it66121.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/ite-it66121.c b/drivers/gpu/drm/bridge/ite-it66121.c
index 06b59b422c69..64912b770086 100644
--- a/drivers/gpu/drm/bridge/ite-it66121.c
+++ b/drivers/gpu/drm/bridge/ite-it66121.c
@@ -227,7 +227,7 @@ static const struct regmap_range_cfg it66121_regmap_banks[] = {
 		.selector_mask = 0x1,
 		.selector_shift = 0,
 		.window_start = 0x00,
-		.window_len = 0x130,
+		.window_len = 0x100,
 	},
 };
 
-- 
2.35.1



