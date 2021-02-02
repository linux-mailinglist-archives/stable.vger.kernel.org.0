Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55A0A30CB7E
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239292AbhBBT0P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:26:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:45052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233568AbhBBN7q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:59:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3DFE64FFA;
        Tue,  2 Feb 2021 13:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273601;
        bh=7scnNFO5hFWcnqyzKqanrtIP8GbkO1wM7n2d5m55wWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RWmTzBlhVZ3npuuL6wgNB1rwMeSqwkLT2wZWdrVZtgpbQTNLQ5zec2dths153oO/W
         50QN93pGt+LgcYV62Dd1EKBhsKiprmK4d7KdQ7YC4kz9T6EVp+p2Dx6nHMaqWtRL37
         4GxKVT5FXGjU3VEUZB6Gu3JusLAJUsxyM9N26nIQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bharat Gooty <bharat.gooty@broadcom.com>,
        Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>, Ray Jui <ray.jui@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 5.4 24/61] arm64: dts: broadcom: Fix USB DMA address translation for Stingray
Date:   Tue,  2 Feb 2021 14:38:02 +0100
Message-Id: <20210202132947.480135137@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132946.480479453@linuxfoundation.org>
References: <20210202132946.480479453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bharat Gooty <bharat.gooty@broadcom.com>

commit da8ee66f56071aef0b5b0de41d2c2a97fa30c8a1 upstream.

Add a non-empty dma-ranges so that DMA address translation happens.

Fixes: 2013a4b684b6 ("arm64: dts: broadcom: clear the warnings caused by empty dma-ranges")
Signed-off-by: Bharat Gooty <bharat.gooty@broadcom.com>
Signed-off-by: Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Ray Jui <ray.jui@broadcom.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/broadcom/stingray/stingray-usb.dtsi |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/broadcom/stingray/stingray-usb.dtsi
+++ b/arch/arm64/boot/dts/broadcom/stingray/stingray-usb.dtsi
@@ -4,11 +4,16 @@
  */
 	usb {
 		compatible = "simple-bus";
-		dma-ranges;
 		#address-cells = <2>;
 		#size-cells = <2>;
 		ranges = <0x0 0x0 0x0 0x68500000 0x0 0x00400000>;
 
+		/*
+		 * Internally, USB bus to the interconnect can only address up
+		 * to 40-bit
+		 */
+		dma-ranges = <0 0 0 0 0x100 0x0>;
+
 		usbphy0: usb-phy@0 {
 			compatible = "brcm,sr-usb-combo-phy";
 			reg = <0x0 0x00000000 0x0 0x100>;


