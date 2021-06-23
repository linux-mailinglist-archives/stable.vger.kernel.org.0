Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8EC3B219F
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 22:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbhFWUPZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 16:15:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:34354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229523AbhFWUPY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Jun 2021 16:15:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1659E611AC;
        Wed, 23 Jun 2021 20:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624479187;
        bh=/WFlssmopgz9lil7Q1LU3vnigt3BFwiFYGgja/W6AMk=;
        h=Date:From:To:Cc:Subject:From;
        b=XNlBQc1DbjKAFRgapRw1Ieiq6HFTxjVDI+L+ig42leGJ295Qii0oaxhG+VOhZVKFY
         ODLSdpZFRpa43AkV7f03fYPENsiUHnPVkA2r6FDwzDeHjCiEYFIf8HChL1ihqYr0F8
         kdr8pnsrQ5eTPyBvWmqYoGsx3AM4pMzIJQzEDJ9dTIAkTI4OP7uunm+4hlBuFtMw2G
         0hDWK6OpVBpotIdhrYwr9zdA1sBQzXTYic9ERzK7LP7IsB6UG1jA0Pj40/YL0dK5+q
         Vj7JJApw11pJfczuQPJcc9wHeUv1/TWGc2XgYHc0UOLhdbVHtqiegwRK+K96oesOCK
         L7SF+VuzFNjlA==
Date:   Wed, 23 Jun 2021 13:13:02 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org
Subject: Backport of e607ff630c60 for 4.14 to 5.10
Message-ID: <YNOVzjEBTwiuB8I4@archlinux-ax161>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="xn2IQHji/c7YufOA"
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--xn2IQHji/c7YufOA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg and Sasha,

Please find attached backports for commit e607ff630c60 ("MIPS: generic:
Update node names to avoid unit addresses"). It has already been applied
to 5.12 but it is missing from all other branches that need it. Let me
know if there are any issues with applying it.

Cheers,
Nathan

--xn2IQHji/c7YufOA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="e607ff630c60-4.14.patch"

From 81524b2326bd0dbcfb304ad0cc2cadd2be6b6865 Mon Sep 17 00:00:00 2001
From: Nathan Chancellor <nathan@kernel.org>
Date: Fri, 9 Apr 2021 12:21:28 -0700
Subject: [PATCH 4.14] MIPS: generic: Update node names to avoid unit addresses

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
[nathan: Backport to 4.14, only apply to .its.S files that exist]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/mips/generic/board-boston.its.S   | 10 +++++-----
 arch/mips/generic/board-ni169445.its.S | 10 +++++-----
 arch/mips/generic/vmlinux.its.S        | 10 +++++-----
 3 files changed, 15 insertions(+), 15 deletions(-)

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

base-commit: cfb41ef9deb1e6572ac218ddfcec9567e5d1c101
-- 
2.32.0.93.g670b81a890


--xn2IQHji/c7YufOA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="e607ff630c60-4.19.patch"

From 4c2081d41fa678c14927fa32379661b544712ff2 Mon Sep 17 00:00:00 2001
From: Nathan Chancellor <nathan@kernel.org>
Date: Fri, 9 Apr 2021 12:21:28 -0700
Subject: [PATCH 4.19] MIPS: generic: Update node names to avoid unit addresses

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
[nathan: Backport to 4.19, only apply to .its.S files that exist]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/mips/generic/board-boston.its.S   | 10 +++++-----
 arch/mips/generic/board-ni169445.its.S | 10 +++++-----
 arch/mips/generic/board-xilfpga.its.S  | 10 +++++-----
 arch/mips/generic/vmlinux.its.S        | 10 +++++-----
 4 files changed, 20 insertions(+), 20 deletions(-)

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

base-commit: eb575cd5d7f60241d016fdd13a9e86d962093c9b
-- 
2.32.0.93.g670b81a890


--xn2IQHji/c7YufOA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="e607ff630c60-5.4.patch"

From d81f8031f27753526fee7e9b5fb405ebce0faa2d Mon Sep 17 00:00:00 2001
From: Nathan Chancellor <nathan@kernel.org>
Date: Fri, 9 Apr 2021 12:21:28 -0700
Subject: [PATCH 5.4] MIPS: generic: Update node names to avoid unit addresses

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
[nathan: Backport to 5.4, only apply to .its.S files that exist]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/mips/generic/board-boston.its.S   | 10 +++++-----
 arch/mips/generic/board-ni169445.its.S | 10 +++++-----
 arch/mips/generic/board-ocelot.its.S   | 20 ++++++++++----------
 arch/mips/generic/board-xilfpga.its.S  | 10 +++++-----
 arch/mips/generic/vmlinux.its.S        | 10 +++++-----
 5 files changed, 30 insertions(+), 30 deletions(-)

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

base-commit: 4037804c55745738e0950658a5132790e6ac52e4
-- 
2.32.0.93.g670b81a890


--xn2IQHji/c7YufOA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="e607ff630c60-5.10.patch"

From d66eb94d8d0c8ab52ebc2999777705077b9befeb Mon Sep 17 00:00:00 2001
From: Nathan Chancellor <nathan@kernel.org>
Date: Fri, 9 Apr 2021 12:21:28 -0700
Subject: [PATCH 5.10] MIPS: generic: Update node names to avoid unit addresses

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
[nathan: Backport to 5.10, only apply to .its.S files that exist]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/mips/generic/board-boston.its.S   | 10 +++++-----
 arch/mips/generic/board-ni169445.its.S | 10 +++++-----
 arch/mips/generic/board-ocelot.its.S   | 20 ++++++++++----------
 arch/mips/generic/board-xilfpga.its.S  | 10 +++++-----
 arch/mips/generic/vmlinux.its.S        | 10 +++++-----
 5 files changed, 30 insertions(+), 30 deletions(-)

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

base-commit: 3de043c6851d7c604e0cabdf8e2aca7797952aa9
-- 
2.32.0.93.g670b81a890


--xn2IQHji/c7YufOA--
