Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A785029B2B0
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1762724AbgJ0OoQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:44:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:44066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762717AbgJ0OoP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:44:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D08C206E5;
        Tue, 27 Oct 2020 14:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809853;
        bh=90hMxgMJVJMG5m4QyhhBKHBuaCweauWKjEoOBQeLItY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rxxFrDCKsB3qPS5cfhVZYo/6K0yAHBDWDLrsJHBLxBLVgyZIqDDf6IsjU+YECgBBV
         R+BJkCZIXmMFGlx1NBpXlT8UMPFmEnyRWAaTe05agi/II0ZAe44J4roEy14gNYqRN0
         rneVVWIc48LN46PWmKA3sbTPWNEbnecUzoISwyPE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thomas Graichen <thomas.graichen@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 315/408] ARM: dts: meson8: remove two invalid interrupt lines from the GPU node
Date:   Tue, 27 Oct 2020 14:54:13 +0100
Message-Id: <20201027135509.643350745@linuxfoundation.org>
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

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit 737e7610b545cc901a9696083c1824a7104b8d1b ]

The 3.10 vendor kernel defines the following GPU 20 interrupt lines:
  #define INT_MALI_GP                 AM_IRQ(160)
  #define INT_MALI_GP_MMU             AM_IRQ(161)
  #define INT_MALI_PP                 AM_IRQ(162)
  #define INT_MALI_PMU                AM_IRQ(163)
  #define INT_MALI_PP0                AM_IRQ(164)
  #define INT_MALI_PP0_MMU            AM_IRQ(165)
  #define INT_MALI_PP1                AM_IRQ(166)
  #define INT_MALI_PP1_MMU            AM_IRQ(167)
  #define INT_MALI_PP2                AM_IRQ(168)
  #define INT_MALI_PP2_MMU            AM_IRQ(169)
  #define INT_MALI_PP3                AM_IRQ(170)
  #define INT_MALI_PP3_MMU            AM_IRQ(171)
  #define INT_MALI_PP4                AM_IRQ(172)
  #define INT_MALI_PP4_MMU            AM_IRQ(173)
  #define INT_MALI_PP5                AM_IRQ(174)
  #define INT_MALI_PP5_MMU            AM_IRQ(175)
  #define INT_MALI_PP6                AM_IRQ(176)
  #define INT_MALI_PP6_MMU            AM_IRQ(177)
  #define INT_MALI_PP7                AM_IRQ(178)
  #define INT_MALI_PP7_MMU            AM_IRQ(179)

However, the driver from the 3.10 vendor kernel does not use the
following four interrupt lines:
- INT_MALI_PP3
- INT_MALI_PP3_MMU
- INT_MALI_PP7
- INT_MALI_PP7_MMU

Drop the "pp3" and "ppmmu3" interrupt lines. This is also important
because there is no matching entry in interrupt-names for it (meaning
the "pp2" interrupt is actually assigned to the "pp3" interrupt line).

Fixes: 7d3f6b536e72c9 ("ARM: dts: meson8: add the Mali-450 MP6 GPU")
Reported-by: Thomas Graichen <thomas.graichen@gmail.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Tested-by: thomas graichen <thomas.graichen@gmail.com>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://lore.kernel.org/r/20200815181957.408649-1-martin.blumenstingl@googlemail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/meson8.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/boot/dts/meson8.dtsi b/arch/arm/boot/dts/meson8.dtsi
index db2033f674c67..3efe9d41c2bb6 100644
--- a/arch/arm/boot/dts/meson8.dtsi
+++ b/arch/arm/boot/dts/meson8.dtsi
@@ -230,8 +230,6 @@ mali: gpu@c0000 {
 				     <GIC_SPI 167 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 168 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 169 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 170 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 171 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 172 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 173 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 174 IRQ_TYPE_LEVEL_HIGH>,
-- 
2.25.1



