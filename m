Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D51AB73C20
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405532AbfGXUEw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:04:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:56162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405522AbfGXUEw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 16:04:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 752A1206BA;
        Wed, 24 Jul 2019 20:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998692;
        bh=um3WD5KN4MwftmoddejpnKQw5fPOPyDaTA7BAfh3TiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AG+CSgy2SCKgeq47nzHW5Eq9spZA4Zi3hoOB9mLaYDVj5WzAYp7Wx1mIMW++6ERAU
         I1RLMlR4OI35R4DjJaMV8EAmp6TcsW3JQguLqNaAzglcoEFezdsL1iMJJtP8hCbdSZ
         xfhG0OZZ9aS8ZhcJHXY4ejqidujME2MJAkv35qDI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Miles Chen <miles.chen@mediatek.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 043/271] arm64: mm: make CONFIG_ZONE_DMA32 configurable
Date:   Wed, 24 Jul 2019 21:18:32 +0200
Message-Id: <20190724191658.856919930@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 0c1f14ed12262f45a3af1d588e4d7bd12438b8f5 ]

This change makes CONFIG_ZONE_DMA32 defuly y and allows users
to overwrite it only when CONFIG_EXPERT=y.

For the SoCs that do not need CONFIG_ZONE_DMA32, this is the
first step to manage all available memory by a single
zone(normal zone) to reduce the overhead of multiple zones.

The change also fixes a build error when CONFIG_NUMA=y and
CONFIG_ZONE_DMA32=n.

arch/arm64/mm/init.c:195:17: error: use of undeclared identifier 'ZONE_DMA32'
                max_zone_pfns[ZONE_DMA32] = PFN_DOWN(max_zone_dma_phys());

Change since v1:
1. only expose CONFIG_ZONE_DMA32 when CONFIG_EXPERT=y
2. remove redundant IS_ENABLED(CONFIG_ZONE_DMA32)

Cc: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Miles Chen <miles.chen@mediatek.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/Kconfig   | 3 ++-
 arch/arm64/mm/init.c | 5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 8790a29d0af4..e3ebece79617 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -251,7 +251,8 @@ config GENERIC_CALIBRATE_DELAY
 	def_bool y
 
 config ZONE_DMA32
-	def_bool y
+	bool "Support DMA32 zone" if EXPERT
+	default y
 
 config HAVE_GENERIC_GUP
 	def_bool y
diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 774c3e17c798..29d2f425806e 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -233,8 +233,9 @@ static void __init zone_sizes_init(unsigned long min, unsigned long max)
 {
 	unsigned long max_zone_pfns[MAX_NR_ZONES]  = {0};
 
-	if (IS_ENABLED(CONFIG_ZONE_DMA32))
-		max_zone_pfns[ZONE_DMA32] = PFN_DOWN(max_zone_dma_phys());
+#ifdef CONFIG_ZONE_DMA32
+	max_zone_pfns[ZONE_DMA32] = PFN_DOWN(max_zone_dma_phys());
+#endif
 	max_zone_pfns[ZONE_NORMAL] = max;
 
 	free_area_init_nodes(max_zone_pfns);
-- 
2.20.1



