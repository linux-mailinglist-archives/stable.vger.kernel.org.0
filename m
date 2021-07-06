Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87F273BD02C
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235411AbhGFLcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:32:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:42474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235870AbhGFLaa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:30:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BAA261DEB;
        Tue,  6 Jul 2021 11:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570521;
        bh=zitxiL8u4atmdpJKFak6cKFgHg9rSPTOWKskZ6B1fKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R4NmY1UGecH6R676i9CSNeeYug6GV8RGVRz7MryV3O3ChHpErrBa68UG3QUROg4Qg
         34QtEKZbzHpt51c2C7g3MnhaQOdqanJABbcEjIuMgD1sKvNijnmas8YLczHSJqdKOO
         5LYkJu9xX4NH/VlT/MvfISp8A16tKE66hVWCjgRUr78RtgB5vmEsE+MhONsgEqWEpL
         4dkqFkIUmdzUZ8lS4XGQoju3fa7HObaUW4NlIXVuGHGzDngJE6705QQEokAWd6YWWc
         EF3bC/Zv9BIbt4ETNfpeIZoZdqTX0ua5aPpvHO47pCdoTJHBYwo5ftO78vTUqpzxtU
         y0gHcNvZfh8yA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?=E5=91=A8=E7=90=B0=E6=9D=B0=20=28Zhou=20Yanjie=29?= 
        <zhouyanjie@wanyeetech.com>, Nikolaus Schaller <hns@goldelico.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 160/160] MIPS: CI20: Reduce clocksource to 750 kHz.
Date:   Tue,  6 Jul 2021 07:18:26 -0400
Message-Id: <20210706111827.2060499-160-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>

[ Upstream commit 23c64447b3538a6f34cb38aae3bc19dc1ec53436 ]

The original clock (3 MHz) is too fast for the clocksource,
there will be a chance that the system may get stuck.

Reported-by: Nikolaus Schaller <hns@goldelico.com>
Tested-by: Nikolaus Schaller <hns@goldelico.com> # on CI20
Signed-off-by: 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
Acked-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/boot/dts/ingenic/ci20.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/boot/dts/ingenic/ci20.dts b/arch/mips/boot/dts/ingenic/ci20.dts
index 8877c62609de..3a4eaf1f3f48 100644
--- a/arch/mips/boot/dts/ingenic/ci20.dts
+++ b/arch/mips/boot/dts/ingenic/ci20.dts
@@ -525,10 +525,10 @@ pins_mmc1: mmc1 {
 
 &tcu {
 	/*
-	 * 750 kHz for the system timer and 3 MHz for the clocksource,
+	 * 750 kHz for the system timer and clocksource,
 	 * use channel #0 for the system timer, #1 for the clocksource.
 	 */
 	assigned-clocks = <&tcu TCU_CLK_TIMER0>, <&tcu TCU_CLK_TIMER1>,
 					  <&tcu TCU_CLK_OST>;
-	assigned-clock-rates = <750000>, <3000000>, <3000000>;
+	assigned-clock-rates = <750000>, <750000>, <3000000>;
 };
-- 
2.30.2

