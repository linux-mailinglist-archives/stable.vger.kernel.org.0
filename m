Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75629E9FD8
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 16:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbfJ3Pvh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:51:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:52456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727815AbfJ3Pvg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:51:36 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BC2C20874;
        Wed, 30 Oct 2019 15:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450695;
        bh=IpiSE2O0Qb0OJ2zh6eh0U9SBp/2HJbtPHFeAUgw+Whc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NOX49Tm9l4sl3c5SsKaNwIEpFT8QHVCAg23o80OIlKZ4YGnLeJWn5/Lzf7vFFD6hJ
         foTEafqTBxYvkGEJLezSeR9i3YDwSYtrBFY4hCosl88h71QntViwMSKQhuhK8o6/s3
         3T/WsUHcVjNhLqrLV2uElV47iY2McYUotWzqY+r8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Amelie Delaunay <amelie.delaunay@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 28/81] pinctrl: stmfx: fix null pointer on remove
Date:   Wed, 30 Oct 2019 11:48:34 -0400
Message-Id: <20191030154928.9432-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030154928.9432-1-sashal@kernel.org>
References: <20191030154928.9432-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amelie Delaunay <amelie.delaunay@st.com>

[ Upstream commit 2fd215b8fdbe4d3a609adbe3a323696393cb1e53 ]

dev_get_platdata(&pdev->dev) returns a pointer on struct stmfx_pinctrl,
not on struct stmfx (platform_set_drvdata(pdev, pctl); in probe).
Pointer on struct stmfx is stored in driver data of pdev parent (in probe:
struct stmfx *stmfx = dev_get_drvdata(pdev->dev.parent);).

Fixes: 1490d9f841b1 ("pinctrl: Add STMFX GPIO expander Pinctrl/GPIO driver")
Signed-off-by: Amelie Delaunay <amelie.delaunay@st.com>
Link: https://lore.kernel.org/r/20191004122342.22018-1-amelie.delaunay@st.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-stmfx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-stmfx.c b/drivers/pinctrl/pinctrl-stmfx.c
index 31b6e511670fc..b7c7f24699c96 100644
--- a/drivers/pinctrl/pinctrl-stmfx.c
+++ b/drivers/pinctrl/pinctrl-stmfx.c
@@ -697,7 +697,7 @@ static int stmfx_pinctrl_probe(struct platform_device *pdev)
 
 static int stmfx_pinctrl_remove(struct platform_device *pdev)
 {
-	struct stmfx *stmfx = dev_get_platdata(&pdev->dev);
+	struct stmfx *stmfx = dev_get_drvdata(pdev->dev.parent);
 
 	return stmfx_function_disable(stmfx,
 				      STMFX_FUNC_GPIO |
-- 
2.20.1

