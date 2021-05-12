Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A08B737C399
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233851AbhELPVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:21:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:50640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233482AbhELPSX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:18:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35B2761492;
        Wed, 12 May 2021 15:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832059;
        bh=amChg7OJifCebh3m/Q9/SV42liX3vdgIrMBczXwxZFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tRE2jN8xkg+hJD6TT7OgYcVgOHOhnD8LazFp1+Dm/htFtJTEXseMLTCmogC+TsvqU
         jiXPklnJHjV99aUD4PwT5Bim68SYw9d/uTpKn3L1p62E3w+fb8Dp8xwPXc8405afiR
         f8qurbbXtLLt+eR7AuziFGvAogUoq6Msj7rxvZG0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 125/530] ARM: dts: renesas: Add mmc aliases into R-Car Gen2 board dts files
Date:   Wed, 12 May 2021 16:43:55 +0200
Message-Id: <20210512144823.925864869@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit da926e813fc7f9f0912fa413981a1f5ba63a536d ]

After set PROBE_PREFER_ASYNCHRONOUS flag on the mmc host drivers,
the order of /dev/mmcblkN was not fixed in some SoCs which have
multiple SDHI and/or MMCIF controllers. So, we were hard to use
such a device as rootfs by using the kernel parameter like
"root=/dev/mmcblkNpM".

According to the discussion on a mainling list [1], we can add
mmc aliases to fix the issue. So, add such aliases into R-Car Gen2
board dts files. Note that, since R-Car Gen2 is even more complicated
about SDHI and/or MMCIF channels variations and they share pins,
add the aliases into board dts files instead of SoC dtsi files.

[1]
https://lore.kernel.org/linux-arm-kernel/CAPDyKFptyEQNJu8cqzMt2WRFZcwEdjDiytMBp96nkoZyprTgmA@mail.gmail.com/

Fixes: 7320915c8861 ("mmc: Set PROBE_PREFER_ASYNCHRONOUS for drivers that existed in v4.14")
Fixes: 21b2cec61c04 ("mmc: Set PROBE_PREFER_ASYNCHRONOUS for drivers that existed in v4.4")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/1613131316-30994-1-git-send-email-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/r8a7790-lager.dts   | 3 +++
 arch/arm/boot/dts/r8a7791-koelsch.dts | 3 +++
 arch/arm/boot/dts/r8a7791-porter.dts  | 2 ++
 arch/arm/boot/dts/r8a7793-gose.dts    | 3 +++
 arch/arm/boot/dts/r8a7794-alt.dts     | 3 +++
 arch/arm/boot/dts/r8a7794-silk.dts    | 2 ++
 6 files changed, 16 insertions(+)

diff --git a/arch/arm/boot/dts/r8a7790-lager.dts b/arch/arm/boot/dts/r8a7790-lager.dts
index 09a152b91557..1d6f0c5d02e9 100644
--- a/arch/arm/boot/dts/r8a7790-lager.dts
+++ b/arch/arm/boot/dts/r8a7790-lager.dts
@@ -53,6 +53,9 @@
 		i2c11 = &i2cexio1;
 		i2c12 = &i2chdmi;
 		i2c13 = &i2cpwr;
+		mmc0 = &mmcif1;
+		mmc1 = &sdhi0;
+		mmc2 = &sdhi2;
 	};
 
 	chosen {
diff --git a/arch/arm/boot/dts/r8a7791-koelsch.dts b/arch/arm/boot/dts/r8a7791-koelsch.dts
index f603cba5441f..6af1727b8269 100644
--- a/arch/arm/boot/dts/r8a7791-koelsch.dts
+++ b/arch/arm/boot/dts/r8a7791-koelsch.dts
@@ -53,6 +53,9 @@
 		i2c12 = &i2cexio1;
 		i2c13 = &i2chdmi;
 		i2c14 = &i2cexio4;
+		mmc0 = &sdhi0;
+		mmc1 = &sdhi1;
+		mmc2 = &sdhi2;
 	};
 
 	chosen {
diff --git a/arch/arm/boot/dts/r8a7791-porter.dts b/arch/arm/boot/dts/r8a7791-porter.dts
index c6d563fb7ec7..bf51e29c793a 100644
--- a/arch/arm/boot/dts/r8a7791-porter.dts
+++ b/arch/arm/boot/dts/r8a7791-porter.dts
@@ -28,6 +28,8 @@
 		serial0 = &scif0;
 		i2c9 = &gpioi2c2;
 		i2c10 = &i2chdmi;
+		mmc0 = &sdhi0;
+		mmc1 = &sdhi2;
 	};
 
 	chosen {
diff --git a/arch/arm/boot/dts/r8a7793-gose.dts b/arch/arm/boot/dts/r8a7793-gose.dts
index abf487e8fe0f..2b59a0491350 100644
--- a/arch/arm/boot/dts/r8a7793-gose.dts
+++ b/arch/arm/boot/dts/r8a7793-gose.dts
@@ -49,6 +49,9 @@
 		i2c10 = &gpioi2c4;
 		i2c11 = &i2chdmi;
 		i2c12 = &i2cexio4;
+		mmc0 = &sdhi0;
+		mmc1 = &sdhi1;
+		mmc2 = &sdhi2;
 	};
 
 	chosen {
diff --git a/arch/arm/boot/dts/r8a7794-alt.dts b/arch/arm/boot/dts/r8a7794-alt.dts
index 3f1cc5bbf329..32025986b3b9 100644
--- a/arch/arm/boot/dts/r8a7794-alt.dts
+++ b/arch/arm/boot/dts/r8a7794-alt.dts
@@ -19,6 +19,9 @@
 		i2c10 = &gpioi2c4;
 		i2c11 = &i2chdmi;
 		i2c12 = &i2cexio4;
+		mmc0 = &mmcif0;
+		mmc1 = &sdhi0;
+		mmc2 = &sdhi1;
 	};
 
 	chosen {
diff --git a/arch/arm/boot/dts/r8a7794-silk.dts b/arch/arm/boot/dts/r8a7794-silk.dts
index 677596f6c9c9..af066ee5e275 100644
--- a/arch/arm/boot/dts/r8a7794-silk.dts
+++ b/arch/arm/boot/dts/r8a7794-silk.dts
@@ -31,6 +31,8 @@
 		serial0 = &scif2;
 		i2c9 = &gpioi2c1;
 		i2c10 = &i2chdmi;
+		mmc0 = &mmcif0;
+		mmc1 = &sdhi1;
 	};
 
 	chosen {
-- 
2.30.2



