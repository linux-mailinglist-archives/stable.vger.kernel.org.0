Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF4526B56A
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727174AbgIOXnv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:43:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727004AbgIOOd4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:33:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88A0D23C18;
        Tue, 15 Sep 2020 14:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179921;
        bh=pcK80tmAukYeq+PTtoqjTJcUWV1VVi5YRqN7w5CUDy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yrv+n3rYWScfG3fzLNuWoRwt2oEW7NR2uLEtbRaYG1GjCzNm6y6/iLlv9+WVQEuVH
         Bd95rX6I3zj0fZjCYM/b02q97dwTwA6Wrb0J/Q236+jZpQ4Zpks/Vy144Eplh6+9Jc
         zKwwPxPgqdr3H6gN296ly5MX4Nc9LVgQ79Qx7/yg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Roman Stratiienko <r.stratiienko@gmail.com>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 038/177] drm/sun4i: Fix DE2 YVU handling
Date:   Tue, 15 Sep 2020 16:11:49 +0200
Message-Id: <20200915140655.464788926@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jernej Skrabec <jernej.skrabec@siol.net>

[ Upstream commit 0ee9f600e69d901d31469359287b90bbe8e54553 ]

Function sun8i_vi_layer_get_csc_mode() is supposed to return CSC mode
but due to inproper return type (bool instead of u32) it returns just 0
or 1. Colors are wrong for YVU formats because of that.

Fixes: daab3d0e8e2b ("drm/sun4i: de2: csc_mode in de2 format struct is mostly redundant")
Reported-by: Roman Stratiienko <r.stratiienko@gmail.com>
Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
Tested-by: Roman Stratiienko <r.stratiienko@gmail.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20200901220305.6809-1-jernej.skrabec@siol.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun8i_vi_layer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/sun4i/sun8i_vi_layer.c b/drivers/gpu/drm/sun4i/sun8i_vi_layer.c
index 22c8c5375d0db..c0147af6a8406 100644
--- a/drivers/gpu/drm/sun4i/sun8i_vi_layer.c
+++ b/drivers/gpu/drm/sun4i/sun8i_vi_layer.c
@@ -211,7 +211,7 @@ static int sun8i_vi_layer_update_coord(struct sun8i_mixer *mixer, int channel,
 	return 0;
 }
 
-static bool sun8i_vi_layer_get_csc_mode(const struct drm_format_info *format)
+static u32 sun8i_vi_layer_get_csc_mode(const struct drm_format_info *format)
 {
 	if (!format->is_yuv)
 		return SUN8I_CSC_MODE_OFF;
-- 
2.25.1



