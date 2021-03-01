Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A22D328D76
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241061AbhCATLh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:11:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:36704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240940AbhCATGe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:06:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00AD264FC7;
        Mon,  1 Mar 2021 17:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620516;
        bh=pS34TkYCUhqusG4quIH+86zgW4CnuXHIWqW5z5hklIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lB8GTcNWgY7Hgu/ge3lruv1L/tJEOYph51BCgIa3adaVgnTWbxZD8mGZ3uADGQWqY
         IaEMBUVhMHrd9uAE4sJPSJzEpqCXnejZXAVf8souCdbYf0YrSq56QYmXIzI5HFEXi0
         tMgJtfJLYvWY5PjIgpNHwTNMKb76k/jmDKm4027M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nicolin Chen <nicoleotsuka@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 182/775] ASoC: fsl_aud2htx: select SND_SOC_IMX_PCM_DMA
Date:   Mon,  1 Mar 2021 17:05:50 +0100
Message-Id: <20210301161210.623876193@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit a1f31cc4e98e1833f53fd2c6e9a218d6b86f5388 ]

The newly added driver requires DMA support and fails to build
when that is disabled:

aarch64-linux-ld: sound/soc/fsl/fsl_aud2htx.o: in function `fsl_aud2htx_probe':
fsl_aud2htx.c:(.text+0x3e0): undefined reference to `imx_pcm_dma_init'

Fixes: 8a24c834c053 ("ASoC: fsl_aud2htx: Add aud2htx module driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Nicolin Chen <nicoleotsuka@gmail.com>
Link: https://lore.kernel.org/r/20210103135327.3630973-1-arnd@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/fsl/Kconfig b/sound/soc/fsl/Kconfig
index 84db0b7b9d593..d7f30036d4343 100644
--- a/sound/soc/fsl/Kconfig
+++ b/sound/soc/fsl/Kconfig
@@ -108,6 +108,7 @@ config SND_SOC_FSL_XCVR
 config SND_SOC_FSL_AUD2HTX
 	tristate "AUDIO TO HDMI TX module support"
 	depends on ARCH_MXC || COMPILE_TEST
+	select SND_SOC_IMX_PCM_DMA if SND_IMX_SOC != n
 	help
 	  Say Y if you want to add AUDIO TO HDMI TX support for NXP.
 
-- 
2.27.0



