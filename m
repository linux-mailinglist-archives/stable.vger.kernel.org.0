Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1A262E63FC
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392002AbgL1Nod (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:44:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:44922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391994AbgL1Nod (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:44:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10EF2206D4;
        Mon, 28 Dec 2020 13:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163057;
        bh=7ZHXY9GvIdgV9UtZpoUr77Rfjkpt79bSQK93shU30A8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XgctZQ1RZLNodW6DvTCVjfzAWZsThywLQiQ3XScvRS1B6SIdpECZPe8Fff0/0oD/S
         5P2bd5js2r0ERWxsqubS3nz+OFhz5wIWB+N0j5In07BuiMt+ItnOAAGPehasiKPcax
         19WIWB1N+vCQLokSDAjtpKBHi/oiebnHWDBrfssc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 137/453] ASoC: meson: fix COMPILE_TEST error
Date:   Mon, 28 Dec 2020 13:46:13 +0100
Message-Id: <20201228124943.798416608@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 299fe9937dbd1a4d9a1da6a2b6f222298534ca57 ]

When compiled with CONFIG_HAVE_CLK, the kernel need to get provider for the
clock API. This is usually selected by the platform and the sound drivers
should not really care about this. However COMPILE_TEST is special and the
platform required may not have been selected, leading to this type of
error:

> aiu-encoder-spdif.c:(.text+0x3a0): undefined reference to `clk_set_parent'

Since we need a sane provider of the API with COMPILE_TEST, depends on
COMMON_CLK.

Fixes: 6dc4fa179fb8 ("ASoC: meson: add axg fifo base driver")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20201116172423.546855-1-jbrunet@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/meson/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/meson/Kconfig b/sound/soc/meson/Kconfig
index 2e3676147ceaf..e0d24592ebd70 100644
--- a/sound/soc/meson/Kconfig
+++ b/sound/soc/meson/Kconfig
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 menu "ASoC support for Amlogic platforms"
-	depends on ARCH_MESON || COMPILE_TEST
+	depends on ARCH_MESON || (COMPILE_TEST && COMMON_CLK)
 
 config SND_MESON_AXG_FIFO
 	tristate
-- 
2.27.0



