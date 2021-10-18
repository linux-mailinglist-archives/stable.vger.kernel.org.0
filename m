Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A31D5431CE5
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233761AbhJRNpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:45:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:39220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234115AbhJRNnu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:43:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FF3A6126A;
        Mon, 18 Oct 2021 13:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564096;
        bh=lB4QadlMJcP/QLGrEF8yrCOEdFe50p2EV3pbD1Krnpk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ale5Ms7nKVuF2G10e7tF5p3O5/oOpPRcFP6/TV4+l1q2qlcs1pYhWMoEIIXERmGFU
         L7OzdvRlM9M9DXTq9i+AQcx6HWQiJkdSOtdyIyAs6VQ+Wksuc40TJvnc5gNm1ba5Yi
         /BaMbL0gf/gWRfEnvv0WiI0XvYJQpMwpqXS4Vkq0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>
Subject: [PATCH 5.10 063/103] ARM: dts: bcm2711-rpi-4-b: Fix usbs unit address
Date:   Mon, 18 Oct 2021 15:24:39 +0200
Message-Id: <20211018132336.870092585@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132334.702559133@linuxfoundation.org>
References: <20211018132334.702559133@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Saenz Julienne <nsaenz@kernel.org>

commit 3f32472854614d6f53b09b4812372dba9fc5c7de upstream.

The unit address is supposed to represent '<device>,<function>'. Which
are both 0 for RPi4b's XHCI controller. On top of that although
OpenFirmware states bus number goes in the high part of the last reg
parameter, FDT doesn't seem to care for it[1], so remove it.

[1] https://patchwork.kernel.org/project/linux-arm-kernel/patch/20210830103909.323356-1-nsaenzju@redhat.com/#24414633
Fixes: 258f92d2f840 ("ARM: dts: bcm2711: Add reset controller to xHCI node")
Suggested-by: Rob Herring <robh@kernel.org>
Reviewed-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20210831125843.1233488-2-nsaenzju@redhat.com
Signed-off-by: Nicolas Saenz Julienne <nsaenz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/bcm2711-rpi-4-b.dts |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/boot/dts/bcm2711-rpi-4-b.dts
+++ b/arch/arm/boot/dts/bcm2711-rpi-4-b.dts
@@ -262,8 +262,8 @@
 
 		reg = <0 0 0 0 0>;
 
-		usb@1,0 {
-			reg = <0x10000 0 0 0 0>;
+		usb@0,0 {
+			reg = <0 0 0 0 0>;
 			resets = <&reset RASPBERRYPI_FIRMWARE_RESET_ID_USB>;
 		};
 	};


