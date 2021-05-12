Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD43837C432
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234337AbhELP3b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:29:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:60836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234311AbhELPYm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:24:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BA78613DF;
        Wed, 12 May 2021 15:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832217;
        bh=Sn6z3w7XNa+qN0ZtT2QwitOTOGUbwSg6tU5rH34IcSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bHbEZX+FkVH3d/UdEj38K13tsTBCLDOfahgpREvj42QMBQVRU0m7RyukWpG3XebLT
         FbpuBG0xRiV3iB86BBzOSEaXp23sA9mwkT5eK8Egt1sOekuoswu+EStvE0E3U/Q79C
         mvD6VJ8m1lEJaBjS9fCEzg5MgA1tgQB81QWCpy8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 190/530] phy: marvell: ARMADA375_USBCLUSTER_PHY should not default to y, unconditionally
Date:   Wed, 12 May 2021 16:45:00 +0200
Message-Id: <20210512144826.079186467@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 6cb17707aad869de163d7bf42c253caf501be4e2 ]

Merely enabling CONFIG_COMPILE_TEST should not enable additional code.
To fix this, restrict the automatic enabling of ARMADA375_USBCLUSTER_PHY
to MACH_ARMADA_375, and ask the user in case of compile-testing.

Fixes: eee47538ec1f2619 ("phy: add support for USB cluster on the Armada 375 SoC")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20210208150252.424706-1-geert+renesas@glider.be
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/marvell/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/marvell/Kconfig b/drivers/phy/marvell/Kconfig
index 8f6273c837ec..8ab9031c9894 100644
--- a/drivers/phy/marvell/Kconfig
+++ b/drivers/phy/marvell/Kconfig
@@ -3,8 +3,8 @@
 # Phy drivers for Marvell platforms
 #
 config ARMADA375_USBCLUSTER_PHY
-	def_bool y
-	depends on MACH_ARMADA_375 || COMPILE_TEST
+	bool "Armada 375 USB cluster PHY support" if COMPILE_TEST
+	default y if MACH_ARMADA_375
 	depends on OF && HAS_IOMEM
 	select GENERIC_PHY
 
-- 
2.30.2



