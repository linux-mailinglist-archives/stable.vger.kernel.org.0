Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 938AC23A483
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728676AbgHCM2D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:28:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:53988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728103AbgHCM2B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:28:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B945D2083B;
        Mon,  3 Aug 2020 12:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457680;
        bh=5ZTbntYsx//AIdI+J6uU78DsJOWtvYZYlI+yqOfRk6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=visktFZ9BPwhgStNUf+jN17wr1lT+FHgbj7o6EjyXy/WHuJ2FO/6FegyVHPHsibJN
         t+uwZw4LWbu3R/r2kjOMvmQEsh7yPFAM7bdIQCtDC6O108b/mK4BcYyYxrcPDQQHOq
         kQBkrXFxr3RUgrsoL7FtTFq+rzxYi1uZ0YJGgR0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Chen-Yu Tsai <wens@csie.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 36/90] ARM: dts sunxi: Relax a bit the CMA pool allocation range
Date:   Mon,  3 Aug 2020 14:18:58 +0200
Message-Id: <20200803121859.358937552@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121857.546052424@linuxfoundation.org>
References: <20200803121857.546052424@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 92025b90f18d45e26b7f17d68756b1abd771b9d3 ]

The hardware codec on the A10, A10s, A13 and A20 needs buffer in the
first 256MB of RAM. This was solved by setting the CMA pool at a fixed
address in that range.

However, in recent kernels there's something else that comes in and
reserve some range that end up conflicting with our default pool
requirement, and thus makes its reservation fail.

The video codec will then use buffers from the usual default pool,
outside of the range it can access, and will fail to decode anything.

Since we're only concerned about that 256MB, we can however relax the
allocation to just specify the range that's allowed, and not try to
enforce a specific address.

Fixes: 5949bc5602cc ("ARM: dts: sun4i-a10: Add Video Engine and reserved memory nodes")
Fixes: 960432010156 ("ARM: dts: sun5i: Add Video Engine and reserved memory nodes")
Fixes: c2a641a74850 ("ARM: dts: sun7i-a20: Add Video Engine and reserved memory nodes")
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Acked-by: Chen-Yu Tsai <wens@csie.org>
Link: https://lore.kernel.org/r/20200704130829.34297-1-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sun4i-a10.dtsi | 2 +-
 arch/arm/boot/dts/sun5i.dtsi     | 2 +-
 arch/arm/boot/dts/sun7i-a20.dtsi | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/sun4i-a10.dtsi b/arch/arm/boot/dts/sun4i-a10.dtsi
index 4c268b70b7357..e0a9b371c248f 100644
--- a/arch/arm/boot/dts/sun4i-a10.dtsi
+++ b/arch/arm/boot/dts/sun4i-a10.dtsi
@@ -198,7 +198,7 @@
 		default-pool {
 			compatible = "shared-dma-pool";
 			size = <0x6000000>;
-			alloc-ranges = <0x4a000000 0x6000000>;
+			alloc-ranges = <0x40000000 0x10000000>;
 			reusable;
 			linux,cma-default;
 		};
diff --git a/arch/arm/boot/dts/sun5i.dtsi b/arch/arm/boot/dts/sun5i.dtsi
index 6befa236ba99d..fd31da8fd3112 100644
--- a/arch/arm/boot/dts/sun5i.dtsi
+++ b/arch/arm/boot/dts/sun5i.dtsi
@@ -117,7 +117,7 @@
 		default-pool {
 			compatible = "shared-dma-pool";
 			size = <0x6000000>;
-			alloc-ranges = <0x4a000000 0x6000000>;
+			alloc-ranges = <0x40000000 0x10000000>;
 			reusable;
 			linux,cma-default;
 		};
diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index 8aebefd6accfe..1f8b45f07e58f 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -180,7 +180,7 @@
 		default-pool {
 			compatible = "shared-dma-pool";
 			size = <0x6000000>;
-			alloc-ranges = <0x4a000000 0x6000000>;
+			alloc-ranges = <0x40000000 0x10000000>;
 			reusable;
 			linux,cma-default;
 		};
-- 
2.25.1



