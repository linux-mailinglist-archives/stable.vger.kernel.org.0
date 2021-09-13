Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 733A5409FC0
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 00:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343982AbhIMWfF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 18:35:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:50204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245382AbhIMWfF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 18:35:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EF60610D2;
        Mon, 13 Sep 2021 22:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572428;
        bh=OPj6CZkkPdKRRabLQSvMYzV363OrmnTfbRaOzNENbDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VW7xTuGT7x/BpOyKUpkXIN+fgnEHCTbVSDyYoCJGLK9adjIfm8QpRG4m56ZjCElh9
         Pnm62uJOvmSsEN2Fl1Amy2piSbwoLNu/mQKquDFLega40ZFwHzGhmtnVf5gg34Znx6
         sADo+/NNVDtjku1Dj8tRIKUy5eDjm9e7aBqwdG46utBelLegz4aLTvDtNXDJnc0L0Z
         Cb068YwKrA7MbA7hLXRhP+Wf7fLPOvJxDuq0Sbex/DwyhBuIzvioTNgKwAfN0u6Xl3
         BfOrz9fWwomOV1G9/pVM9VnDDjXfFRisGULMWEgZcJq7uM1ii4Ex5OK2Tpm4+RZMkc
         dqLnF9jfZbMfA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 06/25] dmaengine: ioat: depends on !UML
Date:   Mon, 13 Sep 2021 18:33:20 -0400
Message-Id: <20210913223339.435347-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913223339.435347-1-sashal@kernel.org>
References: <20210913223339.435347-1-sashal@kernel.org>
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
index f450e4231db7..4f70cf57471a 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -315,7 +315,7 @@ config INTEL_IDXD_PERFMON
 
 config INTEL_IOATDMA
 	tristate "Intel I/OAT DMA support"
-	depends on PCI && X86_64
+	depends on PCI && X86_64 && !UML
 	select DMA_ENGINE
 	select DMA_ENGINE_RAID
 	select DCA
-- 
2.30.2

