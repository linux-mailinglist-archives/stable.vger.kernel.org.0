Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6013B6374
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233148AbhF1O5D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:57:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235188AbhF1OxU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:53:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4454261CBB;
        Mon, 28 Jun 2021 14:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891050;
        bh=5LRxKuqay+9Q8Vcs8SEwtVZWitlCYL6oPSFAp+5srHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KxXj8jQ4pxpSqatpTOwEy1Ah6t4utFItS6bajJduAr88xLmX3uY7qUCyrN53iE7MQ
         FAweiNGWXOKiacNlP2WfPS/ZJ0QUz+w1c1fsMXphOwXqZJwTD/N/SFandEd20gyzaP
         Tz6JCenzKdT8ef+ij0tr8kFN0HuSJMOJnfMOk7aK6SuC0HcA8ZXTL31Dh1gVPyqhHA
         JGdBYGi5Tm5Rs0NnJuDqA6KjU5W8irsCgLdDw0G1UYfiXX/LbGamTdmn7r5CPBd2un
         0ojdbiI6IehdEgv1rO6jfBnP+hHQsur5pncAhg8TZf3SZFxZmGjH5KSBH390plvsm8
         C2vXncixcFhYg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Simon Glass <sjg@chromium.org>, Tom Rini <trini@konsulko.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 69/88] MIPS: generic: Update node names to avoid unit addresses
Date:   Mon, 28 Jun 2021 10:36:09 -0400
Message-Id: <20210628143628.33342-70-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143628.33342-1-sashal@kernel.org>
References: <20210628143628.33342-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.238-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.238-rc1
X-KernelTest-Deadline: 2021-06-30T14:36+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
[nathan: Backport to 4.14, only apply to .its.S files that exist]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
-- 
2.30.2

