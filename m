Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3743629B8FB
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802136AbgJ0Ppo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:45:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:55834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1800793AbgJ0Pgz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:36:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23E722225E;
        Tue, 27 Oct 2020 15:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813014;
        bh=pwDR9psH/RHcae6nQ7ZjRocHQCjZ/KoZoJjkNiNckks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L5IQe9pDSzLOJSWCYzRGf/Ksh1pfg712G4+JrjCzLzoEJrwA1ZOg0x13tfOJPQaKI
         RlqVwWI+eF8AnvOp+UWQst3HTeFjuTvZtT8Q0/S+FvRuusdBk0vCJLaJ/Zz3h0ZPcr
         rsz/Jkz3GR5bb8JjnXeNbwOIRhNMj4pwuAJJQs6E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tzung-Bi Shih <tzungbi@google.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 378/757] ASoC: mediatek: mt8183-da7219: fix wrong ops for I2S3
Date:   Tue, 27 Oct 2020 14:50:28 +0100
Message-Id: <20201027135508.282455512@linuxfoundation.org>
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

From: Tzung-Bi Shih <tzungbi@google.com>

[ Upstream commit ebb11d1d9fe2d6b4a47755f7f09b2b631046e308 ]

DA7219 uses I2S2 and I2S3 for input and output respectively.  Commit
9e30251fb22e ("ASoC: mediatek: mt8183-da7219: support machine driver
with rt1015") introduces a bug that:
- If using I2S2 solely, MCLK to DA7219 is 256FS.
- If using I2S3 solely, MCLK to DA7219 is 128FS.
- If using I2S3 first and then I2S2, the MCLK changes from 128FS to
  256FS.  As a result, no sound output to the headset.  Also no sound
  input from the headset microphone.

Both I2S2 and I2S3 should set MCLK to 256FS.  Fixes the wrong ops for
I2S3.

Fixes: 9e30251fb22e ("ASoC: mediatek: mt8183-da7219: support machine driver with rt1015")
Signed-off-by: Tzung-Bi Shih <tzungbi@google.com>
Link: https://lore.kernel.org/r/20201006101252.1890385-1-tzungbi@google.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c b/sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c
index 06d0a4f80fc17..a6c690c5308d3 100644
--- a/sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c
+++ b/sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c
@@ -673,7 +673,7 @@ static int mt8183_da7219_max98357_dev_probe(struct platform_device *pdev)
 			if (card == &mt8183_da7219_max98357_card) {
 				dai_link->be_hw_params_fixup =
 					mt8183_i2s_hw_params_fixup;
-				dai_link->ops = &mt8183_mt6358_i2s_ops;
+				dai_link->ops = &mt8183_da7219_i2s_ops;
 				dai_link->cpus = i2s3_max98357a_cpus;
 				dai_link->num_cpus =
 					ARRAY_SIZE(i2s3_max98357a_cpus);
-- 
2.25.1



