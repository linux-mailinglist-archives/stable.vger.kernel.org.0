Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4063BAFFF
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbhGDXHW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:07:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:45464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230101AbhGDXHU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:07:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A782611ED;
        Sun,  4 Jul 2021 23:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625439885;
        bh=56Oq7wqAYVvLyK3t7Eltf5zrlTCVibdj8RYSjRLBd5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kffJuk60K0QwQuH+H4dOtfKAl02Kuad3yxJxdyHaKpWBmeiFyijQgW0PT+TSwleMM
         PNocowqUtpdaTGj2q6JouuhZR+w4z+I0oev+E/zShXmYa4G4qCWlkbmIaN2jkteCCu
         MhswX37akox10imrIOn5V9knm0rSCommJiN2qBEuxmw2LKF/oEGgRiZrPmZSP+9bkC
         LJlvmAD6ChvlCl17KO9F3S3mFSigH0ruUV1eATRYrHkpKORk2FtphxBeMS7EsGK42p
         55dtRrO1ahKp8ouJ1BZFtGSvJ9xiguq3XvAoyMpK3FB32BrqKhW5Riytg7RhZuhFDW
         VFp47FSu3KLbA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tian Tao <tiantao6@hisilicon.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 18/85] spi: omap-100k: Fix the length judgment problem
Date:   Sun,  4 Jul 2021 19:03:13 -0400
Message-Id: <20210704230420.1488358-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230420.1488358-1-sashal@kernel.org>
References: <20210704230420.1488358-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tian Tao <tiantao6@hisilicon.com>

[ Upstream commit e7a1a3abea373e41ba7dfe0fbc93cb79b6a3a529 ]

word_len should be checked in the omap1_spi100k_setup_transfer
function to see if it exceeds 32.

Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
Link: https://lore.kernel.org/r/1619695248-39045-1-git-send-email-tiantao6@hisilicon.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-omap-100k.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-omap-100k.c b/drivers/spi/spi-omap-100k.c
index 7062f2902253..f104470605b3 100644
--- a/drivers/spi/spi-omap-100k.c
+++ b/drivers/spi/spi-omap-100k.c
@@ -241,7 +241,7 @@ static int omap1_spi100k_setup_transfer(struct spi_device *spi,
 	else
 		word_len = spi->bits_per_word;
 
-	if (spi->bits_per_word > 32)
+	if (word_len > 32)
 		return -EINVAL;
 	cs->word_len = word_len;
 
-- 
2.30.2

