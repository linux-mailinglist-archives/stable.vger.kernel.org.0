Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4D319AFBE
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732274AbgDAQUn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:20:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:43414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733049AbgDAQUm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:20:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FBDC212CC;
        Wed,  1 Apr 2020 16:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758041;
        bh=jNN9E+/xTRenIWG5q3qeSRkAywZsGhFOXEpfGwyhp48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NK40FgUlrI0+6oXc5+NsXuCfvHEGDXtjZudjACah+kh2J0GXoZWSyxVnzUS/NW+xs
         FKCwGXMAItHgJHU7AQQC311Pr6EapaXqZgJ/r8K9oC6RSY4PRGQAfPWlo2L+OxwbF1
         tYJ6O2t2G1IiahN65lTPp6mz6IA0cgcTDKyg6gL0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 5.5 24/30] ARM: dts: bcm283x: Fix vc4s firmware bus DMA limitations
Date:   Wed,  1 Apr 2020 18:17:28 +0200
Message-Id: <20200401161433.172997371@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161414.345528747@linuxfoundation.org>
References: <20200401161414.345528747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>

commit 55c7c0621078bd73e9d4d2a11eb36e61bc6fe998 upstream.

The bus is virtual and devices have to inherit their DMA constraints
from the underlying interconnect. So add an empty dma-ranges property to
the bus node, implying the firmware bus' DMA constraints are identical to
its parent's.

Fixes: 7dbe8c62ceeb ("ARM: dts: Add minimal Raspberry Pi 4 support")
Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/bcm2835-rpi.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/boot/dts/bcm2835-rpi.dtsi
+++ b/arch/arm/boot/dts/bcm2835-rpi.dtsi
@@ -15,6 +15,7 @@
 		firmware: firmware {
 			compatible = "raspberrypi,bcm2835-firmware", "simple-bus";
 			mboxes = <&mailbox>;
+			dma-ranges;
 		};
 
 		power: power {


