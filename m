Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C05453CE373
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233618AbhGSPib (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:38:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:59806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348689AbhGSPf1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6966F616ED;
        Mon, 19 Jul 2021 16:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711244;
        bh=GMvgYgkja1Sax4I4/4tVq674OEQOwwyKimhEDiDdJKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nrRNMbXnGGbIE8ej60UFzhLBZXuckeDag0gejwZnMOHcNXi64n75RcqchnSR54yUU
         S3kyvPbmzsXWZNwW/Cy586X79BywmbKObo38hnSYHVPEu062s+BK2qUrEl/78oTe2a
         Du5bDTLGCbI5w/hpE/0EX+MQHbNe4J0xLq/IIAO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 274/351] reset: RESET_INTEL_GW should depend on X86
Date:   Mon, 19 Jul 2021 16:53:40 +0200
Message-Id: <20210719144954.012955322@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 6ab9d6219f86f0db916105444813aafce626a2f4 ]

The Intel Gateway reset controller is only present on Intel Gateway
platforms.  Hence add a dependency on X86, to prevent asking the user
about this driver when configuring a kernel without Intel Gateway
support.

Fixes: c9aef213e38cde27 ("reset: intel: Add system reset controller driver")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/reset/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/reset/Kconfig b/drivers/reset/Kconfig
index 312b7064cdb4..bc8e90c8be52 100644
--- a/drivers/reset/Kconfig
+++ b/drivers/reset/Kconfig
@@ -83,6 +83,7 @@ config RESET_IMX7
 
 config RESET_INTEL_GW
 	bool "Intel Reset Controller Driver"
+	depends on X86 || COMPILE_TEST
 	depends on OF && HAS_IOMEM
 	select REGMAP_MMIO
 	help
-- 
2.30.2



