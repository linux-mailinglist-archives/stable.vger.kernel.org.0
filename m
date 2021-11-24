Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E360D45C409
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353676AbhKXNpL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:45:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:37522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353756AbhKXNoC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:44:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58C25632B9;
        Wed, 24 Nov 2021 12:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758767;
        bh=qR8ttzQ+HcT95TOU3T643QpXnqN44D8DenWBQhzqmzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F/NLqRJLKXSw7YLXzAkgcp9rsopJRbBaZBwwQgxpPAMbfIesx3x/ED4NXtbXvsL8i
         Z3TAyh7TnSV0F5QWiVKcHKZbAwc+J1Y5imh8Le1VHsxzN1dh868oNMZbZ+QPEHgXeT
         47PLi4lJt3WncGYKYvgoO17/i4Fb8JPMNnUjeHoA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Guillaume Gardet <guillaume.gardet@arm.com>,
        Matthias Brugger <mbrugger@suse.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 015/279] arm64: dts: rockchip: Disable CDN DP on Pinebook Pro
Date:   Wed, 24 Nov 2021 12:55:02 +0100
Message-Id: <20211124115719.276157433@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Brugger <mbrugger@suse.com>

[ Upstream commit 2513fa5c25d42f55ca5f0f0ab247af7c9fbfa3b1 ]

The CDN DP needs a PHY and a extcon to work correctly. But no extcon is
provided by the device-tree, which leads to an error:
cdn-dp fec00000.dp: [drm:cdn_dp_probe [rockchipdrm]] *ERROR* missing extcon or phy
cdn-dp: probe of fec00000.dp failed with error -22

Disable the CDN DP to make graphic work on the Pinebook Pro.

Reported-by: Guillaume Gardet <guillaume.gardet@arm.com>
Signed-off-by: Matthias Brugger <mbrugger@suse.com>
Link: https://lore.kernel.org/r/20210715164101.11486-1-matthias.bgg@kernel.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts b/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts
index 2b5f001ff4a61..9e5d07f5712e6 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts
@@ -385,10 +385,6 @@
 	};
 };
 
-&cdn_dp {
-	status = "okay";
-};
-
 &cpu_b0 {
 	cpu-supply = <&vdd_cpu_b>;
 };
-- 
2.33.0



