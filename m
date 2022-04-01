Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72A204EF9C1
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 20:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349958AbiDASXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 14:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350142AbiDASXZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 14:23:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B55539837;
        Fri,  1 Apr 2022 11:21:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB76460C8F;
        Fri,  1 Apr 2022 18:21:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF68C340EE;
        Fri,  1 Apr 2022 18:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648837294;
        bh=2Pjq8XcpdCGc+T07YRo4AccJvw0mDqgQtNTu4AoreVY=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=KeMLNqVaRcACB0jcFzDsuc69d2eWdYaRBYumBuc8kF6TKJHOqUoCNhnJ66C2YuxTK
         NWf6cc4h1ROFcVHVANOxgewD+HjCZLGJleXTxfvNywQoKUxtAI0ChmXaFeUu95G5Ob
         7zZWMxEe4ZGKsmv6wy/UTrPjK77A/WUzqB4cmpWs=
Date:   Fri, 01 Apr 2022 11:21:33 -0700
To:     yee.lee@mediatek.com, stable@vger.kernel.org,
        nicholas.tang@mediatek.com, matthias.bgg@gmail.com,
        chinwen.chang@mediatek.com, catalin.marinas@arm.com,
        Kuan-Ying.Lee@mediatek.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <l>
Subject: [patch 15/16] mm/kmemleak: reset tag when compare object pointer
Message-Id: <20220401182134.4CF68C340EE@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Subject: mm/kmemleak: reset tag when compare object pointer

When we use HW-tag based kasan and enable vmalloc support, we hit
the following bug. It is due to comparison between tagged object
and non-tagged pointer.

We need to reset the kasan tag when we need to compare tagged object
and non-tagged pointer.

[    7.690429][T400001] init: kmemleak: [name:kmemleak&]Scan area larger than object 0xffffffe77076f440
[    7.691762][T400001] init: CPU: 4 PID: 1 Comm: init Tainted: G S      W         5.15.25-android13-0-g5cacf919c2bc #1
[    7.693218][T400001] init: Hardware name: MT6983(ENG) (DT)
[    7.693983][T400001] init: Call trace:
[    7.694508][T400001] init:  dump_backtrace.cfi_jt+0x0/0x8
[    7.695272][T400001] init:  dump_stack_lvl+0xac/0x120
[    7.695985][T400001] init:  add_scan_area+0xc4/0x244
[    7.696685][T400001] init:  kmemleak_scan_area+0x40/0x9c
[    7.697428][T400001] init:  layout_and_allocate+0x1e8/0x288
[    7.698211][T400001] init:  load_module+0x2c8/0xf00
[    7.698895][T400001] init:  __se_sys_finit_module+0x190/0x1d0
[    7.699701][T400001] init:  __arm64_sys_finit_module+0x20/0x30
[    7.700517][T400001] init:  invoke_syscall+0x60/0x170
[    7.701225][T400001] init:  el0_svc_common+0xc8/0x114
[    7.701933][T400001] init:  do_el0_svc+0x28/0xa0
[    7.702580][T400001] init:  el0_svc+0x60/0xf8
[    7.703196][T400001] init:  el0t_64_sync_handler+0x88/0xec
[    7.703964][T400001] init:  el0t_64_sync+0x1b4/0x1b8
[    7.704658][T400001] init: kmemleak: [name:kmemleak&]Object 0xf5ffffe77076b000 (size 32768):
[    7.705824][T400001] init: kmemleak: [name:kmemleak&]  comm "init", pid 1, jiffies 4294894197
[    7.707002][T400001] init: kmemleak: [name:kmemleak&]  min_count = 0
[    7.707886][T400001] init: kmemleak: [name:kmemleak&]  count = 0
[    7.708718][T400001] init: kmemleak: [name:kmemleak&]  flags = 0x1
[    7.709574][T400001] init: kmemleak: [name:kmemleak&]  checksum = 0
[    7.710440][T400001] init: kmemleak: [name:kmemleak&]  backtrace:
[    7.711284][T400001] init:      module_alloc+0x9c/0x120
[    7.712015][T400001] init:      move_module+0x34/0x19c
[    7.712735][T400001] init:      layout_and_allocate+0x1c4/0x288
[    7.713561][T400001] init:      load_module+0x2c8/0xf00
[    7.714291][T400001] init:      __se_sys_finit_module+0x190/0x1d0
[    7.715142][T400001] init:      __arm64_sys_finit_module+0x20/0x30
[    7.716004][T400001] init:      invoke_syscall+0x60/0x170
[    7.716758][T400001] init:      el0_svc_common+0xc8/0x114
[    7.717512][T400001] init:      do_el0_svc+0x28/0xa0
[    7.718207][T400001] init:      el0_svc+0x60/0xf8
[    7.718869][T400001] init:      el0t_64_sync_handler+0x88/0xec
[    7.719683][T400001] init:      el0t_64_sync+0x1b4/0x1b8

Link: https://lkml.kernel.org/r/20220318034051.30687-1-Kuan-Ying.Lee@mediatek.com
Signed-off-by: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: Nicholas Tang <nicholas.tang@mediatek.com>
Cc: Yee Lee <yee.lee@mediatek.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-reset-tag-when-compare-object-pointer
+++ a/mm/kmemleak.c
@@ -796,6 +796,8 @@ static void add_scan_area(unsigned long
 	unsigned long flags;
 	struct kmemleak_object *object;
 	struct kmemleak_scan_area *area = NULL;
+	unsigned long untagged_ptr;
+	unsigned long untagged_objp;
 
 	object = find_and_get_object(ptr, 1);
 	if (!object) {
@@ -804,6 +806,9 @@ static void add_scan_area(unsigned long
 		return;
 	}
 
+	untagged_ptr = (unsigned long)kasan_reset_tag((void *)ptr);
+	untagged_objp = (unsigned long)kasan_reset_tag((void *)object->pointer);
+
 	if (scan_area_cache)
 		area = kmem_cache_alloc(scan_area_cache, gfp_kmemleak_mask(gfp));
 
@@ -815,8 +820,8 @@ static void add_scan_area(unsigned long
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
_
