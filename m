Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 372F240A064
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 00:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348434AbhIMWi4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 18:38:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:50818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348907AbhIMWhB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 18:37:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97A4C61269;
        Mon, 13 Sep 2021 22:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572507;
        bh=LT08dKktIJPrMalKOcGLF1ATWsv0kaJSTpFNgTW50Vg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hOtXiPw6iTfbS6Pk22h6yF78bu/Wk1rt9mH28aIFy2Ji5He2THWl/+/gP4+JlphRV
         cqBPwBdVxXosisTXWNZ9V5buGxfa05o/5OiSkpIqODa5rAbww+qzi2Qc3cstXL78jm
         JjlzSi5GMqjZXs7seyfHYD7XTcmEbOWcbWO0jMgXk1xbg5Z4xuGhDfBQA5YDae550M
         ShwcJm7j4HE8Z8mLf1aTlPsyfXNZU1SvaG94+ORUElAHvnFhm6rIShpT4REbBe2Nt/
         j0Gyz2CnJPq37du+oQh+VKoNKixRAaaleKsAZjdHgg6YjQbV6r4AJYXFRijy6TvojE
         i3vtw6MOyRiMQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 02/12] dmaengine: ioat: depends on !UML
Date:   Mon, 13 Sep 2021 18:34:54 -0400
Message-Id: <20210913223504.436087-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913223504.436087-1-sashal@kernel.org>
References: <20210913223504.436087-1-sashal@kernel.org>
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
index a32d0d715247..1322461f1f3c 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -276,7 +276,7 @@ config INTEL_IDMA64
 
 config INTEL_IOATDMA
 	tristate "Intel I/OAT DMA support"
-	depends on PCI && X86_64
+	depends on PCI && X86_64 && !UML
 	select DMA_ENGINE
 	select DMA_ENGINE_RAID
 	select DCA
-- 
2.30.2

