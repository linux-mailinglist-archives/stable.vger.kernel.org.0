Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72013411D21
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346825AbhITRQf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:16:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:41326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347676AbhITROb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:14:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E634F613A8;
        Mon, 20 Sep 2021 16:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157094;
        bh=O1nAtc5H8tqphi8+ShnCcVHnUuzNQRMglPA63P1HohY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eeeiO/iiEj4hcNLtMHwggog5BQzszRln9d8gzFIV8GR/uN9XDfLlhyVoZ+8xKXA0k
         kTDaT7Ri/e509hrG9nazb1foZmLjEV3A6498tBxYMqE3ldN5pfj1z+Bs4ocZ0bCSJb
         Jp0RRIl4Xk8t4kZn2hphtwYaxwicf8Q9OVp7trGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 051/217] soc: rockchip: ROCKCHIP_GRF should not default to y, unconditionally
Date:   Mon, 20 Sep 2021 18:41:12 +0200
Message-Id: <20210920163926.355107116@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 2a1c55d4762dd34a8b0f2e36fb01b7b16b60735b ]

Merely enabling CONFIG_COMPILE_TEST should not enable additional code.
To fix this, restrict the automatic enabling of ROCKCHIP_GRF to
ARCH_ROCKCHIP, and ask the user in case of compile-testing.

Fixes: 4c58063d4258f6be ("soc: rockchip: add driver handling grf setup")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20210208143855.418374-1-geert+renesas@glider.be
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/rockchip/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/rockchip/Kconfig b/drivers/soc/rockchip/Kconfig
index 20da55d9cbb1..d483b0e29b81 100644
--- a/drivers/soc/rockchip/Kconfig
+++ b/drivers/soc/rockchip/Kconfig
@@ -5,8 +5,8 @@ if ARCH_ROCKCHIP || COMPILE_TEST
 #
 
 config ROCKCHIP_GRF
-	bool
-	default y
+	bool "Rockchip General Register Files support" if COMPILE_TEST
+	default y if ARCH_ROCKCHIP
 	help
 	  The General Register Files are a central component providing
 	  special additional settings registers for a lot of soc-components.
-- 
2.30.2



