Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3FDF37C6FB
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232442AbhELP5q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:57:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:52454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234742AbhELPwA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:52:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DDF561002;
        Wed, 12 May 2021 15:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833193;
        bh=xlr6No9EynWlM+08214/2W/+/KIMEuwYL4Sst2qRByU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ksQghsjLc1kaBujqhSdi1iDiiDdGtntJhQJ5rfuLwocwr+zK8WV3gMjJuKi5632h2
         Z805uNeJWXQdvSVP3dGg3x8SZ5Zdyb/0vUCyMZanAc2dkcQMxc1cPJQTnaNWyMzJls
         ZYPxEw/PJDipX9KNBejXQnAGAyqsYCajHcCVtw4M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simon Glass <sjg@chromium.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Tom Rini <trini@konsulko.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.11 055/601] MIPS: generic: Update node names to avoid unit addresses
Date:   Wed, 12 May 2021 16:42:12 +0200
Message-Id: <20210512144829.622807698@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

commit e607ff630c6053ecc67502677c0e50053d7892d4 upstream.

With the latest mkimage from U-Boot 2021.04, the generic defconfigs no
longer build, failing with:

/usr/bin/mkimage: verify_header failed for FIT Image support with exit code 1

This is expected after the linked U-Boot commits because '@' is
forbidden in the node names due to the way that libfdt treats nodes with
the same prefix but different unit addresses.

Switch the '@' in the node name to '-'. Drop the unit addresses from the
hash and kernel child nodes because there is only one node so they do
not need to have a number to differentiate them.

Cc: stable@vger.kernel.org
Link: https://source.denx.de/u-boot/u-boot/-/commit/79af75f7776fc20b0d7eb6afe1e27c00fdb4b9b4
Link: https://source.denx.de/u-boot/u-boot/-/commit/3f04db891a353f4b127ed57279279f851c6b4917
Suggested-by: Simon Glass <sjg@chromium.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Tom Rini <trini@konsulko.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/generic/board-boston.its.S   |   10 +++++-----
 arch/mips/generic/board-jaguar2.its.S  |   16 ++++++++--------
 arch/mips/generic/board-luton.its.S    |    8 ++++----
 arch/mips/generic/board-ni169445.its.S |   10 +++++-----
 arch/mips/generic/board-ocelot.its.S   |   20 ++++++++++----------
 arch/mips/generic/board-serval.its.S   |    8 ++++----
 arch/mips/generic/board-xilfpga.its.S  |   10 +++++-----
 arch/mips/generic/vmlinux.its.S        |   10 +++++-----
 8 files changed, 46 insertions(+), 46 deletions(-)

