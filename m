Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7863431E3C
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234432AbhJRN7T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:59:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:57710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233680AbhJRN5U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:57:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4ECDF61374;
        Mon, 18 Oct 2021 13:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564454;
        bh=fw1p2m2lRNqach1F5s9MyhHFyCNNlPSBlh3+Ml3rJMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XV8RI9xvU90D+iEPnOGcn7bNEU+x9l6QoeptYf74KAHYQ5cysptZ7mx/bLVWTYfE7
         UqnSL0fi2iiAfPal9Wn64ac7by4VtlkOND+QLtA61ikgaGgM83TGJEt13uuUu85hI3
         AnZlSg0xT5sg75DaWR8HXgaX7GD6y2uRSPzVm6iY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>
Subject: [PATCH 5.14 095/151] ARM: dts: bcm2711-rpi-4-b: Fix pcie0s unit address formatting
Date:   Mon, 18 Oct 2021 15:24:34 +0200
Message-Id: <20211018132343.766009909@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Saenz Julienne <nsaenz@kernel.org>

commit 13dbc954b3c9a9de0ad5b7279e8d3b708d31068b upstream.

dtbs_check currently complains that:

arch/arm/boot/dts/bcm2711-rpi-4-b.dts:220.10-231.4: Warning
(pci_device_reg): /scb/pcie@7d500000/pci@1,0: PCI unit address format
error, expected "0,0"

Unsurprisingly pci@0,0 is the right address, as illustrated by its reg
property:

    &pcie0 {
	    pci@0,0 {
		    /*
		     * As defined in the IEEE Std 1275-1994 document,
		     * reg is a five-cell address encoded as (phys.hi
		     * phys.mid phys.lo size.hi size.lo). phys.hi
		     * should contain the device's BDF as 0b00000000
		     * bbbbbbbb dddddfff 00000000. The other cells
		     * should be zero.
		     */
		    reg = <0 0 0 0 0>;
	    };
    };

The device is clearly 0. So fix it.

Also add a missing 'device_type = "pci"'.

Fixes: 258f92d2f840 ("ARM: dts: bcm2711: Add reset controller to xHCI node")
Suggested-by: Rob Herring <robh@kernel.org>
Reviewed-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20210831125843.1233488-1-nsaenzju@redhat.com
Signed-off-by: Nicolas Saenz Julienne <nsaenz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/bcm2711-rpi-4-b.dts |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm/boot/dts/bcm2711-rpi-4-b.dts
+++ b/arch/arm/boot/dts/bcm2711-rpi-4-b.dts
@@ -217,7 +217,8 @@
 };
 
 &pcie0 {
-	pci@1,0 {
+	pci@0,0 {
+		device_type = "pci";
 		#address-cells = <3>;
 		#size-cells = <2>;
 		ranges;


