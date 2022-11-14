Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87864627F97
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237666AbiKNNAq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:00:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237663AbiKNNAo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:00:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAEC127DFA
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:00:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8E86B80EAF
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:00:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0796CC433C1;
        Mon, 14 Nov 2022 13:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430838;
        bh=BSO1GiCZV7wfVvLtaZ/jYghXQW/qAzzpbRq+PWWOrA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ClFAmmN2r3wjgOc6XZ0xVWGg8WDRF16KgQh/zXQczmc2zhv5GAWLTXt5IneIejTJV
         RJ0cspvegZL8i5A1nzjmC0chnZP5fG+gztK0XysBDVZaUmD3UV8x9TzyTXgMW6occp
         jmiYJLpTGfb3GAp9B19uOIEa6KIJOk5k8GejtpZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Geert Uytterhoeven <geert@linux-m68k.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 6.0 003/190] m68k: Rework BI_VIRT_RNG_SEED as BI_RNG_SEED
Date:   Mon, 14 Nov 2022 13:43:47 +0100
Message-Id: <20221114124458.962911880@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit dc63a086daee92c63e392e4e7cd7ed61f3693026 upstream.

This is useful on !virt platforms for kexec, so change things from
BI_VIRT_RNG_SEED to be BI_RNG_SEED, and simply remove BI_VIRT_RNG_SEED
because it only ever lasted one release, and nothing is broken by not
having it. At the same time, keep a comment noting that it's been
removed, so that ID isn't reused. In addition, we previously documented
2-byte alignment, but 4-byte alignment is actually necessary, so update
that comment.

Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Fixes: a1ee38ab1a75 ("m68k: virt: Use RNG seed from bootinfo block")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Link: https://lore.kernel.org/r/20220927130835.1629806-2-Jason@zx2c4.com
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/m68k/include/uapi/asm/bootinfo-virt.h |    9 ++-------
 arch/m68k/include/uapi/asm/bootinfo.h      |    7 +++++++
 arch/m68k/kernel/setup_mm.c                |   12 ++++++++++++
 arch/m68k/virt/config.c                    |   11 -----------
 4 files changed, 21 insertions(+), 18 deletions(-)

--- a/arch/m68k/include/uapi/asm/bootinfo-virt.h
+++ b/arch/m68k/include/uapi/asm/bootinfo-virt.h
@@ -13,13 +13,8 @@
 #define BI_VIRT_VIRTIO_BASE	0x8004
 #define BI_VIRT_CTRL_BASE	0x8005
 
-/*
- * A random seed used to initialize the RNG. Record format:
- *
- *   - length       [ 2 bytes, 16-bit big endian ]
- *   - seed data    [ `length` bytes, padded to preserve 2-byte alignment ]
- */
-#define BI_VIRT_RNG_SEED	0x8006
+/* No longer used -- replaced with BI_RNG_SEED -- but don't reuse this index:
+ * #define BI_VIRT_RNG_SEED	0x8006 */
 
 #define VIRT_BOOTI_VERSION	MK_BI_VERSION(2, 0)
 
--- a/arch/m68k/include/uapi/asm/bootinfo.h
+++ b/arch/m68k/include/uapi/asm/bootinfo.h
@@ -64,6 +64,13 @@ struct mem_info {
 					/* (struct mem_info) */
 #define BI_COMMAND_LINE		0x0007	/* kernel command line parameters */
 					/* (string) */
+/*
+ * A random seed used to initialize the RNG. Record format:
+ *
+ *   - length       [ 2 bytes, 16-bit big endian ]
+ *   - seed data    [ `length` bytes, padded to preserve 4-byte struct alignment ]
+ */
+#define BI_RNG_SEED		0x0008
 
 
     /*
--- a/arch/m68k/kernel/setup_mm.c
+++ b/arch/m68k/kernel/setup_mm.c
@@ -25,6 +25,7 @@
 #include <linux/module.h>
 #include <linux/nvram.h>
 #include <linux/initrd.h>
+#include <linux/random.h>
 
 #include <asm/bootinfo.h>
 #include <asm/byteorder.h>
@@ -151,6 +152,17 @@ static void __init m68k_parse_bootinfo(c
 				sizeof(m68k_command_line));
 			break;
 
+		case BI_RNG_SEED: {
+			u16 len = be16_to_cpup(data);
+			add_bootloader_randomness(data + 2, len);
+			/*
+			 * Zero the data to preserve forward secrecy, and zero the
+			 * length to prevent kexec from using it.
+			 */
+			memzero_explicit((void *)data, len + 2);
+			break;
+		}
+
 		default:
 			if (MACH_IS_AMIGA)
 				unknown = amiga_parse_bootinfo(record);
--- a/arch/m68k/virt/config.c
+++ b/arch/m68k/virt/config.c
@@ -2,7 +2,6 @@
 
 #include <linux/reboot.h>
 #include <linux/serial_core.h>
-#include <linux/random.h>
 #include <clocksource/timer-goldfish.h>
 
 #include <asm/bootinfo.h>
@@ -93,16 +92,6 @@ int __init virt_parse_bootinfo(const str
 		data += 4;
 		virt_bi_data.virtio.irq = be32_to_cpup(data);
 		break;
-	case BI_VIRT_RNG_SEED: {
-		u16 len = be16_to_cpup(data);
-		add_bootloader_randomness(data + 2, len);
-		/*
-		 * Zero the data to preserve forward secrecy, and zero the
-		 * length to prevent kexec from using it.
-		 */
-		memzero_explicit((void *)data, len + 2);
-		break;
-	}
 	default:
 		unknown = 1;
 		break;


