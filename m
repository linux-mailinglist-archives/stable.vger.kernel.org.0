Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E24C2A6FA6
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729945AbfICQeG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:34:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730579AbfICQ2L (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:28:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6D7E23431;
        Tue,  3 Sep 2019 16:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528090;
        bh=9xraFWTC4EFet416Uuj5naJumUJUI0SHxebwt0sagf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XYyuxzy65qrT+3N7SetOtEeML3901VTCUaMQKdU0qizPiH2cTNHjBftd3nJY5to9u
         lflUnUZM91wdJSf8+ChzshdACVM2i8hx3NvVLiVWVYgbYXR+pL7TIYkmVebTzBiuiH
         mv1FdhQif1JcOaX+mF0+mcUB454ZkiHg91OHpEpg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christian Lamparter <chunkeey@gmail.com>,
        David Bauer <mail@david-bauer.net>,
        Andy Gross <agross@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 100/167] ARM: dts: qcom: ipq4019: enlarge PCIe BAR range
Date:   Tue,  3 Sep 2019 12:24:12 -0400
Message-Id: <20190903162519.7136-100-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Lamparter <chunkeey@gmail.com>

[ Upstream commit f3e35357cd460a8aeb48b8113dc4b761a7d5c828 ]

David Bauer reported that the VDSL modem (attached via PCIe)
on his AVM Fritz!Box 7530 was complaining about not having
enough space in the BAR. A closer inspection of the old
qcom-ipq40xx.dtsi pulled from the GL-iNet repository listed:

| qcom,pcie@80000 {
|	compatible = "qcom,msm_pcie";
|	reg = <0x80000 0x2000>,
|	      <0x99000 0x800>,
|	      <0x40000000 0xf1d>,
|	      <0x40000f20 0xa8>,
|	      <0x40100000 0x1000>,
|	      <0x40200000 0x100000>,
|	      <0x40300000 0xd00000>;
|	reg-names = "parf", "phy", "dm_core", "elbi",
|			"conf", "io", "bars";

Matching the reg-names with the listed reg leads to
<0xd00000> as the size for the "bars".

Cc: stable@vger.kernel.org
BugLink: https://www.mail-archive.com/openwrt-devel@lists.openwrt.org/msg45212.html
Reported-by: David Bauer <mail@david-bauer.net>
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: Andy Gross <agross@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-ipq4019.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-ipq4019.dtsi b/arch/arm/boot/dts/qcom-ipq4019.dtsi
index 814ab7283228a..54d056b01bb51 100644
--- a/arch/arm/boot/dts/qcom-ipq4019.dtsi
+++ b/arch/arm/boot/dts/qcom-ipq4019.dtsi
@@ -386,8 +386,8 @@
 			#address-cells = <3>;
 			#size-cells = <2>;
 
-			ranges = <0x81000000 0 0x40200000 0x40200000 0 0x00100000
-				  0x82000000 0 0x40300000 0x40300000 0 0x400000>;
+			ranges = <0x81000000 0 0x40200000 0x40200000 0 0x00100000>,
+				 <0x82000000 0 0x40300000 0x40300000 0 0x00d00000>;
 
 			interrupts = <GIC_SPI 141 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "msi";
-- 
2.20.1

