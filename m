Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9448B6512E4
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 20:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232672AbiLSTYb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 14:24:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232617AbiLSTXy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 14:23:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64DB91056E
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 11:23:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 279AFB80EF7
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 19:23:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8959EC433EF;
        Mon, 19 Dec 2022 19:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671477819;
        bh=oX4Wlkx2gCd9msRn6bfykGmQ4r8dXV+DGaskVLBHuVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=suJ5OGVoSOX4rx2oYSdFxWnY3jHM/33KPjJMYw+WcvEtYOfTGX7VXtb8Avqcgge9g
         Jxp/lXUouyTREVODUcOluVcB1IqwU+y1tKriqNIme4l/3dE74uFV0c1fqdkcgrNH7I
         P2cUhQbPTkFfM0MyaFEDtbdTHt+w0gjGarggWHKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        John Thomson <git@johnthomson.fastmail.com.au>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.1 06/25] mips: ralink: mt7621: do not use kzalloc too early
Date:   Mon, 19 Dec 2022 20:22:45 +0100
Message-Id: <20221219182943.680971051@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221219182943.395169070@linuxfoundation.org>
References: <20221219182943.395169070@linuxfoundation.org>
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

From: John Thomson <git@johnthomson.fastmail.com.au>

commit 7c18b64bba3bcad1be94b404f47b94a04b91ce79 upstream.

With CONFIG_SLUB=y, following commit 6edf2576a6cc ("mm/slub: enable
debugging memory wasting of kmalloc") mt7621 failed to boot very early,
without showing any console messages.
This exposed the pre-existing bug of mt7621.c using kzalloc before normal
memory management was available.
Prior to this slub change, there existed the unintended protection against
"kmem_cache *s" being NULL as slab_pre_alloc_hook() happened to
return NULL and bailed out of slab_alloc_node().
This allowed mt7621 prom_soc_init to fail in the soc_dev_init kzalloc,
but continue booting without the SOC_BUS driver device registered.

Console output from a DEBUG_ZBOOT vmlinuz kernel loading,
with mm/slub modified to warn on kmem_cache zero or null:

zimage at:     80B842A0 810B4BC0
Uncompressing Linux at load address 80001000
Copy device tree to address  80B80EE0
Now, booting the kernel...

[    0.000000] Linux version 6.1.0-rc3+ (john@john)
(mipsel-buildroot-linux-gnu-gcc.br_real (Buildroot
2021.11-4428-g6b6741b) 12.2.0, GNU ld (GNU Binutils) 2.39) #73 SMP Wed
     Nov  2 05:10:01 AEST 2022
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at mm/slub.c:3416
kmem_cache_alloc+0x5a4/0x5e8
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 6.1.0-rc3+ #73
[    0.000000] Stack : 810fff78 80084d98 00000000 00000004 00000000
00000000 80889d04 80c90000
[    0.000000]         80920000 807bd328 8089d368 80923bd3 00000000
00000001 80889cb0 00000000
[    0.000000]         00000000 00000000 807bd328 8084bcb1 00000002
00000002 00000001 6d6f4320
[    0.000000]         00000000 80c97d3d 80c97d68 fffffffc 807bd328
00000000 00000000 00000000
[    0.000000]         00000000 a0000000 80910000 8110a0b4 00000000
00000020 80010000 80010000
[    0.000000]         ...
[    0.000000] Call Trace:
[    0.000000] [<80008260>] show_stack+0x28/0xf0
[    0.000000] [<8070c958>] dump_stack_lvl+0x60/0x80
[    0.000000] [<8002e184>] __warn+0xc4/0xf8
[    0.000000] [<8002e210>] warn_slowpath_fmt+0x58/0xa4
[    0.000000] [<801c0fac>] kmem_cache_alloc+0x5a4/0x5e8
[    0.000000] [<8092856c>] prom_soc_init+0x1fc/0x2b4
[    0.000000] [<80928060>] prom_init+0x44/0xf0
[    0.000000] [<80929214>] setup_arch+0x4c/0x6a8
[    0.000000] [<809257e0>] start_kernel+0x88/0x7c0
[    0.000000]
[    0.000000] ---[ end trace 0000000000000000 ]---
[    0.000000] SoC Type: MediaTek MT7621 ver:1 eco:3
[    0.000000] printk: bootconsole [early0] enabled

Allowing soc_device_register to work exposed oops in the mt7621 phy pci,
and pci controller drivers from soc_device_match_attr, due to missing
sentinels in the quirks tables. These were fixed with:
commit 819b885cd886 ("phy: ralink: mt7621-pci: add sentinel to quirks
table")
not yet applied ("PCI: mt7621: add sentinel to quirks table")

Link: https://lore.kernel.org/linux-mm/becf2ac3-2a90-4f3a-96d9-a70f67c66e4a@app.fastmail.com/
Fixes: 71b9b5e0130d ("MIPS: ralink: mt7621: introduce 'soc_device' initialization")
Signed-off-by: John Thomson <git@johnthomson.fastmail.com.au>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/ralink/mt7621.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/arch/mips/ralink/mt7621.c
+++ b/arch/mips/ralink/mt7621.c
@@ -25,6 +25,7 @@
 #define MT7621_MEM_TEST_PATTERN         0xaa5555aa
 
 static u32 detect_magic __initdata;
+static struct ralink_soc_info *soc_info_ptr;
 
 int pcibios_root_bridge_prepare(struct pci_host_bridge *bridge)
 {
@@ -147,27 +148,30 @@ static const char __init *mt7621_get_soc
 		return "E1";
 }
 
-static void soc_dev_init(struct ralink_soc_info *soc_info)
+static int __init mt7621_soc_dev_init(void)
 {
 	struct soc_device *soc_dev;
 	struct soc_device_attribute *soc_dev_attr;
 
 	soc_dev_attr = kzalloc(sizeof(*soc_dev_attr), GFP_KERNEL);
 	if (!soc_dev_attr)
-		return;
+		return -ENOMEM;
 
 	soc_dev_attr->soc_id = "mt7621";
 	soc_dev_attr->family = "Ralink";
 	soc_dev_attr->revision = mt7621_get_soc_revision();
 
-	soc_dev_attr->data = soc_info;
+	soc_dev_attr->data = soc_info_ptr;
 
 	soc_dev = soc_device_register(soc_dev_attr);
 	if (IS_ERR(soc_dev)) {
 		kfree(soc_dev_attr);
-		return;
+		return PTR_ERR(soc_dev);
 	}
+
+	return 0;
 }
+device_initcall(mt7621_soc_dev_init);
 
 void __init prom_soc_init(struct ralink_soc_info *soc_info)
 {
@@ -209,7 +213,7 @@ void __init prom_soc_init(struct ralink_
 
 	soc_info->mem_detect = mt7621_memory_detect;
 
-	soc_dev_init(soc_info);
+	soc_info_ptr = soc_info;
 
 	if (!register_cps_smp_ops())
 		return;


