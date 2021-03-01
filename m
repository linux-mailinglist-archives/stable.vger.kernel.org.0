Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2B0328A20
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239433AbhCASMr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:12:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:58158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238781AbhCASF1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:05:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82D9D65213;
        Mon,  1 Mar 2021 17:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619339;
        bh=RXGTWsj5SjxPXDudRiJZOdC3QdLQu0F2di0eQJb1bqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ihdOovYmP9ZD6EQvvn708NIz1ZWFUBHXHtOoz6v+fbgd1xBTUA7uvFp+uTKO5Y7la
         +OIJTxrJTZIVJINLfoE78owkEWSGEnFJwk+NO6V6Rzbvqtx082edjkuheUiS7q1XkA
         ryvPevzXZZuaUy6w1nBrKQUxYY8ruHry6ZiI8NU0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 418/663] phy: USB_LGM_PHY should depend on X86
Date:   Mon,  1 Mar 2021 17:11:06 +0100
Message-Id: <20210301161202.556175275@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 6b46e60a6943d629d69924be3169d8f214624ab2 ]

The Intel Lightning Mountain (LGM) USB3 USB is only present on Intel
Lightning Mountain SoCs.  Hence add a dependency on X86, to prevent
asking the user about this driver when configuring a kernel without
Intel Lightning Mountain platform support.

Fixes: 1cce8f73a561c944 ("phy: Add USB3 PHY support for Intel LGM SoC")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20210129131753.2656306-1-geert+renesas@glider.be
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 01b53f86004cb..9ed5f167a9f3c 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -52,6 +52,7 @@ config PHY_XGENE
 config USB_LGM_PHY
 	tristate "INTEL Lightning Mountain USB PHY Driver"
 	depends on USB_SUPPORT
+	depends on X86 || COMPILE_TEST
 	select USB_PHY
 	select REGULATOR
 	select REGULATOR_FIXED_VOLTAGE
-- 
2.27.0



