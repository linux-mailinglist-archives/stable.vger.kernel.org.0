Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 431F811B75D
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731142AbfLKPM3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:12:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:34176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731135AbfLKPM2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:12:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C56724658;
        Wed, 11 Dec 2019 15:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077147;
        bh=VmuX1lOtvKx4c98j8nGNUePXEwDho/3SgR+Q4NrJQbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OdN+BNCLqmztKSIGQb6d8imiOqubgDXVxpcHELbpkp7s1AIVAGok7OBuKkaMzUEls
         3JuwJUfN26/GfFg+GlKhTrLxqjg3vN5pOOlJdMCUkQNs2RLbg6K2Lz3p+eGdCodMVi
         716ZoxaAx0zvbF30ji5Sedj41nMhBvJhQjotlAX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunhao Tian <t123yh@outlook.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 034/105] drm/sun4i: tcon: Set min division of TCON0_DCLK to 1.
Date:   Wed, 11 Dec 2019 16:05:23 +0100
Message-Id: <20191211150232.911464559@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
References: <20191211150221.153659747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index df0cc8f46d7bd..3491c4c7659e4 100644
--- a/drivers/gpu/drm/sun4i/sun4i_tcon.c
+++ b/drivers/gpu/drm/sun4i/sun4i_tcon.c
@@ -486,7 +486,7 @@ static void sun4i_tcon0_mode_set_rgb(struct sun4i_tcon *tcon,
 
 	WARN_ON(!tcon->quirks->has_channel_0);
 
-	tcon->dclk_min_div = 6;
+	tcon->dclk_min_div = 1;
 	tcon->dclk_max_div = 127;
 	sun4i_tcon0_mode_set_common(tcon, mode);
 
-- 
2.20.1



