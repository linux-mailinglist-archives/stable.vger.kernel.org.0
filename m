Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D247E541974
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378172AbiFGVWK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380859AbiFGVRD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:17:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 840D1101913;
        Tue,  7 Jun 2022 11:57:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2CCAB82399;
        Tue,  7 Jun 2022 18:57:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E65C341C5;
        Tue,  7 Jun 2022 18:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628275;
        bh=F6MgLi6wyMW1BjgCMFvbNnQ3ABKgZyDAaLloeVX9YKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yosgPeekt2IzbAta5eMKAErHNRRjgbxnWIB1/zNj09dTQtW6lVVlL/CKH218pezB2
         D/4uuJtqR7uOcv9tclSy4B/TTHd8AXXG+j57fcbouSXfqJ64fxCZPUKWF8sgQt5yl2
         5IGReUQQK8mvZyWXqHQvDz5p+ykKd32nVHIV/vVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Belin <nbelin@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 269/879] drm: bridge: it66121: Fix the register page length
Date:   Tue,  7 Jun 2022 18:56:27 +0200
Message-Id: <20220607165010.658226635@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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
index 69288cf894b9..e81c106e2c2b 100644
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



