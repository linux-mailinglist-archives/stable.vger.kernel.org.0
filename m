Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48C0C3BCEC2
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234194AbhGFL1M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:27:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:35426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234469AbhGFLYc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:24:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAF5261CBC;
        Tue,  6 Jul 2021 11:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570302;
        bh=zitxiL8u4atmdpJKFak6cKFgHg9rSPTOWKskZ6B1fKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RrtRk3rl+cURXEm9XUnX1kNcsh+ACdscvb11GMnlcXGxGdYd2oZ9+hlRLt8e42t6Y
         ocChBoHCUaK7YZWo8rs/Qw48BF+q5ZdZCAxbjhVjN68hJxzQwq1bTJYlO3kTIIxk28
         iXycfe6YtCsD6M5qy3c0D626dhc0tON1sBOxDGxWFYLlk0BiiwNnFH8nmc9oka077u
         cxR4MweY6F/B8QUOF50Vh0vPZoNNln90zykQCAZfQMR9kqKzl+nhGBkdCgkeT1w+Df
         H+7itQUF7XBlAWLINSfEEJ/RH2rjg5DJPf8ybo+eu7rQfR6zoV6uOr1MCPEe0tz1zv
         LuMzkFYPlaA1g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?=E5=91=A8=E7=90=B0=E6=9D=B0=20=28Zhou=20Yanjie=29?= 
        <zhouyanjie@wanyeetech.com>, Nikolaus Schaller <hns@goldelico.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 189/189] MIPS: CI20: Reduce clocksource to 750 kHz.
Date:   Tue,  6 Jul 2021 07:14:09 -0400
Message-Id: <20210706111409.2058071-189-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
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

