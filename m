Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60D0240A07F
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 00:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344573AbhIMWjc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 18:39:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:51262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349062AbhIMWh2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 18:37:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F75F6134F;
        Mon, 13 Sep 2021 22:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572525;
        bh=P6dKveuOPB+7Dz8pfEpbCBI6+ptDmfuolSyzDe2EUWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tV5wx79fuEmo2MKmjqQRqmlYp42+7MvdMDtQpYOnPN2xjSIZ4w0xF/yEgGVrKKlQB
         ZuBahPpy4li2GuLJbL1VRajr1+OgSUvw012hJdBaZQmBu3NgYMv7iB8QaNTpzBq9Za
         UYO648DHcdunJ08rOIAnpaDiU4yANtnrZrkqEsFQPRbYjrdEVEAXrYlx8xsic1Z+a3
         XwBlgCdWrQu9JiC6s/AY7fxA8OYGLnReKAP2aS6wpmCKzdY4HyQ4Rb/FmtOVHZPG9q
         S5TDkSk8NkpW1gIC8vm4YVr5IAXxfsbnJOmtirGfJrw7XfBcIy2DV9JJ8hnWPeV1tz
         HE2abDLZx51rA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 02/10] dmaengine: ioat: depends on !UML
Date:   Mon, 13 Sep 2021 18:35:13 -0400
Message-Id: <20210913223521.436250-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913223521.436250-1-sashal@kernel.org>
References: <20210913223521.436250-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit bbac7a92a46f0876e588722ebe552ddfe6fd790f ]

Now that UML has PCI support, this driver must depend also on
!UML since it pokes at X86_64 architecture internals that don't
exist on ARCH=um.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Acked-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20210809112409.a3a0974874d2.I2ffe3d11ed37f735da2f39884a74c953b258b995@changeid
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 52dd4bd7c209..e5f31af65aab 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -266,7 +266,7 @@ config INTEL_IDMA64
 
 config INTEL_IOATDMA
 	tristate "Intel I/OAT DMA support"
-	depends on PCI && X86_64
+	depends on PCI && X86_64 && !UML
 	select DMA_ENGINE
 	select DMA_ENGINE_RAID
 	select DCA
-- 
2.30.2

