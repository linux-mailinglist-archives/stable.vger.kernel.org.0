Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E32E629C215
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410988AbgJ0Rb0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:31:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:41754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750097AbgJ0OmL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:42:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BB6E206B2;
        Tue, 27 Oct 2020 14:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809731;
        bh=Z9uZAnmgGHJ32INYeOTMkXQS5l4BzWuMqHFivHWStm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QFWVYYFvX4A0psqjYTGaj7zBJytDuLjtqr4znqCx1ZI1sbSJGvCB5a2if+gZ5kBEA
         bAUZUmTRmnYyMpxQ2x6Uk+qXeUH8/0SIPjhRkUrSidqr1PcfsbR4VYog/EuxjGf3hk
         wViXhSeXF3/4OqF+dh401KC/v8zEBq6+drHZn3W8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@siol.net>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 299/408] ARM: dts: sun8i: r40: bananapi-m2-ultra: Fix dcdc1 regulator
Date:   Tue, 27 Oct 2020 14:53:57 +0100
Message-Id: <20201027135508.904503104@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jernej Skrabec <jernej.skrabec@siol.net>

[ Upstream commit 3658a2b7f3e16c7053eb8d70657b94bb62c5a0f4 ]

DCDC1 regulator powers many different subsystems. While some of them can
work at 3.0 V, some of them can not. For example, VCC-HDMI can only work
between 3.24 V and 3.36 V. According to OS images provided by the board
manufacturer this regulator should be set to 3.3 V.

Set DCDC1 and DCDC1SW to 3.3 V in order to fix this.

Fixes: da7ac948fa93 ("ARM: dts: sun8i: Add board dts file for Banana Pi M2 Ultra")
Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20200824193649.978197-1-jernej.skrabec@siol.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sun8i-r40-bananapi-m2-ultra.dts | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/sun8i-r40-bananapi-m2-ultra.dts b/arch/arm/boot/dts/sun8i-r40-bananapi-m2-ultra.dts
index 42d62d1ba1dc7..ea15073f0c79c 100644
--- a/arch/arm/boot/dts/sun8i-r40-bananapi-m2-ultra.dts
+++ b/arch/arm/boot/dts/sun8i-r40-bananapi-m2-ultra.dts
@@ -223,16 +223,16 @@ &reg_aldo3 {
 };
 
 &reg_dc1sw {
-	regulator-min-microvolt = <3000000>;
-	regulator-max-microvolt = <3000000>;
+	regulator-min-microvolt = <3300000>;
+	regulator-max-microvolt = <3300000>;
 	regulator-name = "vcc-gmac-phy";
 };
 
 &reg_dcdc1 {
 	regulator-always-on;
-	regulator-min-microvolt = <3000000>;
-	regulator-max-microvolt = <3000000>;
-	regulator-name = "vcc-3v0";
+	regulator-min-microvolt = <3300000>;
+	regulator-max-microvolt = <3300000>;
+	regulator-name = "vcc-3v3";
 };
 
 &reg_dcdc2 {
-- 
2.25.1



