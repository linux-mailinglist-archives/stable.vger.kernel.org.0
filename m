Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 849663CA925
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242270AbhGOTFb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:05:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243372AbhGOTEU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:04:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDA4D613F9;
        Thu, 15 Jul 2021 18:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375598;
        bh=6JATwP12G/64FbgrNsJhSq7lJ8aC9o29Lv6SkZrlzBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MguIofEP+Imbew8odYHMip7NBqbooqoN7bQPx3PKWFrgD5I04k4eSVUtR17o5wZ3y
         wxzsZu99KHpKb6O8GW80gNzxl6WH1CG+MkC2BjUEY0tPKFuSA3kR+VT1AWC5en1IsL
         f2XfsEaElJYqpKDunH521YAslqqabZs+KfO4Bb2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolaus Schaller <hns@goldelico.com>,
        =?UTF-8?q?=E5=91=A8=E7=90=B0=E6=9D=B0=20 ?= 
        <zhouyanjie@wanyeetech.com>, Paul Cercueil <paul@crapouillou.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 153/242] MIPS: CI20: Reduce clocksource to 750 kHz.
Date:   Thu, 15 Jul 2021 20:38:35 +0200
Message-Id: <20210715182620.181549345@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -525,10 +525,10 @@
 
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



