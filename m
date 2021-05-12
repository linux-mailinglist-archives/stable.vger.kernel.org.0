Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A90137CBBD
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236292AbhELQhc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:37:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:42866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241769AbhELQ2B (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:28:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45E0A6192E;
        Wed, 12 May 2021 15:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834966;
        bh=oJGOtWf5diqt86+DpzvJLw275TxZh87Cp4YrcVa3NX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rpyqmBAXjHA0/qkWVxY+7UIlNeUafJpp3gxWQjpvwSccStGVQZWrynwlmgv7r8N9H
         q9pDjWzkuy+e3w/fjYsPWkIeMHsMO3u0TJ+4jM/CR4h6B3sHM/nAKOU1i+AFz6yiR6
         giZE62CLK+MOPKHfZL/FJ0CRrhFfvfqyMe4ZeECM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 156/677] arm64: dts: renesas: Add mmc aliases into board dts files
Date:   Wed, 12 May 2021 16:43:22 +0200
Message-Id: <20210512144842.421159389@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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
 arch/arm64/boot/dts/renesas/r8a774b1-beacon-rzg2n-kit.dts | 3 +++
 arch/arm64/boot/dts/renesas/r8a774c0-cat874.dts           | 2 ++
 arch/arm64/boot/dts/renesas/r8a774e1-beacon-rzg2h-kit.dts | 3 +++
 arch/arm64/boot/dts/renesas/r8a77990-ebisu.dts            | 3 +++
 arch/arm64/boot/dts/renesas/salvator-common.dtsi          | 3 +++
 arch/arm64/boot/dts/renesas/ulcb-kf.dtsi                  | 1 +
 arch/arm64/boot/dts/renesas/ulcb.dtsi                     | 2 ++
 9 files changed, 23 insertions(+)

diff --git a/arch/arm64/boot/dts/renesas/hihope-common.dtsi b/arch/arm64/boot/dts/renesas/hihope-common.dtsi
index 7a3da9b06f67..0c7e6f790590 100644
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
index 501cb05da228..3cf2e076940f 100644
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
diff --git a/arch/arm64/boot/dts/renesas/r8a774b1-beacon-rzg2n-kit.dts b/arch/arm64/boot/dts/renesas/r8a774b1-beacon-rzg2n-kit.dts
index 71763f4402a7..3c0d59def8ee 100644
--- a/arch/arm64/boot/dts/renesas/r8a774b1-beacon-rzg2n-kit.dts
+++ b/arch/arm64/boot/dts/renesas/r8a774b1-beacon-rzg2n-kit.dts
@@ -22,6 +22,9 @@
 		serial5 = &scif5;
 		serial6 = &scif4;
 		ethernet0 = &avb;
+		mmc0 = &sdhi3;
+		mmc1 = &sdhi0;
+		mmc2 = &sdhi2;
 	};
 
 	chosen {
diff --git a/arch/arm64/boot/dts/renesas/r8a774c0-cat874.dts b/arch/arm64/boot/dts/renesas/r8a774c0-cat874.dts
index ea87cb5a459c..33257c6440b2 100644
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
diff --git a/arch/arm64/boot/dts/renesas/r8a774e1-beacon-rzg2h-kit.dts b/arch/arm64/boot/dts/renesas/r8a774e1-beacon-rzg2h-kit.dts
index 273f062f2909..7b6649a3ded0 100644
--- a/arch/arm64/boot/dts/renesas/r8a774e1-beacon-rzg2h-kit.dts
+++ b/arch/arm64/boot/dts/renesas/r8a774e1-beacon-rzg2h-kit.dts
@@ -22,6 +22,9 @@
 		serial5 = &scif5;
 		serial6 = &scif4;
 		ethernet0 = &avb;
+		mmc0 = &sdhi3;
+		mmc1 = &sdhi0;
+		mmc2 = &sdhi2;
 	};
 
 	chosen {
diff --git a/arch/arm64/boot/dts/renesas/r8a77990-ebisu.dts b/arch/arm64/boot/dts/renesas/r8a77990-ebisu.dts
index f74f8b9993f1..6d6cdc4c324b 100644
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
index c22bb38994e8..15bb1eeb6601 100644
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
index e9ed2597f1c2..61bd4df09df0 100644
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
index a04eae55dd6c..3d88e95c65a5 100644
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



