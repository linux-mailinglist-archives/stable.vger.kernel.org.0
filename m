Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA7CFF020
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731249AbfKPQDQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:03:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:60920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730898AbfKPPwE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:52:04 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60AE120871;
        Sat, 16 Nov 2019 15:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919523;
        bh=6MsO48qqDlueLw2rlZAnHoxYP3IEV8AjklsM9jZxRY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zhoos4PhqkPevRgQEjWcypbxmT0a4M+lNGmU+oNOaxldgD9TUC/UrJ4wPJmFIHi9d
         +/GAjlIC1GXMwe9vfoScWHufFurF4NZ5LSIVMtRGlUcUM25tLk46t26YKomaADQRKw
         FzOrvE9WXrkhJUMdBIogmXb5JpoFus17iu8WYSMI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sapthagiri Baratam <sapthagiri.baratam@cirrus.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>, patches@opensource.cirrus.com
Subject: [PATCH AUTOSEL 4.9 45/99] mfd: arizona: Correct calling of runtime_put_sync
Date:   Sat, 16 Nov 2019 10:50:08 -0500
Message-Id: <20191116155103.10971-45-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116155103.10971-1-sashal@kernel.org>
References: <20191116155103.10971-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sapthagiri Baratam <sapthagiri.baratam@cirrus.com>

[ Upstream commit 6b269a41a4520f7eb639e61a45ebbb9c9267d5e0 ]

Don't call runtime_put_sync when clk32k_ref is ARIZONA_32KZ_MCLK2
as there is no corresponding runtime_get_sync call.

MCLK1 is not in the AoD power domain so if it is used as 32kHz clock
source we need to hold a runtime PM reference to keep the device from
going into low power mode.

Fixes: cdd8da8cc66b ("mfd: arizona: Add gating of external MCLKn clocks")
Signed-off-by: Sapthagiri Baratam <sapthagiri.baratam@cirrus.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/arizona-core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 0556a9749dbe0..1f0c2b594654e 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -52,8 +52,10 @@ int arizona_clk32k_enable(struct arizona *arizona)
 			if (ret != 0)
 				goto err_ref;
 			ret = clk_prepare_enable(arizona->mclk[ARIZONA_MCLK1]);
-			if (ret != 0)
-				goto err_pm;
+			if (ret != 0) {
+				pm_runtime_put_sync(arizona->dev);
+				goto err_ref;
+			}
 			break;
 		case ARIZONA_32KZ_MCLK2:
 			ret = clk_prepare_enable(arizona->mclk[ARIZONA_MCLK2]);
@@ -67,8 +69,6 @@ int arizona_clk32k_enable(struct arizona *arizona)
 					 ARIZONA_CLK_32K_ENA);
 	}
 
-err_pm:
-	pm_runtime_put_sync(arizona->dev);
 err_ref:
 	if (ret != 0)
 		arizona->clk32k_ref--;
-- 
2.20.1

