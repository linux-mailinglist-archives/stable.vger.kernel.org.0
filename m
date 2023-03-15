Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8904C6BB27D
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232845AbjCOMgq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232508AbjCOMga (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:36:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E0FC9F229
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:35:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3903BB81E11
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:34:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB3EEC433D2;
        Wed, 15 Mar 2023 12:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883677;
        bh=q5ZOKpxiyQ4ociMUOi0GN0rLZknI2D2yj73EJ1+ckZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XNs6Jjer+CXyA2AXRHqhFN5hff4Js6pIIte/XOUzBQ2lAlwXQmFvCFeCOd823dz8S
         aGjdSDDfA/Bsn2QggPzbBguMzYm8bXPRlM5aNAshwoR0fSPiWxI3JEvdgqKZZLlR41
         EUDOLkh+4+oQWivnk/ERq+rglo9LJ6DhuuTPryKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Stephen Walsh <vk3heg@vk3heg.net>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Finn Thain <fthain@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 090/143] m68k: mm: Move initrd phys_to_virt handling after paging_init()
Date:   Wed, 15 Mar 2023 13:12:56 +0100
Message-Id: <20230315115743.258612699@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit d4b97925e87eb133e400fe4a482d750c74ce392f ]

When booting with an initial ramdisk on platforms where physical memory
does not start at address zero (e.g. on Amiga):

    initrd: 0ef0602c - 0f800000
    Zone ranges:
      DMA      [mem 0x0000000008000000-0x000000f7ffffffff]
      Normal   empty
    Movable zone start for each node
    Early memory node ranges
      node   0: [mem 0x0000000008000000-0x000000000f7fffff]
    Initmem setup node 0 [mem 0x0000000008000000-0x000000000f7fffff]
    Unable to handle kernel access at virtual address (ptrval)
    Oops: 00000000
    Modules linked in:
    PC: [<00201d3c>] memcmp+0x28/0x56

As phys_to_virt() relies on m68k_memoffset and module_fixup(), it must
not be called before paging_init().  Hence postpone the phys_to_virt
handling for the initial ramdisk until after calling paging_init().

While at it, reduce #ifdef clutter by using IS_ENABLED() instead.

Fixes: 376e3fdecb0dcae2 ("m68k: Enable memtest functionality")
Reported-by: Stephen Walsh <vk3heg@vk3heg.net>
Link: https://lists.debian.org/debian-68k/2022/09/msg00007.html
Reported-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Link: https://lore.kernel.org/r/4f45f05f377bf3f5baf88dbd5c3c8aeac59d94f0.camel@physik.fu-berlin.de
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Finn Thain <fthain@linux-m68k.org>
Link: https://lore.kernel.org/r/dff216da09ab7a60217c3fc2147e671ae07d636f.1677528627.git.geert@linux-m68k.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/kernel/setup_mm.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/m68k/kernel/setup_mm.c b/arch/m68k/kernel/setup_mm.c
index 3a2bb2e8fdad4..fbff1cea62caa 100644
--- a/arch/m68k/kernel/setup_mm.c
+++ b/arch/m68k/kernel/setup_mm.c
@@ -326,16 +326,16 @@ void __init setup_arch(char **cmdline_p)
 		panic("No configuration setup");
 	}
 
-#ifdef CONFIG_BLK_DEV_INITRD
-	if (m68k_ramdisk.size) {
+	if (IS_ENABLED(CONFIG_BLK_DEV_INITRD) && m68k_ramdisk.size)
 		memblock_reserve(m68k_ramdisk.addr, m68k_ramdisk.size);
+
+	paging_init();
+
+	if (IS_ENABLED(CONFIG_BLK_DEV_INITRD) && m68k_ramdisk.size) {
 		initrd_start = (unsigned long)phys_to_virt(m68k_ramdisk.addr);
 		initrd_end = initrd_start + m68k_ramdisk.size;
 		pr_info("initrd: %08lx - %08lx\n", initrd_start, initrd_end);
 	}
-#endif
-
-	paging_init();
 
 #ifdef CONFIG_NATFEAT
 	nf_init();
-- 
2.39.2



