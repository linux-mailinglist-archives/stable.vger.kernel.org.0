Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18AD3198FC6
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731119AbgCaJGS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:06:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:47602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731116AbgCaJGP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:06:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FC2C20787;
        Tue, 31 Mar 2020 09:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645574;
        bh=WdrpLdSsYq3kQgncJPzNCgTZYn/K/kVhYZKhp/uifWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LSfou71gnQyjgYZD3l8+3f3yK0SQ0ADD8M82qIH4qs94wyPYm9u9xFIY1Y/yjgG56
         74uMRFOVU2c7BVjLzaDoPSU+d0gO1oa84zf26TaqVDSqY9OOjS0V4NKgH/sOsJIN9/
         RnRzoeGZ2y+/cw2OqwyGqWRziBam5MKyYcIsJ1sM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roger Quadros <rogerq@ti.com>,
        stable@kernel.org, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 5.5 095/170] ARM: dts: dra7: Add bus_dma_limit for L3 bus
Date:   Tue, 31 Mar 2020 10:58:29 +0200
Message-Id: <20200331085434.336896278@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
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
@@ -148,6 +148,7 @@
 		#address-cells = <1>;
 		#size-cells = <1>;
 		ranges = <0x0 0x0 0x0 0xc0000000>;
+		dma-ranges = <0x80000000 0x0 0x80000000 0x80000000>;
 		ti,hwmods = "l3_main_1", "l3_main_2";
 		reg = <0x0 0x44000000 0x0 0x1000000>,
 		      <0x0 0x45000000 0x0 0x1000>;


