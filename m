Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B59EB126CE9
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728898AbfLSSnr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:43:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:35560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728865AbfLSSnr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:43:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34C6D24672;
        Thu, 19 Dec 2019 18:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781026;
        bh=VSBIhfZCukb3KkAC7X5bF+mpEdHCaVQdLhX+frrXC4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bC5pC1wMBS9hH3vdfadh96lQ9OhzpygtI8szRUGWRm/zgSKkmkC8tzg7s08va7/EZ
         K9Q8Q9ROBTqbEtdCuB94hBh6vDy7r419QLqnb+FSZJC0RfH2rGomoeAl/L+m0kT+U+
         8ErceuFzVs+BXPBHpZYTLKbzZx8hKZQBd+cKw3+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh@kernel.org>, Olof Johansson <olof@lixom.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 053/199] ARM: dts: realview-pbx: Fix duplicate regulator nodes
Date:   Thu, 19 Dec 2019 19:32:15 +0100
Message-Id: <20191219183217.894949173@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
References: <20191219183214.629503389@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

[ Upstream commit 7f4b001b7f6e0480b5bdab9cd8ce1711e43e5cb5 ]

There's a bug in dtc in checking for duplicate node names when there's
another section (e.g. "/ { };"). In this case, skeleton.dtsi provides
another section. Upon removal of skeleton.dtsi, the dtb fails to build
due to a duplicate node 'fixedregulator@0'. As both nodes were pretty
much the same 3.3V fixed regulator, it hasn't really mattered. Fix this
by renaming the nodes to something unique. In the process, drop the
unit-address which shouldn't be present wtihout reg property.

Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/arm-realview-pbx.dtsi | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/arm-realview-pbx.dtsi b/arch/arm/boot/dts/arm-realview-pbx.dtsi
index 2bf3958b2e6b9..068293254fbb8 100644
--- a/arch/arm/boot/dts/arm-realview-pbx.dtsi
+++ b/arch/arm/boot/dts/arm-realview-pbx.dtsi
@@ -43,7 +43,7 @@
 	};
 
 	/* The voltage to the MMC card is hardwired at 3.3V */
-	vmmc: fixedregulator@0 {
+	vmmc: regulator-vmmc {
 		compatible = "regulator-fixed";
 		regulator-name = "vmmc";
 		regulator-min-microvolt = <3300000>;
@@ -51,7 +51,7 @@
 		regulator-boot-on;
         };
 
-	veth: fixedregulator@0 {
+	veth: regulator-veth {
 		compatible = "regulator-fixed";
 		regulator-name = "veth";
 		regulator-min-microvolt = <3300000>;
@@ -539,4 +539,3 @@
 		};
 	};
 };
-
-- 
2.20.1



