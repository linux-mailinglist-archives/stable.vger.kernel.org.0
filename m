Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 799C44D846E
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241259AbiCNMYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243886AbiCNMVV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:21:21 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 487662BD8;
        Mon, 14 Mar 2022 05:17:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 96C74CE1232;
        Mon, 14 Mar 2022 12:17:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 514B1C340E9;
        Mon, 14 Mar 2022 12:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647260253;
        bh=xlF0zVmafoR0uanVI4UamdWKtIxsBLEAJoBaZ0jV1NM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mwrvnNvS3tdSZE8PFZm+Ucuv/5uqI/rzqyysTcKBcL/vVVHQHqh1AVz7hONtM1nsJ
         TfnK1y5MpX6bTsTGZpnxbEwPqZmMn2VBE45yMYFvwu61GYNmo9tW0hVMMZydAAeqIo
         0Ha/EZQ8JH9T3zLEdhgyUs7b7/sQHUnM8J0y4KHU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Gregory CLEMENT <gregory.clement@bootlin.com>
Subject: [PATCH 5.16 097/121] arm64: dts: marvell: armada-37xx: Remap IO space to bus address 0x0
Date:   Mon, 14 Mar 2022 12:54:40 +0100
Message-Id: <20220314112746.819939643@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
References: <20220314112744.120491875@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit a1cc1697bb56cdf880ad4d17b79a39ef2c294bc9 upstream.

Legacy and old PCI I/O based cards do not support 32-bit I/O addressing.

Since commit 64f160e19e92 ("PCI: aardvark: Configure PCIe resources from
'ranges' DT property") kernel can set different PCIe address on CPU and
different on the bus for the one A37xx address mapping without any firmware
support in case the bus address does not conflict with other A37xx mapping.

So remap I/O space to the bus address 0x0 to enable support for old legacy
I/O port based cards which have hardcoded I/O ports in low address space.

Note that DDR on A37xx is mapped to bus address 0x0. And mapping of I/O
space can be set to address 0x0 too because MEM space and I/O space are
separate and so do not conflict.

Remapping IO space on Turris Mox to different address is not possible to
due bootloader bug.

Signed-off-by: Pali Rohár <pali@kernel.org>
Reported-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 76f6386b25cc ("arm64: dts: marvell: Add Aardvark PCIe support for Armada 3700")
Cc: stable@vger.kernel.org # 64f160e19e92 ("PCI: aardvark: Configure PCIe resources from 'ranges' DT property")
Cc: stable@vger.kernel.org # 514ef1e62d65 ("arm64: dts: marvell: armada-37xx: Extend PCIe MEM space")
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts |    7 ++++++-
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi           |    2 +-
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
+++ b/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
@@ -139,7 +139,9 @@
 	/*
 	 * U-Boot port for Turris Mox has a bug which always expects that "ranges" DT property
 	 * contains exactly 2 ranges with 3 (child) address cells, 2 (parent) address cells and
-	 * 2 size cells and also expects that the second range starts at 16 MB offset. If these
+	 * 2 size cells and also expects that the second range starts at 16 MB offset. Also it
+	 * expects that first range uses same address for PCI (child) and CPU (parent) cells (so
+	 * no remapping) and that this address is the lowest from all specified ranges. If these
 	 * conditions are not met then U-Boot crashes during loading kernel DTB file. PCIe address
 	 * space is 128 MB long, so the best split between MEM and IO is to use fixed 16 MB window
 	 * for IO and the rest 112 MB (64+32+16) for MEM, despite that maximal IO size is just 64 kB.
@@ -148,6 +150,9 @@
 	 * https://source.denx.de/u-boot/u-boot/-/commit/cb2ddb291ee6fcbddd6d8f4ff49089dfe580f5d7
 	 * https://source.denx.de/u-boot/u-boot/-/commit/c64ac3b3185aeb3846297ad7391fc6df8ecd73bf
 	 * https://source.denx.de/u-boot/u-boot/-/commit/4a82fca8e330157081fc132a591ebd99ba02ee33
+	 * Bug related to requirement of same child and parent addresses for first range is fixed
+	 * in U-Boot version 2022.04 by following commit:
+	 * https://source.denx.de/u-boot/u-boot/-/commit/1fd54253bca7d43d046bba4853fe5fafd034bc17
 	 */
 	#address-cells = <3>;
 	#size-cells = <2>;
--- a/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
@@ -497,7 +497,7 @@
 			 * (totaling 127 MiB) for MEM.
 			 */
 			ranges = <0x82000000 0 0xe8000000   0 0xe8000000   0 0x07f00000   /* Port 0 MEM */
-				  0x81000000 0 0xefff0000   0 0xefff0000   0 0x00010000>; /* Port 0 IO */
+				  0x81000000 0 0x00000000   0 0xefff0000   0 0x00010000>; /* Port 0 IO */
 			interrupt-map-mask = <0 0 0 7>;
 			interrupt-map = <0 0 0 1 &pcie_intc 0>,
 					<0 0 0 2 &pcie_intc 1>,


