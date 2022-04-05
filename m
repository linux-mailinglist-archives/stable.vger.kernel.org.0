Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3A074F2D08
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241160AbiDEKbp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239523AbiDEJdj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:33:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 903C24E39B;
        Tue,  5 Apr 2022 02:22:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FAEA61574;
        Tue,  5 Apr 2022 09:22:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38CA9C385A0;
        Tue,  5 Apr 2022 09:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150539;
        bh=8QYO2AMThjA538+hdzVx+um+o/IV7h3ewMsPaWlZaLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jSXFWi9jmFSa00VaoRBJjKpTMmidWsZGJqZQuB3DxJq4HiWji1UbLS8GfhqE2odXE
         vcdruSfBMXxMrQPds/hmjWRkGIElp5LzLKTwBE/ivzOaz/rXNBIcPqkV4uHA+tnnXW
         f1u5jLel2pUTbWIYyrFQPQxuR9dvX5v4Y0FWz5bA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.15 093/913] riscv: dts: canaan: Fix SPI3 bus width
Date:   Tue,  5 Apr 2022 09:19:15 +0200
Message-Id: <20220405070342.616711474@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

commit 6846d656106add3aeefcd6eda0dc885787deaa6e upstream.

According to the K210 Standalone SDK Programming guide:
https://canaan-creative.com/wp-content/uploads/2020/03/kendryte_standalone_programming_guide_20190311144158_en.pdf

Section 15.4.3.3:
SPI0 and SPI1 supports: standard, dual, quad and octal transfers.
SPI3 supports: standard, dual and quad transfers (octal is not supported).

In order to support quad transfers (Quad SPI), SPI3 must have four IO wires
connected to the SPI flash.

Update the device tree to specify the correct bus width.

Tested on maix bit, maix dock and maixduino, which all have the same
SPI flash (gd25lq128d) connected to SPI3. maix go is untested, but it
would not make sense for this k210 board to be designed differently.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Fixes: 8f5b0e79f3e5 ("riscv: Add SiPeed MAIXDUINO board device tree")
Fixes: 8194f08bda18 ("riscv: Add SiPeed MAIX GO board device tree")
Fixes: a40f920964c4 ("riscv: Add SiPeed MAIX DOCK board device tree")
Fixes: 97c279bcf813 ("riscv: Add SiPeed MAIX BiT board device tree")
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/boot/dts/canaan/sipeed_maix_bit.dts  |    2 ++
 arch/riscv/boot/dts/canaan/sipeed_maix_dock.dts |    2 ++
 arch/riscv/boot/dts/canaan/sipeed_maix_go.dts   |    2 ++
 arch/riscv/boot/dts/canaan/sipeed_maixduino.dts |    2 ++
 4 files changed, 8 insertions(+)

--- a/arch/riscv/boot/dts/canaan/sipeed_maix_bit.dts
+++ b/arch/riscv/boot/dts/canaan/sipeed_maix_bit.dts
@@ -203,6 +203,8 @@
 		compatible = "jedec,spi-nor";
 		reg = <0>;
 		spi-max-frequency = <50000000>;
+		spi-tx-bus-width = <4>;
+		spi-rx-bus-width = <4>;
 		m25p,fast-read;
 		broken-flash-reset;
 	};
--- a/arch/riscv/boot/dts/canaan/sipeed_maix_dock.dts
+++ b/arch/riscv/boot/dts/canaan/sipeed_maix_dock.dts
@@ -205,6 +205,8 @@
 		compatible = "jedec,spi-nor";
 		reg = <0>;
 		spi-max-frequency = <50000000>;
+		spi-tx-bus-width = <4>;
+		spi-rx-bus-width = <4>;
 		m25p,fast-read;
 		broken-flash-reset;
 	};
--- a/arch/riscv/boot/dts/canaan/sipeed_maix_go.dts
+++ b/arch/riscv/boot/dts/canaan/sipeed_maix_go.dts
@@ -213,6 +213,8 @@
 		compatible = "jedec,spi-nor";
 		reg = <0>;
 		spi-max-frequency = <50000000>;
+		spi-tx-bus-width = <4>;
+		spi-rx-bus-width = <4>;
 		m25p,fast-read;
 		broken-flash-reset;
 	};
--- a/arch/riscv/boot/dts/canaan/sipeed_maixduino.dts
+++ b/arch/riscv/boot/dts/canaan/sipeed_maixduino.dts
@@ -178,6 +178,8 @@
 		compatible = "jedec,spi-nor";
 		reg = <0>;
 		spi-max-frequency = <50000000>;
+		spi-tx-bus-width = <4>;
+		spi-rx-bus-width = <4>;
 		m25p,fast-read;
 		broken-flash-reset;
 	};


