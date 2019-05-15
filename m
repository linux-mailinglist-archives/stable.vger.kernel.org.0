Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 065381EFE0
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbfEOLiP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:38:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:43048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732882AbfEOLbT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:31:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4817620818;
        Wed, 15 May 2019 11:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919878;
        bh=+q5u+2UcGhkagMxcTbdXzR+8uh8vvl0/OzsgokY/tEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gQGvpb8TCVr5XPXWTijpzePVBJ6R8EklP/eUUH2XopB2sdb+ufxJ2eMSfrj2FBU89
         pND2NQ0Bh6V7kxAkItSJJqJ4kN0IwNnWBOvNIR730WlPO5Dde5FOpQfOawMNOKm68e
         3/LZG1xowehKtvR6OYfdfTJHIwkwTjt8ZbICpesY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 074/137] of_net: Fix residues after of_get_nvmem_mac_address removal
Date:   Wed, 15 May 2019 12:55:55 +0200
Message-Id: <20190515090658.805681603@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 36ad7022536e0c65f8baeeaa5efde11dec44808a ]

I've discovered following discrepancy in the bindings/net/ethernet.txt
documentation, where it states following:

 - nvmem-cells: phandle, reference to an nvmem node for the MAC address;
 - nvmem-cell-names: string, should be "mac-address" if nvmem is to be..

which is actually misleading and confusing. There are only two ethernet
drivers in the tree, cadence/macb and davinci which supports this
properties.

This nvmem-cell* properties were introduced in commit 9217e566bdee
("of_net: Implement of_get_nvmem_mac_address helper"), but
commit afa64a72b862 ("of: net: kill of_get_nvmem_mac_address()")
forget to properly clean up this parts.

So this patch fixes the documentation by moving the nvmem-cell*
properties at the appropriate places.  While at it, I've removed unused
include as well.

Cc: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Fixes: afa64a72b862 ("of: net: kill of_get_nvmem_mac_address()")
Signed-off-by: Petr Štetiar <ynezz@true.cz>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/net/davinci_emac.txt | 2 ++
 Documentation/devicetree/bindings/net/ethernet.txt     | 2 --
 Documentation/devicetree/bindings/net/macb.txt         | 4 ++++
 drivers/of/of_net.c                                    | 1 -
 4 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/davinci_emac.txt b/Documentation/devicetree/bindings/net/davinci_emac.txt
index 24c5cdaba8d27..ca83dcc84fb8e 100644
--- a/Documentation/devicetree/bindings/net/davinci_emac.txt
+++ b/Documentation/devicetree/bindings/net/davinci_emac.txt
@@ -20,6 +20,8 @@ Required properties:
 Optional properties:
 - phy-handle: See ethernet.txt file in the same directory.
               If absent, davinci_emac driver defaults to 100/FULL.
+- nvmem-cells: phandle, reference to an nvmem node for the MAC address
+- nvmem-cell-names: string, should be "mac-address" if nvmem is to be used
 - ti,davinci-rmii-en: 1 byte, 1 means use RMII
 - ti,davinci-no-bd-ram: boolean, does EMAC have BD RAM?
 
diff --git a/Documentation/devicetree/bindings/net/ethernet.txt b/Documentation/devicetree/bindings/net/ethernet.txt
index cfc376bc977aa..2974e63ba311a 100644
--- a/Documentation/devicetree/bindings/net/ethernet.txt
+++ b/Documentation/devicetree/bindings/net/ethernet.txt
@@ -10,8 +10,6 @@ Documentation/devicetree/bindings/phy/phy-bindings.txt.
   the boot program; should be used in cases where the MAC address assigned to
   the device by the boot program is different from the "local-mac-address"
   property;
-- nvmem-cells: phandle, reference to an nvmem node for the MAC address;
-- nvmem-cell-names: string, should be "mac-address" if nvmem is to be used;
 - max-speed: number, specifies maximum speed in Mbit/s supported by the device;
 - max-frame-size: number, maximum transfer unit (IEEE defined MTU), rather than
   the maximum frame size (there's contradiction in the Devicetree
diff --git a/Documentation/devicetree/bindings/net/macb.txt b/Documentation/devicetree/bindings/net/macb.txt
index 3e17ac1d5d58c..1a914116f4c2c 100644
--- a/Documentation/devicetree/bindings/net/macb.txt
+++ b/Documentation/devicetree/bindings/net/macb.txt
@@ -26,6 +26,10 @@ Required properties:
 	Optional elements: 'tsu_clk'
 - clocks: Phandles to input clocks.
 
+Optional properties:
+- nvmem-cells: phandle, reference to an nvmem node for the MAC address
+- nvmem-cell-names: string, should be "mac-address" if nvmem is to be used
+
 Optional properties for PHY child node:
 - reset-gpios : Should specify the gpio for phy reset
 - magic-packet : If present, indicates that the hardware supports waking
diff --git a/drivers/of/of_net.c b/drivers/of/of_net.c
index 810ab0fbcccbf..d820f3edd4311 100644
--- a/drivers/of/of_net.c
+++ b/drivers/of/of_net.c
@@ -7,7 +7,6 @@
  */
 #include <linux/etherdevice.h>
 #include <linux/kernel.h>
-#include <linux/nvmem-consumer.h>
 #include <linux/of_net.h>
 #include <linux/phy.h>
 #include <linux/export.h>
-- 
2.20.1



