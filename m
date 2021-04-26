Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 901ED36AE2E
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbhDZHlx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:41:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:50372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232306AbhDZHjt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:39:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 743CC613DC;
        Mon, 26 Apr 2021 07:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422700;
        bh=jWuPGdDi384ntnij8i0Gs8VGUiPDAgmsicEAbHG0cFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZNsanuxMTw5UtU24WSQ8ISiVw3ypt/waSWzXVlH3J2U8xv0cQ1tid9y29vr3qM1DW
         SEn70mc7m0goMvvcqcXaBnd/PY6FRmwPmj/FfxTX6VIYMRDDfVGZm3ragNLI63riot
         gRe/NUhlJETKKLfVLjS5FtGItAgORiDyEOiO8X+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Weiser <michael.weiser@gmx.de>,
        Daniel Kulesz <kuleszdl@posteo.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 04/20] arm64: dts: allwinner: Revert SD card CD GPIO for Pine64-LTS
Date:   Mon, 26 Apr 2021 09:29:55 +0200
Message-Id: <20210426072816.827065921@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072816.686976183@linuxfoundation.org>
References: <20210426072816.686976183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit 4d09ccc4a81e7de6b002482af554d8b5626f5041 ]

Commit 941432d00768 ("arm64: dts: allwinner: Drop non-removable from
SoPine/LTS SD card") enabled the card detect GPIO for the SOPine module,
along the way with the Pine64-LTS, which share the same base .dtsi.

This was based on the observation that the Pine64-LTS has as "push-push"
SD card socket, and that the schematic mentions the card detect GPIO.

After having received two reports about failing SD card access with that
patch, some more research and polls on that subject revealed that there
are at least two different versions of the Pine64-LTS out there:
- On some boards (including mine) the card detect pin is "stuck" at
  high, regardless of an microSD card being inserted or not.
- On other boards the card-detect is working, but is active-high, by
  virtue of an explicit inverter circuit, as shown in the schematic.

To cover all versions of the board out there, and don't take any chances,
let's revert the introduction of the active-low CD GPIO, but let's use
the broken-cd property for the Pine64-LTS this time. That should avoid
regressions and should work for everyone, even allowing SD card changes
now.
The SOPine card detect has proven to be working, so let's keep that
GPIO in place.

Fixes: 941432d00768 ("arm64: dts: allwinner: Drop non-removable from SoPine/LTS SD card")
Reported-by: Michael Weiser <michael.weiser@gmx.de>
Reported-by: Daniel Kulesz <kuleszdl@posteo.org>
Suggested-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Tested-by: Michael Weiser <michael.weiser@gmx.de>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20210414104740.31497-1-andre.przywara@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-a64-pine64-lts.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64-pine64-lts.dts b/arch/arm64/boot/dts/allwinner/sun50i-a64-pine64-lts.dts
index 8d15164f2a3c..7eb252adf9f0 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64-pine64-lts.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-pine64-lts.dts
@@ -13,5 +13,5 @@
 };
 
 &mmc0 {
-	cd-gpios = <&pio 5 6 GPIO_ACTIVE_LOW>; /* PF6 push-push switch */
+	broken-cd;		/* card detect is broken on *some* boards */
 };
-- 
2.30.2



