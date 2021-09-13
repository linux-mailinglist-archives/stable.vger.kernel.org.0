Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF2B440950B
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345613AbhIMOhO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:37:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:55828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347690AbhIMOfV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:35:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EF73617E3;
        Mon, 13 Sep 2021 13:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541209;
        bh=k7R7caureSstJbIJr1FTSSD6NyAVWVoz5kkbTZepus4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0kmmM24GI1Uj6smXYRP4omNJpG4YXFiAhsl1Q8ydOtnjPm10AXIp9oknn+DluzhKl
         n2gMH30lCHLQjtrkv4O5d+pK6+JdzWR/nloefLKGv6OMMD5T0v7MO6d0mhuUm4b+to
         JZ8wrCWJzi/ia7t6hrSDPpNiNL/9qczFKIxsTMXo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Foss <robert.foss@linaro.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 175/334] drm: bridge: it66121: Check drm_bridge_attach retval
Date:   Mon, 13 Sep 2021 15:13:49 +0200
Message-Id: <20210913131119.263275770@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Foss <robert.foss@linaro.org>

[ Upstream commit bd03d440e2589b9c328f40ce60203adf2b19d2e2 ]

The return value of drm_bridge_attach() is ignored during
the it66121_bridge_attach() call, which is incorrect.

Fixes: 988156dc2fc9 ("drm: bridge: add it66121 driver")
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210805185039.402178-1-robert.foss@linaro.org
Link: https://patchwork.freedesktop.org/patch/msgid/20210805185039.402178-1-robert.foss@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ite-it66121.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/bridge/ite-it66121.c b/drivers/gpu/drm/bridge/ite-it66121.c
index 7149ed40af83..2f2a09adb4bc 100644
--- a/drivers/gpu/drm/bridge/ite-it66121.c
+++ b/drivers/gpu/drm/bridge/ite-it66121.c
@@ -536,6 +536,8 @@ static int it66121_bridge_attach(struct drm_bridge *bridge,
 		return -EINVAL;
 
 	ret = drm_bridge_attach(bridge->encoder, ctx->next_bridge, bridge, flags);
+	if (ret)
+		return ret;
 
 	ret = regmap_write_bits(ctx->regmap, IT66121_CLK_BANK_REG,
 				IT66121_CLK_BANK_PWROFF_RCLK, 0);
-- 
2.30.2



