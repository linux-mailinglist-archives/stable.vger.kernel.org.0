Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1FA19B18B
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388784AbgDAQf4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:35:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:34770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388795AbgDAQf4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:35:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A55220857;
        Wed,  1 Apr 2020 16:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758955;
        bh=Dxdis/KJKogw06PdKI7YE6I+j6JbrgSMNU1dghE2T48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MTJbRmISy47bfK4xp6NBU4z6Tr0KkFwJ82zrrWv6Td0Rjrdf+0rlHgW8iXvkxg6dm
         RFAkVUrhQwOcs1Ts8SCaRKP1QlqaixtuMOgI3/3cv5vJMB1qHZLIwDjQmLGzxQ3XDa
         DOAn/eSH53tsEeYXjWyGiM06wq4YXvQC9jXqaY5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 003/102] ARM: dts: dra7: Add "dma-ranges" property to PCIe RC DT nodes
Date:   Wed,  1 Apr 2020 18:17:06 +0200
Message-Id: <20200401161532.006689044@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161530.451355388@linuxfoundation.org>
References: <20200401161530.451355388@linuxfoundation.org>
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
index a1a928064b53d..f94064c687789 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -282,6 +282,7 @@
 				device_type = "pci";
 				ranges = <0x81000000 0 0          0x03000 0 0x00010000
 					  0x82000000 0 0x20013000 0x13000 0 0xffed000>;
+				dma-ranges = <0x02000000 0x0 0x00000000 0x00000000 0x1 0x00000000>;
 				bus-range = <0x00 0xff>;
 				#interrupt-cells = <1>;
 				num-lanes = <1>;
@@ -319,6 +320,7 @@
 				device_type = "pci";
 				ranges = <0x81000000 0 0          0x03000 0 0x00010000
 					  0x82000000 0 0x30013000 0x13000 0 0xffed000>;
+				dma-ranges = <0x02000000 0x0 0x00000000 0x00000000 0x1 0x00000000>;
 				bus-range = <0x00 0xff>;
 				#interrupt-cells = <1>;
 				num-lanes = <1>;
-- 
2.20.1



