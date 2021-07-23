Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9C13D3311
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 06:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234706AbhGWDT0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 23:19:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:37500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234511AbhGWDSq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 23:18:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76B6160F43;
        Fri, 23 Jul 2021 03:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627012757;
        bh=wZd7GICDbpRKRsD7R0W/4MnRtm5/nTxiCSVvxN715ls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B84zb8+ugwsEtng8sQ7ww8hWrrVf4tRHyBiO5C/sbP4x0vAjgtQoje0JYlfffZGa0
         cTkyPvWy98k4JGPqkcV10yaZnCFJXK0B4F64FsBNKAq3GoovFxGX3yUiKwSyTFMBPx
         duwK4X3MKRPds/aCN1s/suqxE2+kQY2RK7e8ZsR2ejR9GG++OBuaR1yhWI+fNzNFmx
         FONn6ylgZKZtHUbMFqspY1f22AxGwNw6LQ03I+SDYBXmCLXwFdsVq7/iq1IMMnBWWa
         v7+6kwVo+LKrWyafYjUubuXHHJbrAVXb3oHm1iClaAxcXh6Kkex9CLgrKuEJhwO/LL
         gua8tQGkDrV6Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sudeep Holla <sudeep.holla@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 7/7] ARM: dts: versatile: Fix up interrupt controller node names
Date:   Thu, 22 Jul 2021 23:59:06 -0400
Message-Id: <20210723035906.532444-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210723035906.532444-1-sashal@kernel.org>
References: <20210723035906.532444-1-sashal@kernel.org>
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
index 00d7d28e86f0..4633b79bf5ea 100644
--- a/arch/arm/boot/dts/versatile-ab.dts
+++ b/arch/arm/boot/dts/versatile-ab.dts
@@ -154,16 +154,15 @@ amba {
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
index 33a8eb28374e..3a23164c2c2d 100644
--- a/arch/arm/boot/dts/versatile-pb.dts
+++ b/arch/arm/boot/dts/versatile-pb.dts
@@ -6,7 +6,7 @@ / {
 
 	amba {
 		/* The Versatile PB is using more SIC IRQ lines than the AB */
-		sic: intc@10003000 {
+		sic: interrupt-controller@10003000 {
 			clear-mask = <0xffffffff>;
 			/*
 			 * Valid interrupt lines mask according to
-- 
2.30.2

