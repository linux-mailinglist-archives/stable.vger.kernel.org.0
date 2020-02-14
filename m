Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9AC15E2F0
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406216AbgBNQZs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:25:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:35736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406210AbgBNQZs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:25:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADCE6247C8;
        Fri, 14 Feb 2020 16:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697547;
        bh=IxJhJMPN/OwtHe3aahbDjabfp0JXfPEO+U/lhktaBeA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U9SBcQ8wjOl6OB1Fz4KS5w0HgN2bft0xb5hh/zbZ2aW4b2bgIuWpuNjqKNTAHnE/L
         hmZK000zs1Hlfu/kOGzApKJlpHxoeOntycPL35p5mvRkvaGixpZRSiZcy1VuIRNcpY
         uLlgaUUcLBuSi2hclaYOqFNb+A1Y/ZFEvjBmQdjc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chen Zhou <chenzhou10@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.4 066/100] ASoC: atmel: fix build error with CONFIG_SND_ATMEL_SOC_DMA=m
Date:   Fri, 14 Feb 2020 11:23:50 -0500
Message-Id: <20200214162425.21071-66-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214162425.21071-1-sashal@kernel.org>
References: <20200214162425.21071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Zhou <chenzhou10@huawei.com>

[ Upstream commit 8fea78029f5e6ed734ae1957bef23cfda1af4354 ]

If CONFIG_SND_ATMEL_SOC_DMA=m, build error:

sound/soc/atmel/atmel_ssc_dai.o: In function `atmel_ssc_set_audio':
(.text+0x7cd): undefined reference to `atmel_pcm_dma_platform_register'

Function atmel_pcm_dma_platform_register is defined under
CONFIG SND_ATMEL_SOC_DMA, so select SND_ATMEL_SOC_DMA in
CONFIG SND_ATMEL_SOC_SSC, same to CONFIG_SND_ATMEL_SOC_PDC.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
Link: https://lore.kernel.org/r/20200113133242.144550-1-chenzhou10@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/atmel/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/atmel/Kconfig b/sound/soc/atmel/Kconfig
index 2d30464b81cef..d7b471c69f4fb 100644
--- a/sound/soc/atmel/Kconfig
+++ b/sound/soc/atmel/Kconfig
@@ -24,6 +24,8 @@ config SND_ATMEL_SOC_DMA
 
 config SND_ATMEL_SOC_SSC_DMA
 	tristate
+	select SND_ATMEL_SOC_DMA
+	select SND_ATMEL_SOC_PDC
 
 config SND_ATMEL_SOC_SSC
 	tristate
-- 
2.20.1

