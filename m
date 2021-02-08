Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF0231376F
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233705AbhBHPZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:25:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:60182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233632AbhBHPTq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:19:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC58C64EE5;
        Mon,  8 Feb 2021 15:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797164;
        bh=m29GOr1ZNRbuTh+yg0paSYXRRR4viAiudyCE0w116cU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I5OLdsKC2QKzrXElF/1Rjw227nevmOMnLqVb9lJdRupFlYC9uDTnhh8O5tNhtYdQL
         f/Pj0BWiBB7tdeXaS/yggd78ukZO03o0ildeVtzGm+Pm4TV3l/nwZozHFEgL8MY4th
         wYb7meQ6Lc6tTVvZul30VQoP/yLpfFo5eBvBf29I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 015/120] arm64: dts: qcom: c630: keep both touchpad devices enabled
Date:   Mon,  8 Feb 2021 16:00:02 +0100
Message-Id: <20210208145819.002423018@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shawn Guo <shawn.guo@linaro.org>

[ Upstream commit a9164910c5ceed63551280a4a0b85d37ac2b19a5 ]

Indicated by AML code in ACPI table, the touchpad in-use could be found
on two possible slave addresses on &i2c3, i.e. hid@15 and hid@2c.  And
which one is in-use can be determined by reading another address on the
I2C bus.  Unfortunately, for DT boot, there is currently no support in
firmware to make this check and patch DT accordingly.  This results in
a non-functional touchpad on those C630 devices with hid@2c.

As i2c-hid driver will stop probing the device if there is nothing on
the slave address, we can actually keep both devices enabled in DT, and
i2c-hid driver will only probe the existing one.  The only problem is
that we cannot set up pinctrl in both device nodes, as two devices with
the same pinctrl will cause pin conflict that makes the second device
fail to probe.  Let's move the pinctrl state up to parent node to solve
this problem.  As the pinctrl state of parent node is already defined in
sdm845.dtsi, it ends up with overwriting pinctrl-0 with i2c3_hid_active
state added in there.

Fixes: 11d0e4f28156 ("arm64: dts: qcom: c630: Polish i2c-hid devices")
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Link: https://lore.kernel.org/r/20210102045940.26874-1-shawn.guo@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
index 76a8c996d497f..d70aae77a6e84 100644
--- a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
+++ b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
@@ -263,6 +263,8 @@
 &i2c3 {
 	status = "okay";
 	clock-frequency = <400000>;
+	/* Overwrite pinctrl-0 from sdm845.dtsi */
+	pinctrl-0 = <&qup_i2c3_default &i2c3_hid_active>;
 
 	tsel: hid@15 {
 		compatible = "hid-over-i2c";
@@ -270,9 +272,6 @@
 		hid-descr-addr = <0x1>;
 
 		interrupts-extended = <&tlmm 37 IRQ_TYPE_LEVEL_HIGH>;
-
-		pinctrl-names = "default";
-		pinctrl-0 = <&i2c3_hid_active>;
 	};
 
 	tsc2: hid@2c {
@@ -281,11 +280,6 @@
 		hid-descr-addr = <0x20>;
 
 		interrupts-extended = <&tlmm 37 IRQ_TYPE_LEVEL_HIGH>;
-
-		pinctrl-names = "default";
-		pinctrl-0 = <&i2c3_hid_active>;
-
-		status = "disabled";
 	};
 };
 
-- 
2.27.0



