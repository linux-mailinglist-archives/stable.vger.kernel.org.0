Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBBC29B74B
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1799414AbgJ0PbX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:31:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799410AbgJ0PbV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:31:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC71F22202;
        Tue, 27 Oct 2020 15:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812680;
        bh=WRBapUpcdS/OdubtPT8T4tKL84vuWWph862zWFmsBvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gDCgixfKaXBIFMou6XDUu2fnjD7j9ONYfENU0D349YuVCJAaQZQ5B/scx5aN4Vjd5
         5tOMsjRQ5W47kJhGpiB7g8KizPdMDlXqBWxQZWqIccHsSQDM5Z7O5vXS8ReXrINp4a
         Jwhw4AXcnLk6OYa3nOuVb/UIkVquoaPa2Bf6W58E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 293/757] ASoC: tas2770: Add missing bias level power states
Date:   Tue, 27 Oct 2020 14:49:03 +0100
Message-Id: <20201027135504.308533793@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Murphy <dmurphy@ti.com>

[ Upstream commit 4272caf34aa4699eca8e6e7f4a8e5ea2bde275c9 ]

Add the BIAS_STANDBY and BIAS_PREPARE to the set_bias_level or else the
driver will return -EINVAL which is not correct as they are valid
states.

Fixes: 1a476abc723e6 ("tas2770: add tas2770 smart PA kernel driver")
Signed-off-by: Dan Murphy <dmurphy@ti.com>
Link: https://lore.kernel.org/r/20200918190548.12598-2-dmurphy@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2770.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/tas2770.c b/sound/soc/codecs/tas2770.c
index 03d7ad1885b81..7c6f61946ab39 100644
--- a/sound/soc/codecs/tas2770.c
+++ b/sound/soc/codecs/tas2770.c
@@ -57,7 +57,12 @@ static int tas2770_set_bias_level(struct snd_soc_component *component,
 			TAS2770_PWR_CTRL_MASK,
 			TAS2770_PWR_CTRL_ACTIVE);
 		break;
-
+	case SND_SOC_BIAS_STANDBY:
+	case SND_SOC_BIAS_PREPARE:
+		snd_soc_component_update_bits(component,
+			TAS2770_PWR_CTRL,
+			TAS2770_PWR_CTRL_MASK, TAS2770_PWR_CTRL_MUTE);
+		break;
 	case SND_SOC_BIAS_OFF:
 		snd_soc_component_update_bits(component,
 			TAS2770_PWR_CTRL,
-- 
2.25.1



