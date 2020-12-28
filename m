Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DAAA2E40A8
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441343AbgL1ORC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:17:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:50990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440767AbgL1OPx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:15:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4FF6207A9;
        Mon, 28 Dec 2020 14:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164913;
        bh=m0scGpZXMGqPZfPUgamM7a80b/2g72UhwMb31yJLLkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xMyDf2l8pgDymnU304JH3LFAwn6Tx3OuICzsZEosHkvYbZjeCi0gVmEM921/zu+P7
         QJCp9pnSd7HotXnD+nJSP6Cw2hQLIoGnyBaWNT8yJIYkS4tPPNeLBFtsaJCpFSqM1m
         BwSh5daviQx8rvUcmPmIUwD+qSKKGVdeZi+V+dxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Tzung-Bi Shih <tzungbi@google.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 312/717] ASoC: cros_ec_codec: fix uninitialized memory read
Date:   Mon, 28 Dec 2020 13:45:10 +0100
Message-Id: <20201228125035.976670961@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 7061b8a52296e044eed47b605d136a48da1a7761 ]

gcc points out a memory area that is copied to a device
but not initialized:

sound/soc/codecs/cros_ec_codec.c: In function 'i2s_rx_event':
arch/x86/include/asm/string_32.h:83:20: error: '*((void *)&p+4)' may be used uninitialized in this function [-Werror=maybe-uninitialized]
   83 |   *((int *)to + 1) = *((int *)from + 1);

Initialize all the unused fields to zero.

Fixes: 727f1c71c780 ("ASoC: cros_ec_codec: refactor I2S RX")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Tzung-Bi Shih <tzungbi@google.com>
Link: https://lore.kernel.org/r/20201203225458.1477830-1-arnd@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cros_ec_codec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cros_ec_codec.c b/sound/soc/codecs/cros_ec_codec.c
index 28f039adfa138..5c3b7e5e55d23 100644
--- a/sound/soc/codecs/cros_ec_codec.c
+++ b/sound/soc/codecs/cros_ec_codec.c
@@ -332,7 +332,7 @@ static int i2s_rx_event(struct snd_soc_dapm_widget *w,
 		snd_soc_dapm_to_component(w->dapm);
 	struct cros_ec_codec_priv *priv =
 		snd_soc_component_get_drvdata(component);
-	struct ec_param_ec_codec_i2s_rx p;
+	struct ec_param_ec_codec_i2s_rx p = {};
 
 	switch (event) {
 	case SND_SOC_DAPM_PRE_PMU:
-- 
2.27.0



