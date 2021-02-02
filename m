Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8CF30CCC4
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 21:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240395AbhBBUHj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 15:07:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:36408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232834AbhBBNm7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:42:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACAD564DDA;
        Tue,  2 Feb 2021 13:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273197;
        bh=20MW/Pd87sXwNLbTJZKX1ylHRg4J+gcxkPxchjcdi84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0GAGWarOuBeq05eyKiZqidalh8EaRcvtRIZSmTPiR6IKvoq+E64EzlXJEpw3lJ0+v
         qqF6BvzGfxQXXbP1KfL/gJrImev+1EGlz/oJHlnEx1H6LQzotcJ2Bdpeq3qnLqTQm8
         85PVkSX2PORbFZWwnUBZ+DTUNFShJwz2mIR2mkgg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        David Hildenbrand <david@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.10 017/142] ARM: dts: ux500: Reserve memory carveouts
Date:   Tue,  2 Feb 2021 14:36:20 +0100
Message-Id: <20210202132958.420202817@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

commit 8a996b2d8a03beae3cb6adfc12673778c192085d upstream.

The Ux500 platforms have some memory carveouts set aside for
communicating with the modem and for the initial secure software
(ISSW). These areas are protected by the memory controller
and will result in an external abort if accessed like common
read/write memory.

On the legacy boot loaders, these were set aside by using
cmdline arguments such as this:

  mem=96M@0 mem_mtrace=15M@96M mem_mshared=1M@111M
  mem_modem=16M@112M mali.mali_mem=32M@128M mem=96M@160M
  hwmem=127M@256M mem_issw=1M@383M mem_ram_console=1M@384M
  mem=638M@385M

Reserve the relevant areas in the device tree instead. The
"mali", "hwmem", "mem_ram_console" and the trailing 1MB at the
end of the memory reservations in the list are not relevant for
the upstream kernel as these are nowadays replaced with
upstream technologies such as CMA. The modem and ISSW
reservations are necessary.

This was manifested in a bug that surfaced in response to
commit 7fef431be9c9 ("mm/page_alloc: place pages to tail in __free_pages_core()")
which changes the behaviour of memory allocations
in such a way that the platform will sooner run into these
dangerous areas, with "Unhandled fault: imprecise external
abort (0xc06) at 0xb6fd83dc" or similar: the real reason
turns out to be that the PTE is pointing right into one of
the reserved memory areas. We were just lucky until now.

We need to augment the DB8500 and DB8520 SoCs similarly
and also create a new include for the DB9500 used in the
Snowball since this does not have a modem and thus does
not need the modem memory reservation, albeit it needs
the ISSW reservation.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: stable@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>
Link: https://lore.kernel.org/r/20201213225517.3838501-1-linus.walleij@linaro.org'
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/ste-db8500.dtsi  |   38 +++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/ste-db8520.dtsi  |   38 +++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/ste-db9500.dtsi  |   35 ++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/ste-snowball.dts |    2 -
 4 files changed, 112 insertions(+), 1 deletion(-)

--- a/arch/arm/boot/dts/ste-db8500.dtsi
+++ b/arch/arm/boot/dts/ste-db8500.dtsi
@@ -12,4 +12,42 @@
 					    200000 0>;
 		};
 	};
+
+	reserved-memory {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		/* Modem trace memory */
+		ram@06000000 {
+			reg = <0x06000000 0x00f00000>;
+			no-map;
+		};
+
+		/* Modem shared memory */
+		ram@06f00000 {
+			reg = <0x06f00000 0x00100000>;
+			no-map;
+		};
+
+		/* Modem private memory */
+		ram@07000000 {
+			reg = <0x07000000 0x01000000>;
+			no-map;
+		};
+
+		/*
+		 * Initial Secure Software ISSW memory
+		 *
+		 * This is probably only used if the kernel tries
+		 * to actually call into trustzone to run secure
+		 * applications, which the mainline kernel probably
+		 * will not do on this old chipset. But you can never
+		 * be too careful, so reserve this memory anyway.
+		 */
+		ram@17f00000 {
+			reg = <0x17f00000 0x00100000>;
+			no-map;
+		};
+	};
 };
--- a/arch/arm/boot/dts/ste-db8520.dtsi
+++ b/arch/arm/boot/dts/ste-db8520.dtsi
@@ -12,4 +12,42 @@
 					    200000 0>;
 		};
 	};
+
+	reserved-memory {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		/* Modem trace memory */
+		ram@06000000 {
+			reg = <0x06000000 0x00f00000>;
+			no-map;
+		};
+
+		/* Modem shared memory */
+		ram@06f00000 {
+			reg = <0x06f00000 0x00100000>;
+			no-map;
+		};
+
+		/* Modem private memory */
+		ram@07000000 {
+			reg = <0x07000000 0x01000000>;
+			no-map;
+		};
+
+		/*
+		 * Initial Secure Software ISSW memory
+		 *
+		 * This is probably only used if the kernel tries
+		 * to actually call into trustzone to run secure
+		 * applications, which the mainline kernel probably
+		 * will not do on this old chipset. But you can never
+		 * be too careful, so reserve this memory anyway.
+		 */
+		ram@17f00000 {
+			reg = <0x17f00000 0x00100000>;
+			no-map;
+		};
+	};
 };
--- /dev/null
+++ b/arch/arm/boot/dts/ste-db9500.dtsi
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include "ste-dbx5x0.dtsi"
+
+/ {
+	cpus {
+		cpu@300 {
+			/* cpufreq controls */
+			operating-points = <1152000 0
+					    800000 0
+					    400000 0
+					    200000 0>;
+		};
+	};
+
+	reserved-memory {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		/*
+		 * Initial Secure Software ISSW memory
+		 *
+		 * This is probably only used if the kernel tries
+		 * to actually call into trustzone to run secure
+		 * applications, which the mainline kernel probably
+		 * will not do on this old chipset. But you can never
+		 * be too careful, so reserve this memory anyway.
+		 */
+		ram@17f00000 {
+			reg = <0x17f00000 0x00100000>;
+			no-map;
+		};
+	};
+};
--- a/arch/arm/boot/dts/ste-snowball.dts
+++ b/arch/arm/boot/dts/ste-snowball.dts
@@ -4,7 +4,7 @@
  */
 
 /dts-v1/;
-#include "ste-db8500.dtsi"
+#include "ste-db9500.dtsi"
 #include "ste-href-ab8500.dtsi"
 #include "ste-href-family-pinctrl.dtsi"
 


