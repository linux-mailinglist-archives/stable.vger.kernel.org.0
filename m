Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C51774F3ACB
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236772AbiDELsX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355833AbiDEKWI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:22:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E51DB9F6C7;
        Tue,  5 Apr 2022 03:05:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29C956172B;
        Tue,  5 Apr 2022 10:05:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2C6C385A2;
        Tue,  5 Apr 2022 10:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153109;
        bh=MSTbhPiz+0gIdLuJbCp8xgfsyCNe3dcUzSOKZ3PzUac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lnKPSqQ1PP6ZLhBthUQjLUPe+oa9LUZ600hkdiFrBtwtmuHUuZWZyS1fiJMqV6pUT
         WzEMlaqElnSA/65kRilAWWZJmKRXrNXpIzqOLTBODXniAalUiDaPOpWlReUj9g+gMQ
         QF/ZWF2nSsUysyCx1dOtyBq2/Isrcbig+b3doFtk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Chinwen Chang <chinwen.chang@mediatek.com>,
        Nicholas Tang <nicholas.tang@mediatek.com>,
        Yee Lee <yee.lee@mediatek.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 078/599] mm/kmemleak: reset tag when compare object pointer
Date:   Tue,  5 Apr 2022 09:26:12 +0200
Message-Id: <20220405070301.147117364@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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

From: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>

commit bfc8089f00fa526dea983844c880fa8106c33ac4 upstream.

When we use HW-tag based kasan and enable vmalloc support, we hit the
following bug.  It is due to comparison between tagged object and
non-tagged pointer.

We need to reset the kasan tag when we need to compare tagged object and
non-tagged pointer.

  kmemleak: [name:kmemleak&]Scan area larger than object 0xffffffe77076f440
  CPU: 4 PID: 1 Comm: init Tainted: G S      W         5.15.25-android13-0-g5cacf919c2bc #1
  Hardware name: MT6983(ENG) (DT)
  Call trace:
   add_scan_area+0xc4/0x244
   kmemleak_scan_area+0x40/0x9c
   layout_and_allocate+0x1e8/0x288
   load_module+0x2c8/0xf00
   __se_sys_finit_module+0x190/0x1d0
   __arm64_sys_finit_module+0x20/0x30
   invoke_syscall+0x60/0x170
   el0_svc_common+0xc8/0x114
   do_el0_svc+0x28/0xa0
   el0_svc+0x60/0xf8
   el0t_64_sync_handler+0x88/0xec
   el0t_64_sync+0x1b4/0x1b8
  kmemleak: [name:kmemleak&]Object 0xf5ffffe77076b000 (size 32768):
  kmemleak: [name:kmemleak&]  comm "init", pid 1, jiffies 4294894197
  kmemleak: [name:kmemleak&]  min_count = 0
  kmemleak: [name:kmemleak&]  count = 0
  kmemleak: [name:kmemleak&]  flags = 0x1
  kmemleak: [name:kmemleak&]  checksum = 0
  kmemleak: [name:kmemleak&]  backtrace:
       module_alloc+0x9c/0x120
       move_module+0x34/0x19c
       layout_and_allocate+0x1c4/0x288
       load_module+0x2c8/0xf00
       __se_sys_finit_module+0x190/0x1d0
       __arm64_sys_finit_module+0x20/0x30
       invoke_syscall+0x60/0x170
       el0_svc_common+0xc8/0x114
       do_el0_svc+0x28/0xa0
       el0_svc+0x60/0xf8
       el0t_64_sync_handler+0x88/0xec
       el0t_64_sync+0x1b4/0x1b8

Link: https://lkml.kernel.org/r/20220318034051.30687-1-Kuan-Ying.Lee@mediatek.com
Signed-off-by: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: Nicholas Tang <nicholas.tang@mediatek.com>
Cc: Yee Lee <yee.lee@mediatek.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kmemleak.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -787,6 +787,8 @@ static void add_scan_area(unsigned long
 	unsigned long flags;
 	struct kmemleak_object *object;
 	struct kmemleak_scan_area *area = NULL;
+	unsigned long untagged_ptr;
+	unsigned long untagged_objp;
 
 	object = find_and_get_object(ptr, 1);
 	if (!object) {
@@ -795,6 +797,9 @@ static void add_scan_area(unsigned long
 		return;
 	}
 
+	untagged_ptr = (unsigned long)kasan_reset_tag((void *)ptr);
+	untagged_objp = (unsigned long)kasan_reset_tag((void *)object->pointer);
+
 	if (scan_area_cache)
 		area = kmem_cache_alloc(scan_area_cache, gfp_kmemleak_mask(gfp));
 
@@ -806,8 +811,8 @@ static void add_scan_area(unsigned long
 		goto out_unlock;
 	}
 	if (size == SIZE_MAX) {
-		size = object->pointer + object->size - ptr;
-	} else if (ptr + size > object->pointer + object->size) {
+		size = untagged_objp + object->size - untagged_ptr;
+	} else if (untagged_ptr + size > untagged_objp + object->size) {
 		kmemleak_warn("Scan area larger than object 0x%08lx\n", ptr);
 		dump_object_info(object);
 		kmem_cache_free(scan_area_cache, area);


