Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 047A93DD7DD
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234422AbhHBNsX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:48:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:57350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234379AbhHBNsF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:48:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AC3F61057;
        Mon,  2 Aug 2021 13:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912075;
        bh=/YLE1i6wXKxsu9XqjoLR7bM/xs7iFwxeKPsG/6BQkwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y4wH31WEzTqCOsdGmQTiCCaA4jlrN2TGKClhgeObfogsfRt42wy4x9DGB4XdNv2s+
         FoJEUvaUs8A2OuROHNghaUXhR5viqyTKMBDSITK72T9yIfAxlvSfP6Y1rGWePfnSNA
         W5Gcr/jJP451/y/f5jyrjuZjWet4K6y9ERt4JssA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 12/32] ARM: dts: versatile: Fix up interrupt controller node names
Date:   Mon,  2 Aug 2021 15:44:32 +0200
Message-Id: <20210802134333.315221261@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134332.931915241@linuxfoundation.org>
References: <20210802134332.931915241@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 arch/arm/boot/dts/versatile-ab.dts |    5 ++---
 arch/arm/boot/dts/versatile-pb.dts |    2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

--- a/arch/arm/boot/dts/versatile-ab.dts
+++ b/arch/arm/boot/dts/versatile-ab.dts
@@ -154,16 +154,15 @@
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
--- a/arch/arm/boot/dts/versatile-pb.dts
+++ b/arch/arm/boot/dts/versatile-pb.dts
@@ -6,7 +6,7 @@
 
 	amba {
 		/* The Versatile PB is using more SIC IRQ lines than the AB */
-		sic: intc@10003000 {
+		sic: interrupt-controller@10003000 {
 			clear-mask = <0xffffffff>;
 			/*
 			 * Valid interrupt lines mask according to


