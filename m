Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75F3437C39D
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232617AbhELPVK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:21:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:57874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233500AbhELPS0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:18:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9FCC6199C;
        Wed, 12 May 2021 15:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832062;
        bh=0iQ3ZcR9sDO4tpwXXdU4VdJlvnkl3EZNlVgOaG9t/KM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z7fB7jwKaVO01p/D2IeITaJZP0lTiCDf5DRT9WLP6vqh3kFLhA7q+xl5i/vpihgo0
         YJMqg4KrCGI8w1gRlsbl0896NWlku3b3lOpscM8jWqJN670tALRPno9JlGL8jYL3NM
         QOhY5yySJo2rQ4xm1Xk3wWdmXDYAGN92XpFG8YtM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 126/530] arm64: dts: renesas: Add mmc aliases into board dts files
Date:   Wed, 12 May 2021 16:43:56 +0200
Message-Id: <20210512144823.957230372@linuxfoundation.org>
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

[ Upstream commit d765a4f302cc046ca23453ba990d21120ceadbbd ]

After the commit 7320915c8861 ("mmc: Set PROBE_PREFER_ASYNCHRONOUS
for drivers that existed in v4.14"), the order of /dev/mmcblkN
was not fixed in some SoCs which have multiple sdhi controllers.
So, we were hard to use an sdhi device as rootfs by using
the kernel parameter like "root=/dev/mmcblkNpM".

According to the discussion on a mainling list [1], we can add
mmc aliases to fix the issue. So, add such aliases into Renesas
arm64 board dts files. Notes that mmc0 is an eMMC channel if
available.

[1]
https://lore.kernel.org/linux-arm-kernel/CAPDyKFptyEQNJu8cqzMt2WRFZcwEdjDiytMBp96nkoZyprTgmA@mail.gmail.com/

Fixes: 7320915c8861 ("mmc: Set PROBE_PREFER_ASYNCHRONOUS for drivers that existed in v4.14")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/1614596786-22326-1-git-send-email-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/hihope-common.dtsi            | 3 +++
 arch/arm64/boot/dts/renesas/r8a774a1-beacon-rzg2m-kit.dts | 3 +++
 arch/arm64/boot/dts/renesas/r8a774c0-cat874.dts           | 2 ++
 arch/arm64/boot/dts/renesas/r8a77990-ebisu.dts            | 3 +++
 arch/arm64/boot/dts/renesas/salvator-common.dtsi          | 3 +++
 arch/arm64/boot/dts/renesas/ulcb-kf.dtsi                  | 1 +
 arch/arm64/boot/dts/renesas/ulcb.dtsi                     | 2 ++
 7 files changed, 17 insertions(+)

diff --git a/arch/arm64/boot/dts/renesas/hihope-common.dtsi b/arch/arm64/boot/dts/renesas/hihope-common.dtsi
index 2eda9f66ae81..e8bf6f0c4c40 100644
--- a/arch/arm64/boot/dts/renesas/hihope-common.dtsi
+++ b/arch/arm64/boot/dts/renesas/hihope-common.dtsi
@@ -12,6 +12,9 @@
 	aliases {
 		serial0 = &scif2;
 		serial1 = &hscif0;
+		mmc0 = &sdhi3;
+		mmc1 = &sdhi0;
+		mmc2 = &sdhi2;
 	};
 
 	chosen {
diff --git a/arch/arm64/boot/dts/renesas/r8a774a1-beacon-rzg2m-kit.dts b/arch/arm64/boot/dts/renesas/r8a774a1-beacon-rzg2m-kit.dts
index 2c5b057c30c6..ad26f5bf0648 100644
--- a/arch/arm64/boot/dts/renesas/r8a774a1-beacon-rzg2m-kit.dts
+++ b/arch/arm64/boot/dts/renesas/r8a774a1-beacon-rzg2m-kit.dts
@@ -21,6 +21,9 @@
 		serial4 = &hscif2;
 		serial5 = &scif5;
 		ethernet0 = &avb;
+		mmc0 = &sdhi3;
+		mmc1 = &sdhi0;
+		mmc2 = &sdhi2;
 	};
 
 	chosen {
diff --git a/arch/arm64/boot/dts/renesas/r8a774c0-cat874.dts b/arch/arm64/boot/dts/renesas/r8a774c0-cat874.dts
index 26aee004a44e..c4b50a5e3d92 100644
--- a/arch/arm64/boot/dts/renesas/r8a774c0-cat874.dts
+++ b/arch/arm64/boot/dts/renesas/r8a774c0-cat874.dts
@@ -17,6 +17,8 @@
 	aliases {
 		serial0 = &scif2;
 		serial1 = &hscif2;
+		mmc0 = &sdhi0;
+		mmc1 = &sdhi3;
 	};
 
 	chosen {
diff --git a/arch/arm64/boot/dts/renesas/r8a77990-ebisu.dts b/arch/arm64/boot/dts/renesas/r8a77990-ebisu.dts
index e0ccca2222d2..b9e3b6762ff4 100644
--- a/arch/arm64/boot/dts/renesas/r8a77990-ebisu.dts
+++ b/arch/arm64/boot/dts/renesas/r8a77990-ebisu.dts
@@ -16,6 +16,9 @@
 	aliases {
 		serial0 = &scif2;
 		ethernet0 = &avb;
+		mmc0 = &sdhi3;
+		mmc1 = &sdhi0;
+		mmc2 = &sdhi1;
 	};
 
 	chosen {
diff --git a/arch/arm64/boot/dts/renesas/salvator-common.dtsi b/arch/arm64/boot/dts/renesas/salvator-common.dtsi
index 1bf77957d2c2..08b8525bb725 100644
--- a/arch/arm64/boot/dts/renesas/salvator-common.dtsi
+++ b/arch/arm64/boot/dts/renesas/salvator-common.dtsi
@@ -36,6 +36,9 @@
 		serial0 = &scif2;
 		serial1 = &hscif1;
 		ethernet0 = &avb;
+		mmc0 = &sdhi2;
+		mmc1 = &sdhi0;
+		mmc2 = &sdhi3;
 	};
 
 	chosen {
diff --git a/arch/arm64/boot/dts/renesas/ulcb-kf.dtsi b/arch/arm64/boot/dts/renesas/ulcb-kf.dtsi
index 202177706cde..05e64bfad023 100644
--- a/arch/arm64/boot/dts/renesas/ulcb-kf.dtsi
+++ b/arch/arm64/boot/dts/renesas/ulcb-kf.dtsi
@@ -16,6 +16,7 @@
 	aliases {
 		serial1 = &hscif0;
 		serial2 = &scif1;
+		mmc2 = &sdhi3;
 	};
 
 	clksndsel: clksndsel {
diff --git a/arch/arm64/boot/dts/renesas/ulcb.dtsi b/arch/arm64/boot/dts/renesas/ulcb.dtsi
index a2e085db87c5..e11521b4b9ca 100644
--- a/arch/arm64/boot/dts/renesas/ulcb.dtsi
+++ b/arch/arm64/boot/dts/renesas/ulcb.dtsi
@@ -23,6 +23,8 @@
 	aliases {
 		serial0 = &scif2;
 		ethernet0 = &avb;
+		mmc0 = &sdhi2;
+		mmc1 = &sdhi0;
 	};
 
 	chosen {
-- 
2.30.2



