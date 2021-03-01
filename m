Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E26F3328F38
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242003AbhCATr5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:47:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:50716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236405AbhCATgF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:36:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9B6F64FB1;
        Mon,  1 Mar 2021 17:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620112;
        bh=5QN8dPS99J8vScfccjiCNh2+4q/kkB0CYkYT9Qj73pI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mGzJp5DZk0DjVldpHxK9AtT1gGmT6SaS0VvbKj1LRHAXFsGol7yLOP5UDUYLxSZsY
         7CcrzHYMov3obDxU0VfomOX4AT5ofzS79TSfL9sAU/THmLOK1tXsX06BP9/6eQK7JJ
         4mEk4ab6ZTQOCoArs7Qjrv5CvLzA8O1FKCaHaGPU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 033/775] ARM: dts: exynos: correct PMIC interrupt trigger level on Arndale Octa
Date:   Mon,  1 Mar 2021 17:03:21 +0100
Message-Id: <20210301161203.356025703@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 1ac8893c4fa3d4a34915dc5cdab568a39db5086c ]

The Samsung PMIC datasheets describe the interrupt line as active low
with a requirement of acknowledge from the CPU.  The falling edge
interrupt will mostly work but it's not correct.

Fixes: 1fed2252713e ("ARM: dts: fix pinctrl for s2mps11-irq on exynos5420-arndale-octa")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20201210212903.216728-5-krzk@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos5420-arndale-octa.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos5420-arndale-octa.dts b/arch/arm/boot/dts/exynos5420-arndale-octa.dts
index bf457d0c02ebd..1aad4859c5f14 100644
--- a/arch/arm/boot/dts/exynos5420-arndale-octa.dts
+++ b/arch/arm/boot/dts/exynos5420-arndale-octa.dts
@@ -349,7 +349,7 @@
 		reg = <0x66>;
 
 		interrupt-parent = <&gpx3>;
-		interrupts = <2 IRQ_TYPE_EDGE_FALLING>;
+		interrupts = <2 IRQ_TYPE_LEVEL_LOW>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&s2mps11_irq>;
 
-- 
2.27.0



