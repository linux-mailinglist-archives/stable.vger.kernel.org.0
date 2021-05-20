Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2759238A3A3
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234157AbhETJz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:55:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:52356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234055AbhETJwl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:52:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77A286157E;
        Thu, 20 May 2021 09:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503371;
        bh=Mc5/Am/gSQnTwDB+AGtQYp0SdF8yNbgwY9M2PbwZwM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KGVnEGudb0Bc/UsZNUTlKvbrFCRr5+exIk6j4I1NAgKkSNJ1NYUukZqyYv5kxnuy1
         gN2fZrmNyvYyhpATb7/Uj/0rNVELhXbnt/O9En6U0uBgM49Yfa/fJkbKJ6JxbZUSqa
         NeIaP49g7/Oo5EExEnaGM49+wjQhT/v2yCQ438rQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 192/425] phy: marvell: ARMADA375_USBCLUSTER_PHY should not default to y, unconditionally
Date:   Thu, 20 May 2021 11:19:21 +0200
Message-Id: <20210520092137.733434018@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
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
index 68e321225400..ed4d3904e53f 100644
--- a/drivers/phy/marvell/Kconfig
+++ b/drivers/phy/marvell/Kconfig
@@ -2,8 +2,8 @@
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



