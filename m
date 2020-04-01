Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 898A119B3E2
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387534AbgDAQZR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:25:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:49188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733256AbgDAQZQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:25:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9259D20857;
        Wed,  1 Apr 2020 16:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758315;
        bh=dw8o3de5BvGd20KO6Bg+M2/INwwpY8uUjvmGB7rPYEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sZOQ+RHQUq5N2jJ0IOaq/eS4Q2PvMSZWwV3JdVqDdlTZkffi7FKXp5ayj6yvFjO9J
         1rKNVtGaXYXq73gvE6yxSDxH/siiW9N8OjDIIAxGBpCf0QA7sTop8Vsv3r/MZZfoa6
         XCZiQsxg/IL9kTWNXYcB94hy25LN06LxqG6gjfMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roger Quadros <rogerq@ti.com>,
        stable@kernel.org, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 4.19 052/116] ARM: dts: dra7: Add bus_dma_limit for L3 bus
Date:   Wed,  1 Apr 2020 18:17:08 +0200
Message-Id: <20200401161549.237099317@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161542.669484650@linuxfoundation.org>
References: <20200401161542.669484650@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roger Quadros <rogerq@ti.com>

commit cfb5d65f25959f724081bae8445a0241db606af6 upstream.

The L3 interconnect's memory map is from 0x0 to
0xffffffff. Out of this, System memory (SDRAM) can be
accessed from 0x80000000 to 0xffffffff (2GB)

DRA7 does support 4GB of SDRAM but upper 2GB can only be
accessed by the MPU subsystem.

Add the dma-ranges property to reflect the physical address limit
of the L3 bus.

Issues ere observed only with SATA on DRA7-EVM with 4GB RAM
and CONFIG_ARM_LPAE enabled. This is because the controller
supports 64-bit DMA and its driver sets the dma_mask to 64-bit
thus resulting in DMA accesses beyond L3 limit of 2G.

Setting the correct bus_dma_limit fixes the issue.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Cc: stable@kernel.org
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/dra7.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -150,6 +150,7 @@
 		#address-cells = <1>;
 		#size-cells = <1>;
 		ranges = <0x0 0x0 0x0 0xc0000000>;
+		dma-ranges = <0x80000000 0x0 0x80000000 0x80000000>;
 		ti,hwmods = "l3_main_1", "l3_main_2";
 		reg = <0x0 0x44000000 0x0 0x1000000>,
 		      <0x0 0x45000000 0x0 0x1000>;


