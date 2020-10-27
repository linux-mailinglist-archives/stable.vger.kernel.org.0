Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1553429B43B
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1784708AbgJ0O7g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:59:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:32998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752793AbgJ0O7g (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:59:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C401F22264;
        Tue, 27 Oct 2020 14:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810775;
        bh=Gs7Qsj0MOdUiZ2k2AOCUTv6rEikJjI4CXfSPbB5i3Us=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QRVQkMMLgku9p/2RD7/lUJmYQ/cIGqRgvB2tkdvgTLxtXHbkSho+aTwocIOYLo6YX
         m0f2yxs5Iqrls1uf35PpscJLy65eFQ9Npnv/+OPh7l0J/JOblqXpW/yXy37FDKTfDw
         w7DIzoZww8BR3uLtUNh6O9DHaUeOBXf5CJQzMsH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Necip Fazil Yildiran <fazilyildiran@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 260/633] ASoC: cros_ec_codec: fix kconfig dependency warning for SND_SOC_CROS_EC_CODEC
Date:   Tue, 27 Oct 2020 14:50:03 +0100
Message-Id: <20201027135534.860416736@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Necip Fazil Yildiran <fazilyildiran@gmail.com>

[ Upstream commit 50b18e4a2608e3897f3787eaa7dfa869b40d9923 ]

When SND_SOC_CROS_EC_CODEC is enabled and CRYPTO is disabled, it results
in the following Kbuild warning:

WARNING: unmet direct dependencies detected for CRYPTO_LIB_SHA256
  Depends on [n]: CRYPTO [=n]
  Selected by [y]:
  - SND_SOC_CROS_EC_CODEC [=y] && SOUND [=y] && !UML && SND [=y] && SND_SOC [=y] && CROS_EC [=y]

The reason is that SND_SOC_CROS_EC_CODEC selects CRYPTO_LIB_SHA256 without
depending on or selecting CRYPTO while CRYPTO_LIB_SHA256 is subordinate to
CRYPTO.

Honor the kconfig menu hierarchy to remove kconfig dependency warnings.

Fixes: 93fa0af4790a ("ASoC: cros_ec_codec: switch to library API for SHA-256")
Signed-off-by: Necip Fazil Yildiran <fazilyildiran@gmail.com>
Link: https://lore.kernel.org/r/20200917141803.92889-1-fazilyildiran@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 986a6308818b2..2a8484f37496c 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -539,6 +539,7 @@ config SND_SOC_CQ0093VC
 config SND_SOC_CROS_EC_CODEC
 	tristate "codec driver for ChromeOS EC"
 	depends on CROS_EC
+	select CRYPTO
 	select CRYPTO_LIB_SHA256
 	help
 	  If you say yes here you will get support for the
-- 
2.25.1



