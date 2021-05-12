Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82C7E37C874
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233376AbhELQIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:08:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:48634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237617AbhELQEC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:04:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D1EE61166;
        Wed, 12 May 2021 15:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833649;
        bh=6FOeVfz505yLKOzyPhNSJniHINWMXjyZENi5tI2AUh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KoWURiPtazkE/iGuEeEd9K2pAEt7F7l0nVJydvEe/aBl/MGEw6grkIHGlIzDSow1a
         +gW7pnyJmKXjfFphvpNVn+pL3miJnaJKf9AZ9oWgpAhMdh6a9TQZfLcB8pkIEqcxXj
         59aD1ddl17JSeBNxLIGHA1gGS/kT3chTlQJz7owI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 217/601] phy: marvell: ARMADA375_USBCLUSTER_PHY should not default to y, unconditionally
Date:   Wed, 12 May 2021 16:44:54 +0200
Message-Id: <20210512144834.989310559@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
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
index 6c96f2bf5266..c8ee23fc3a83 100644
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



