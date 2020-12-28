Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 132252E3D7B
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440793AbgL1OQA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:16:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:51078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440786AbgL1OP7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:15:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25A1A224D2;
        Mon, 28 Dec 2020 14:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164918;
        bh=k3pJ0UTeYqt0qyQcjLbk5qHhJyg4xsKz/udi+32R2ig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KVIkmra/SSNbgW+NA5LoTOGSuva8KZu+Aq+w6Ej3Il4T97JoC6wV2C/Ckz64IqPpH
         clOwyTUsS9hDHPl8/0qWGfqHkIMPDghXl5HECsLeXiVFifah53IVF01yKOuAAjqw3g
         v7y0NJl5H+QZ1v2K0eUIe2zdUPkfM1wzeuWyQbWU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 314/717] ASoC: qcom: fix QDSP6 dependencies, attempt #3
Date:   Mon, 28 Dec 2020 13:45:12 +0100
Message-Id: <20201228125036.075000019@linuxfoundation.org>
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

[ Upstream commit b1b8eb1283c90a953089d988930d7b6156418958 ]

The previous fix left another warning in randconfig builds:

WARNING: unmet direct dependencies detected for SND_SOC_QDSP6
  Depends on [n]: SOUND [=y] && !UML && SND [=y] && SND_SOC [=y] && SND_SOC_QCOM [=y] && QCOM_APR [=y] && COMMON_CLK [=n]
  Selected by [y]:
  - SND_SOC_MSM8996 [=y] && SOUND [=y] && !UML && SND [=y] && SND_SOC [=y] && SND_SOC_QCOM [=y] && QCOM_APR [=y]

Add one more dependency for this one.

Fixes: 2bc8831b135c ("ASoC: qcom: fix SDM845 & QDSP6 dependencies more")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20201203231443.1483763-1-arnd@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/qcom/Kconfig b/sound/soc/qcom/Kconfig
index 2696ffcba880f..a824f793811be 100644
--- a/sound/soc/qcom/Kconfig
+++ b/sound/soc/qcom/Kconfig
@@ -106,6 +106,7 @@ config SND_SOC_QDSP6
 config SND_SOC_MSM8996
 	tristate "SoC Machine driver for MSM8996 and APQ8096 boards"
 	depends on QCOM_APR
+	depends on COMMON_CLK
 	select SND_SOC_QDSP6
 	select SND_SOC_QCOM_COMMON
 	help
-- 
2.27.0



