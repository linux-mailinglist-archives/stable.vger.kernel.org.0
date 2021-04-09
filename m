Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 283A735A6F9
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 21:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234955AbhDITWE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 15:22:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:42954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234869AbhDITWD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 15:22:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9465C61006;
        Fri,  9 Apr 2021 19:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617996110;
        bh=ju0bAWBhmE3CRmY8aKQfqsVXrmyQolpU0rEBF3/xxN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M14eC3U+zuEODIEmQkroyYfXzyVqz5Kjs36nEXADi4phxtX+dpGLctHvpSn0uvILF
         2fg/QlYfk5GdorKJpZlndL3obFlDwhipATk1PxG2IuVDenfZr+jHzWDJcO1gpJbxOB
         seCtVeIDTZ1Pcjqe31Z2+nCxjZWbF4T4HnE4ct3RJTmaEmxC2tB57S18EywBPyh+EZ
         Pb+oMXYmZi2M8c80g8pOv982/VIPgQCj8UM75bdyhUzkbHb1t7+/ioLJR5kRxTp+Ri
         VKNT378fTSrgRPVnomfRNOk1FxbzWorXkh+n0FN+CHOfRLuu3dTd9eaY5p/rv1WTor
         k7t96DsI7WfHQ==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Paul Burton <paulburton@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     Tom Rini <trini@konsulko.com>, Simon Glass <sjg@chromium.org>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] MIPS: generic: Update node names to avoid unit addresses
Date:   Fri,  9 Apr 2021 12:21:28 -0700
Message-Id: <20210409192128.3998606-1-nathan@kernel.org>
X-Mailer: git-send-email 2.31.1.189.g2e36527f23
In-Reply-To: <20210409174734.GJ1310@bill-the-cat>
References: <20210409174734.GJ1310@bill-the-cat>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 arch/mips/generic/board-boston.its.S   | 10 +++++-----
 arch/mips/generic/board-jaguar2.its.S  | 16 ++++++++--------
 arch/mips/generic/board-luton.its.S    |  8 ++++----
 arch/mips/generic/board-ni169445.its.S | 10 +++++-----
 arch/mips/generic/board-ocelot.its.S   | 20 ++++++++++----------
 arch/mips/generic/board-serval.its.S   |  8 ++++----
 arch/mips/generic/board-xilfpga.its.S  | 10 +++++-----
 arch/mips/generic/vmlinux.its.S        | 10 +++++-----
 8 files changed, 46 insertions(+), 46 deletions(-)

diff --git a/arch/mips/generic/board-boston.its.S b/arch/mips/generic/board-boston.its.S
index a7f51f97b910..c45ad2759421 100644
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
diff --git a/arch/mips/generic/board-jaguar2.its.S b/arch/mips/generic/board-jaguar2.its.S
index fb0e589eeff7..c2b8d479b26c 100644
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
diff --git a/arch/mips/generic/board-luton.its.S b/arch/mips/generic/board-luton.its.S
index 39a543f62f25..bd9837c9af97 100644
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
diff --git a/arch/mips/generic/board-ni169445.its.S b/arch/mips/generic/board-ni169445.its.S
index e4cb4f95a8cc..0a2e8f7a8526 100644
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
diff --git a/arch/mips/generic/board-ocelot.its.S b/arch/mips/generic/board-ocelot.its.S
index 3da23988149a..8c7e3a1b68d3 100644
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
diff --git a/arch/mips/generic/board-serval.its.S b/arch/mips/generic/board-serval.its.S
index 4ea4fc9d757f..dde833efe980 100644
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
diff --git a/arch/mips/generic/board-xilfpga.its.S b/arch/mips/generic/board-xilfpga.its.S
index a2e773d3f14f..08c1e900eb4e 100644
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
diff --git a/arch/mips/generic/vmlinux.its.S b/arch/mips/generic/vmlinux.its.S
index 1a08438fd893..3e254676540f 100644
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

base-commit: e86e75596623e1ce5d784db8214687326712a8ae
-- 
2.31.1.189.g2e36527f23

