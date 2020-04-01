Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4A819B3F9
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388225AbgDAQ3z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:29:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:55656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388221AbgDAQ3y (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:29:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E33A1212CC;
        Wed,  1 Apr 2020 16:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758594;
        bh=gjhoOloQBD59gFMnNazCDCwzPSf+vl9lMqmIUM7SoHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CILycLgj7Pnq2cXOwiiP1eWi3M/wElQ1Ov751aq2styMQmhvpwQm2GWxfqpUlTm1t
         9K4IcTIrYKHtBeCDvvkRpOhG40eSxiA6fgAwxFOjM9YuOMywqDKZRDXfRdpBWCARiq
         +hHKHqHA7hFbdvbwnX7xMOcTUtF9S0Dc8DwLn3q8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 03/91] ARM: dts: dra7: Add "dma-ranges" property to PCIe RC DT nodes
Date:   Wed,  1 Apr 2020 18:16:59 +0200
Message-Id: <20200401161513.966878867@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161512.917494101@linuxfoundation.org>
References: <20200401161512.917494101@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kishon Vijay Abraham I <kishon@ti.com>

[ Upstream commit 27f13774654ea6bd0b6fc9b97cce8d19e5735661 ]

'dma-ranges' in a PCI bridge node does correctly set dma masks for PCI
devices not described in the DT. Certain DRA7 platforms (e.g., DRA76)
has RAM above 32-bit boundary (accessible with LPAE config) though the
PCIe bridge will be able to access only 32-bits. Add 'dma-ranges'
property in PCIe RC DT nodes to indicate the host bridge can access
only 32 bits.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/dra7.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index e6a3a94bac693..2cdaa38c114e8 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -227,6 +227,7 @@
 				device_type = "pci";
 				ranges = <0x81000000 0 0          0x03000 0 0x00010000
 					  0x82000000 0 0x20013000 0x13000 0 0xffed000>;
+				dma-ranges = <0x02000000 0x0 0x00000000 0x00000000 0x1 0x00000000>;
 				bus-range = <0x00 0xff>;
 				#interrupt-cells = <1>;
 				num-lanes = <1>;
@@ -263,6 +264,7 @@
 				device_type = "pci";
 				ranges = <0x81000000 0 0          0x03000 0 0x00010000
 					  0x82000000 0 0x30013000 0x13000 0 0xffed000>;
+				dma-ranges = <0x02000000 0x0 0x00000000 0x00000000 0x1 0x00000000>;
 				bus-range = <0x00 0xff>;
 				#interrupt-cells = <1>;
 				num-lanes = <1>;
-- 
2.20.1