--- a/arch/mips/generic/board-boston.its.S
+++ b/arch/mips/generic/board-boston.its.S
@@ -1,22 +1,22 @@
 / {
 	images {
-		fdt@boston {
+		fdt-boston {
 			description = "img,boston Device Tree";
 			data = /incbin/("boot/dts/img/boston.dtb");
 			type = "flat_dt";
 			arch = "mips";
 			compression = "none";
-			hash@0 {
+			hash {
 				algo = "sha1";
 			};
 		};
 	};
 
 	configurations {
-		conf@boston {
+		conf-boston {
 			description = "Boston Linux kernel";
-			kernel = "kernel@0";
-			fdt = "fdt@boston";
+			kernel = "kernel";
+			fdt = "fdt-boston";
 		};
 	};
 };
--- a/arch/mips/generic/board-jaguar2.its.S
+++ b/arch/mips/generic/board-jaguar2.its.S
@@ -1,23 +1,23 @@
 /* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
 / {
 	images {
-		fdt@jaguar2_pcb110 {
+		fdt-jaguar2_pcb110 {
 			description = "MSCC Jaguar2 PCB110 Device Tree";
 			data = /incbin/("boot/dts/mscc/jaguar2_pcb110.dtb");
 			type = "flat_dt";
 			arch = "mips";
 			compression = "none";
-			hash@0 {
+			hash {
 				algo = "sha1";
 			};
 		};
-		fdt@jaguar2_pcb111 {
+		fdt-jaguar2_pcb111 {
 			description = "MSCC Jaguar2 PCB111 Device Tree";
 			data = /incbin/("boot/dts/mscc/jaguar2_pcb111.dtb");
 			type = "flat_dt";
 			arch = "mips";
 			compression = "none";
-			hash@0 {
+			hash {
 				algo = "sha1";
 			};
 		};
@@ -26,14 +26,14 @@
 	configurations {
 		pcb110 {
 			description = "Jaguar2 Linux kernel";
-			kernel = "kernel@0";
-			fdt = "fdt@jaguar2_pcb110";
+			kernel = "kernel";
+			fdt = "fdt-jaguar2_pcb110";
 			ramdisk = "ramdisk";
 		};
 		pcb111 {
 			description = "Jaguar2 Linux kernel";
-			kernel = "kernel@0";
-			fdt = "fdt@jaguar2_pcb111";
+			kernel = "kernel";
+			fdt = "fdt-jaguar2_pcb111";
 			ramdisk = "ramdisk";
 		};
 	};
--- a/arch/mips/generic/board-luton.its.S
+++ b/arch/mips/generic/board-luton.its.S
@@ -1,13 +1,13 @@
 /* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
 / {
 	images {
-		fdt@luton_pcb091 {
+		fdt-luton_pcb091 {
 			description = "MSCC Luton PCB091 Device Tree";
 			data = /incbin/("boot/dts/mscc/luton_pcb091.dtb");
 			type = "flat_dt";
 			arch = "mips";
 			compression = "none";
-			hash@0 {
+			hash {
 				algo = "sha1";
 			};
 		};
@@ -16,8 +16,8 @@
 	configurations {
 		pcb091 {
 			description = "Luton Linux kernel";
-			kernel = "kernel@0";
-			fdt = "fdt@luton_pcb091";
+			kernel = "kernel";
+			fdt = "fdt-luton_pcb091";
 		};
 	};
 };
--- a/arch/mips/generic/board-ni169445.its.S
+++ b/arch/mips/generic/board-ni169445.its.S
@@ -1,22 +1,22 @@
 / {
 	images {
-		fdt@ni169445 {
+		fdt-ni169445 {
 			description = "NI 169445 device tree";
 			data = /incbin/("boot/dts/ni/169445.dtb");
 			type = "flat_dt";
 			arch = "mips";
 			compression = "none";
-			hash@0 {
+			hash {
 				algo = "sha1";
 			};
 		};
 	};
 
 	configurations {
-		conf@ni169445 {
+		conf-ni169445 {
 			description = "NI 169445 Linux Kernel";
-			kernel = "kernel@0";
-			fdt = "fdt@ni169445";
+			kernel = "kernel";
+			fdt = "fdt-ni169445";
 		};
 	};
 };
--- a/arch/mips/generic/board-ocelot.its.S
+++ b/arch/mips/generic/board-ocelot.its.S
@@ -1,40 +1,40 @@
 /* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
 / {
 	images {
-		fdt@ocelot_pcb123 {
+		fdt-ocelot_pcb123 {
 			description = "MSCC Ocelot PCB123 Device Tree";
 			data = /incbin/("boot/dts/mscc/ocelot_pcb123.dtb");
 			type = "flat_dt";
 			arch = "mips";
 			compression = "none";
-			hash@0 {
+			hash {
 				algo = "sha1";
 			};
 		};
 
-		fdt@ocelot_pcb120 {
+		fdt-ocelot_pcb120 {
 			description = "MSCC Ocelot PCB120 Device Tree";
 			data = /incbin/("boot/dts/mscc/ocelot_pcb120.dtb");
 			type = "flat_dt";
 			arch = "mips";
 			compression = "none";
-			hash@0 {
+			hash {
 				algo = "sha1";
 			};
 		};
 	};
 
 	configurations {
-		conf@ocelot_pcb123 {
+		conf-ocelot_pcb123 {
 			description = "Ocelot Linux kernel";
-			kernel = "kernel@0";
-			fdt = "fdt@ocelot_pcb123";
+			kernel = "kernel";
+			fdt = "fdt-ocelot_pcb123";
 		};
 
-		conf@ocelot_pcb120 {
+		conf-ocelot_pcb120 {
 			description = "Ocelot Linux kernel";
-			kernel = "kernel@0";
-			fdt = "fdt@ocelot_pcb120";
+			kernel = "kernel";
+			fdt = "fdt-ocelot_pcb120";
 		};
 	};
 };
--- a/arch/mips/generic/board-serval.its.S
+++ b/arch/mips/generic/board-serval.its.S
@@ -1,13 +1,13 @@
 /* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
 / {
 	images {
-		fdt@serval_pcb105 {
+		fdt-serval_pcb105 {
 			description = "MSCC Serval PCB105 Device Tree";
 			data = /incbin/("boot/dts/mscc/serval_pcb105.dtb");
 			type = "flat_dt";
 			arch = "mips";
 			compression = "none";
-			hash@0 {
+			hash {
 				algo = "sha1";
 			};
 		};
@@ -16,8 +16,8 @@
 	configurations {
 		pcb105 {
 			description = "Serval Linux kernel";
-			kernel = "kernel@0";
-			fdt = "fdt@serval_pcb105";
+			kernel = "kernel";
+			fdt = "fdt-serval_pcb105";
 			ramdisk = "ramdisk";
 		};
 	};
--- a/arch/mips/generic/board-xilfpga.its.S
+++ b/arch/mips/generic/board-xilfpga.its.S
@@ -1,22 +1,22 @@
 / {
 	images {
-		fdt@xilfpga {
+		fdt-xilfpga {
 			description = "MIPSfpga (xilfpga) Device Tree";
 			data = /incbin/("boot/dts/xilfpga/nexys4ddr.dtb");
 			type = "flat_dt";
 			arch = "mips";
 			compression = "none";
-			hash@0 {
+			hash {
 				algo = "sha1";
 			};
 		};
 	};
 
 	configurations {
-		conf@xilfpga {
+		conf-xilfpga {
 			description = "MIPSfpga Linux kernel";
-			kernel = "kernel@0";
-			fdt = "fdt@xilfpga";
+			kernel = "kernel";
+			fdt = "fdt-xilfpga";
 		};
 	};
 };
--- a/arch/mips/generic/vmlinux.its.S
+++ b/arch/mips/generic/vmlinux.its.S
@@ -6,7 +6,7 @@
 	#address-cells = <ADDR_CELLS>;
 
 	images {
-		kernel@0 {
+		kernel {
 			description = KERNEL_NAME;
 			data = /incbin/(VMLINUX_BINARY);
 			type = "kernel";
@@ -15,18 +15,18 @@
 			compression = VMLINUX_COMPRESSION;
 			load = /bits/ ADDR_BITS <VMLINUX_LOAD_ADDRESS>;
 			entry = /bits/ ADDR_BITS <VMLINUX_ENTRY_ADDRESS>;
-			hash@0 {
+			hash {
 				algo = "sha1";
 			};
 		};
 	};
 
 	configurations {
-		default = "conf@default";
+		default = "conf-default";
 
-		conf@default {
+		conf-default {
 			description = "Generic Linux kernel";
-			kernel = "kernel@0";
+			kernel = "kernel";
 		};
 	};
 };


