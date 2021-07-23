Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0383D32DB
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 05:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234413AbhGWDSc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 23:18:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:38796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234208AbhGWDSA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 23:18:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B42760F26;
        Fri, 23 Jul 2021 03:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627012714;
        bh=IvaR99okyfXtAYNEkh/0FqubNa6g3Pw/UCxd58DNFpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OOzD2NnrItJI72PeUww4dH1LLk3iJiLljB+QCfTGm9x+OQ7QweMUZo0omolYxU+uF
         /V23YiVJtRJwUYTfJeEJRURbovtxIb3ABOfRAvskZrk3pSHDrJKt/d5Utb0RvXaWfK
         yLzQ8P7XEqeQtwPPKyl/HbRHb6B/zoUtmlIvwO5j7cFgHaWhsnFYzoH43C3uyLc63x
         IxUqpeYI/C0zh6U3XH+PMwvQPIoPGn2F+S/aCGyBEKVYf0lJEGpfyGkCbsQh1TtxTx
         nMWHkAvwenRMXcH2/qh9u09k0xFzqA11sGkaHTZQP0JowkNz9Q48Wgbn5GxpQsB9xr
         A39Wv4nXHrfdA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sudeep Holla <sudeep.holla@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 14/14] ARM: dts: versatile: Fix up interrupt controller node names
Date:   Thu, 22 Jul 2021 23:58:13 -0400
Message-Id: <20210723035813.531837-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210723035813.531837-1-sashal@kernel.org>
References: <20210723035813.531837-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 82a1c67554dff610d6be4e1982c425717b3c6a23 ]

Once the new schema interrupt-controller/arm,vic.yaml is added, we get
the below warnings:

        arch/arm/boot/dts/versatile-ab.dt.yaml:
        intc@10140000: $nodename:0: 'intc@10140000' does not match
        '^interrupt-controller(@[0-9a-f,]+)*$'

	arch/arm/boot/dts/versatile-ab.dt.yaml:
	intc@10140000: 'clear-mask' does not match any of the regexes

Fix the node names for the interrupt controller to conform
to the standard node name interrupt-controller@.. Also drop invalid
clear-mask property.

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20210701132118.759454-1-sudeep.holla@arm.com'
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/versatile-ab.dts | 5 ++---
 arch/arm/boot/dts/versatile-pb.dts | 2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/versatile-ab.dts b/arch/arm/boot/dts/versatile-ab.dts
index 37bd41ff8dff..151c0220047d 100644
--- a/arch/arm/boot/dts/versatile-ab.dts
+++ b/arch/arm/boot/dts/versatile-ab.dts
@@ -195,16 +195,15 @@ amba {
 		#size-cells = <1>;
 		ranges;
 
-		vic: intc@10140000 {
+		vic: interrupt-controller@10140000 {
 			compatible = "arm,versatile-vic";
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			reg = <0x10140000 0x1000>;
-			clear-mask = <0xffffffff>;
 			valid-mask = <0xffffffff>;
 		};
 
-		sic: intc@10003000 {
+		sic: interrupt-controller@10003000 {
 			compatible = "arm,versatile-sic";
 			interrupt-controller;
 			#interrupt-cells = <1>;
diff --git a/arch/arm/boot/dts/versatile-pb.dts b/arch/arm/boot/dts/versatile-pb.dts
index 06a0fdf24026..e7e751a858d8 100644
--- a/arch/arm/boot/dts/versatile-pb.dts
+++ b/arch/arm/boot/dts/versatile-pb.dts
@@ -7,7 +7,7 @@ / {
 
 	amba {
 		/* The Versatile PB is using more SIC IRQ lines than the AB */
-		sic: intc@10003000 {
+		sic: interrupt-controller@10003000 {
 			clear-mask = <0xffffffff>;
 			/*
 			 * Valid interrupt lines mask according to
-- 
2.30.2

