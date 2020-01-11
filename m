Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52C58137F11
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730241AbgAKKQV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:16:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:59216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730151AbgAKKQV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:16:21 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B6222082E;
        Sat, 11 Jan 2020 10:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737780;
        bh=4YIWANv+xk2ULjgUiU9TKCAH+VD5k1p14EtAPNJLawo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DdSwxXLDvO//f+Gkh47cdpffca/XdO75+RZDrYRnSnCFHsWLg892MXg0/6ZgM6/Ay
         y4ayOxlOm+yvMguOd2dxE+UBIOZGju1ZG29EtHrFP7TC8ukk/62bhgyrDhFHG7gdIB
         /bCwgZfpuqsm17yS1p10DSi+EqETRAixVveV5YgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Wahren <wahrenst@gmx.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 26/84] ARM: dts: bcm283x: Fix critical trip point
Date:   Sat, 11 Jan 2020 10:50:03 +0100
Message-Id: <20200111094855.550236467@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094845.328046411@linuxfoundation.org>
References: <20200111094845.328046411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit 30e647a764d446723a7e0fb08d209e0104f16173 ]

During definition of the CPU thermal zone of BCM283x SoC family there
was a misunderstanding of the meaning "criticial trip point" and the
thermal throttling range of the VideoCore firmware. The latter one takes
effect when the core temperature is at least 85 degree celsius or higher

So the current critical trip point doesn't make sense, because the
thermal shutdown appears before the firmware has a chance to throttle
the ARM core(s).

Fix these unwanted shutdowns by increasing the critical trip point
to a value which shouldn't be reached with working thermal throttling.

Fixes: 0fe4d2181cc4 ("ARM: dts: bcm283x: Add CPU thermal zone with 1 trip point")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm283x.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/bcm283x.dtsi b/arch/arm/boot/dts/bcm283x.dtsi
index 31b29646b14c..c9322a56300d 100644
--- a/arch/arm/boot/dts/bcm283x.dtsi
+++ b/arch/arm/boot/dts/bcm283x.dtsi
@@ -39,7 +39,7 @@
 
 			trips {
 				cpu-crit {
-					temperature	= <80000>;
+					temperature	= <90000>;
 					hysteresis	= <0>;
 					type		= "critical";
 				};
-- 
2.20.1



