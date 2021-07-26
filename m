Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17AF13D6169
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbhGZPbN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:31:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:41562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237864AbhGZP30 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:29:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 982A360F6F;
        Mon, 26 Jul 2021 16:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315737;
        bh=bWYR+mVvLvtWHQFTO4WOs8jlJzxPhx3XP8e1p0FrMho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wPDHEzF/A+XAXz8XKzrKBIY4zsZzcqkUgr7MEcYNXNVaBg4LeBKwZFjkM/QPCoPFF
         cK87F+Gh2TmTwkalRCGixvoJO35D15fNwIlKBgcl8UxzY+AAH5NHRxwd0vM9SR2SvT
         IYhTQk80rgp9fuTLd3IKerIb8vYZlp33EONBLxNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zev Weiss <zev@bewilderbeest.net>,
        Andrew Jeffery <andrew@aj.id.au>,
        Joel Stanley <joel@jms.id.au>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 047/223] ARM: dts: aspeed: Update e3c246d4i vuart properties
Date:   Mon, 26 Jul 2021 17:37:19 +0200
Message-Id: <20210726153847.812063681@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zev Weiss <zev@bewilderbeest.net>

[ Upstream commit 812bae32e5d50914f75a6e036d3bde39ca86b0c3 ]

This device-tree was merged with a provisional vuart IRQ-polarity
property that was still under review and ended up taking a somewhat
different form.  This patch updates it to match the final form of the
new vuart properties, which additionally allow specifying the SIRQ
number and LPC address.

Signed-off-by: Zev Weiss <zev@bewilderbeest.net>
Reviewed-by: Andrew Jeffery <andrew@aj.id.au>
Fixes: ca03042f0f12 ("serial: 8250_aspeed_vuart: add aspeed, lpc-io-reg and aspeed, lpc-interrupts DT properties")
Reviewed-by: Joel Stanley <joel@jms.id.au>
Link: https://lore.kernel.org/r/20210416075113.18047-1-zev@bewilderbeest.net
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/aspeed-bmc-asrock-e3c246d4i.dts | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/aspeed-bmc-asrock-e3c246d4i.dts b/arch/arm/boot/dts/aspeed-bmc-asrock-e3c246d4i.dts
index dcab6e78dfa4..8be40c8283af 100644
--- a/arch/arm/boot/dts/aspeed-bmc-asrock-e3c246d4i.dts
+++ b/arch/arm/boot/dts/aspeed-bmc-asrock-e3c246d4i.dts
@@ -4,6 +4,7 @@
 #include "aspeed-g5.dtsi"
 #include <dt-bindings/gpio/aspeed-gpio.h>
 #include <dt-bindings/i2c/i2c.h>
+#include <dt-bindings/interrupt-controller/irq.h>
 
 /{
 	model = "ASRock E3C246D4I BMC";
@@ -73,7 +74,8 @@
 
 &vuart {
 	status = "okay";
-	aspeed,sirq-active-high;
+	aspeed,lpc-io-reg = <0x2f8>;
+	aspeed,lpc-interrupts = <3 IRQ_TYPE_LEVEL_HIGH>;
 };
 
 &mac0 {
-- 
2.30.2



