Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB762F522
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728731AbfE3DLy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:11:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:52728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728726AbfE3DLy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:11:54 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FC6C24481;
        Thu, 30 May 2019 03:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185913;
        bh=3QIZPcRalKcKDFHU14CZdpeeSwM0JVMBt9IhR65Fwlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RL3foP7m9pl/UB9Fdzbj1j4c8Enbe1erSutteW59eX1W/L95J/TRCmLaePBtEOvch
         SaDystChBH8hcYBetOM4ZthHB+pP4k69mlZujsaQJqMtgWPWk9zh4Yo0cD19m6b7Tb
         8d6my6qSwk7KsKV2MRFDWyK1A6KqFIrqg3DjSFuc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 294/405] drm: rcar-du: lvds: Fix post-DLL divider calculation
Date:   Wed, 29 May 2019 20:04:52 -0700
Message-Id: <20190530030555.715789849@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 167e535438ecc73d299340bb1269616432020dfb ]

The PLL parameters are computed by looping over the range of acceptable
M, N and E values, and selecting the combination that produces the
output frequency closest to the target. The internal frequency
constraints are taken into account by restricting the tested values for
the PLL parameters, reducing the search space. The target frequency,
however, is only taken into account when computing the post-PLL divider,
which can result in a 0 value for the divider when the PLL output
frequency being tested is lower than half of the target frequency.
Subsequent loops will produce a better set of PLL parameters, but for
some of the iterations this can result in a division by 0.

Fix it by clamping the divider value. We could instead restrict the E
values being tested in the inner loop, but that would require additional
calculation that would likely be less efficient as the E parameter can
only take three different values.

Fixes: c25c01361199 ("drm: rcar-du: lvds: D3/E3 support")
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rcar-du/rcar_lvds.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_lvds.c b/drivers/gpu/drm/rcar-du/rcar_lvds.c
index f0314790333ba..033f44e46daf4 100644
--- a/drivers/gpu/drm/rcar-du/rcar_lvds.c
+++ b/drivers/gpu/drm/rcar-du/rcar_lvds.c
@@ -283,7 +283,7 @@ static void rcar_lvds_d3_e3_pll_calc(struct rcar_lvds *lvds, struct clk *clk,
 				 * divider.
 				 */
 				fout = fvco / (1 << e) / div7;
-				div = DIV_ROUND_CLOSEST(fout, target);
+				div = max(1UL, DIV_ROUND_CLOSEST(fout, target));
 				diff = abs(fout / div - target);
 
 				if (diff < pll->diff) {
-- 
2.20.1



