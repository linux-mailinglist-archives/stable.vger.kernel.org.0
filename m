Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8B3510782C
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 20:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727277AbfKVTtR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 14:49:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:48542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727212AbfKVTtQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 14:49:16 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 218CC2071F;
        Fri, 22 Nov 2019 19:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574452155;
        bh=Mpu/ReJMOFNKMRYs/AEeNTxpA1xP5T5VDaCkFifPux0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d7SYN9Es6UgV4b4imWHsVlUHVg0gLAZXtyX3FCAV9pVQRrtkkXLMlIymcERFG3qTa
         SidkQ78wmYDsEc4OdRYJxEOKg250wv/rqT2UgWrMvnqkZWx91lNqhUnvw9p7LyAdqg
         93zFFzqRhBIGE3B8UanobHWAcLTfIqAJbUnr/fbw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yunhao Tian <t123yh@outlook.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 13/25] drm/sun4i: tcon: Set min division of TCON0_DCLK to 1.
Date:   Fri, 22 Nov 2019 14:48:46 -0500
Message-Id: <20191122194859.24508-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122194859.24508-1-sashal@kernel.org>
References: <20191122194859.24508-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunhao Tian <t123yh@outlook.com>

[ Upstream commit 0b8e7bbde5e7e2c419567e1ee29587dae3b78ee3 ]

The datasheet of V3s (and various other chips) wrote
that TCON0_DCLK_DIV can be >= 1 if only dclk is used,
and must >= 6 if dclk1 or dclk2 is used. As currently
neither dclk1 nor dclk2 is used (no writes to these
bits), let's set minimal division to 1.

If this minimal division is 6, some common dot clock
frequencies can't be produced (e.g. 30MHz will not be
possible and will fallback to 25MHz), which is
obviously not an expected behaviour.

Signed-off-by: Yunhao Tian <t123yh@outlook.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/linux-arm-kernel/MN2PR08MB57905AD8A00C08DA219377C989760@MN2PR08MB5790.namprd08.prod.outlook.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun4i_tcon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/sun4i/sun4i_tcon.c b/drivers/gpu/drm/sun4i/sun4i_tcon.c
index 8c31c9ab06f8b..fda1ae12069a7 100644
--- a/drivers/gpu/drm/sun4i/sun4i_tcon.c
+++ b/drivers/gpu/drm/sun4i/sun4i_tcon.c
@@ -423,7 +423,7 @@ static void sun4i_tcon0_mode_set_rgb(struct sun4i_tcon *tcon,
 
 	WARN_ON(!tcon->quirks->has_channel_0);
 
-	tcon->dclk_min_div = 6;
+	tcon->dclk_min_div = 1;
 	tcon->dclk_max_div = 127;
 	sun4i_tcon0_mode_set_common(tcon, mode);
 
-- 
2.20.1

