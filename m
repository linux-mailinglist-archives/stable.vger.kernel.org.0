Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8282A62296
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388429AbfGHP1A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:27:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:54940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388973AbfGHP1A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:27:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C1A7216C4;
        Mon,  8 Jul 2019 15:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599619;
        bh=yRJjLKLhEK5TnyOeE6cPOJE+AZlWLNzC06hpNaQ/nq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eT5i9qgcAneIhq6VUbV4icEJNZ0sMX0Zz4guWIpOtT1FhMO6FmF0NPn6m6eJiD+fw
         ovqZN/NM3hcR3RaWHoSyOHa4CPpX7vOZU9WaADAdqKSMDrVQLwMeUu3Yl4DC7jy4xv
         2yGY86A/P7J7AOIgKt2lKlIdcgjedPxbQNu+pzr8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marcus Cooper <codekipper@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 20/90] ASoC: sun4i-i2s: Add offset to RX channel select
Date:   Mon,  8 Jul 2019 17:12:47 +0200
Message-Id: <20190708150523.641923841@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150521.829733162@linuxfoundation.org>
References: <20190708150521.829733162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f9927000cb35f250051f0f1878db12ee2626eea1 ]

Whilst testing the capture functionality of the i2s on the newer
SoCs it was noticed that the recording was somewhat distorted.
This was due to the offset not being set correctly on the receiver
side.

Signed-off-by: Marcus Cooper <codekipper@gmail.com>
Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>
Acked-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sunxi/sun4i-i2s.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/sunxi/sun4i-i2s.c b/sound/soc/sunxi/sun4i-i2s.c
index 5750738b6ac0..6173dd86c62c 100644
--- a/sound/soc/sunxi/sun4i-i2s.c
+++ b/sound/soc/sunxi/sun4i-i2s.c
@@ -460,6 +460,10 @@ static int sun4i_i2s_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)
 		regmap_update_bits(i2s->regmap, SUN8I_I2S_TX_CHAN_SEL_REG,
 				   SUN8I_I2S_TX_CHAN_OFFSET_MASK,
 				   SUN8I_I2S_TX_CHAN_OFFSET(offset));
+
+		regmap_update_bits(i2s->regmap, SUN8I_I2S_RX_CHAN_SEL_REG,
+				   SUN8I_I2S_TX_CHAN_OFFSET_MASK,
+				   SUN8I_I2S_TX_CHAN_OFFSET(offset));
 	}
 
 	regmap_field_write(i2s->field_fmt_mode, val);
-- 
2.20.1



