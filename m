Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 804F769CE61
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232697AbjBTN7F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:59:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232699AbjBTN7C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:59:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF9671B57F
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:58:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A64CB80D07
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:58:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D08C433EF;
        Mon, 20 Feb 2023 13:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901510;
        bh=gVYggOtdEE5UXegcs5xAgjlk0X8w1j6jsMTqID/cYzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YHsO2Ju1/OmijJiT3TREgxr+CfAwYutkY9WySatXhRwfdGje5/3xApr8scFzAPPME
         DZQB8M0vsYYt45yXKW6Trlp2EsjjJn9TNyA4AiJROGVRBr3L9hURj05kCoQO8MKUHo
         Md3kabfXDfTmCOERhTNOK/RgQgcyBuANIpj33nNo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Nathan Lynch <nathanl@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 045/118] kasan: fix Oops due to missing calls to kasan_arch_is_ready()
Date:   Mon, 20 Feb 2023 14:36:01 +0100
Message-Id: <20230220133602.241243283@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit 55d77bae73426237b3c74c1757a894b056550dff upstream.

On powerpc64, you can build a kernel with KASAN as soon as you build it
with RADIX MMU support.  However if the CPU doesn't have RADIX MMU, KASAN
isn't enabled at init and the following Oops is encountered.

  [    0.000000][    T0] KASAN not enabled as it requires radix!

  [    4.484295][   T26] BUG: Unable to handle kernel data access at 0xc00e000000804a04
  [    4.485270][   T26] Faulting instruction address: 0xc00000000062ec6c
  [    4.485748][   T26] Oops: Kernel access of bad area, sig: 11 [#1]
  [    4.485920][   T26] BE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
  [    4.486259][   T26] Modules linked in:
  [    4.486637][   T26] CPU: 0 PID: 26 Comm: kworker/u2:2 Not tainted 6.2.0-rc3-02590-gf8a023b0a805 #249
  [    4.486907][   T26] Hardware name: IBM pSeries (emulated by qemu) POWER9 (raw) 0x4e1200 0xf000005 of:SLOF,HEAD pSeries
  [    4.487445][   T26] Workqueue: eval_map_wq .tracer_init_tracefs_work_func
  [    4.488744][   T26] NIP:  c00000000062ec6c LR: c00000000062bb84 CTR: c0000000002ebcd0
  [    4.488867][   T26] REGS: c0000000049175c0 TRAP: 0380   Not tainted  (6.2.0-rc3-02590-gf8a023b0a805)
  [    4.489028][   T26] MSR:  8000000002009032 <SF,VEC,EE,ME,IR,DR,RI>  CR: 44002808  XER: 00000000
  [    4.489584][   T26] CFAR: c00000000062bb80 IRQMASK: 0
  [    4.489584][   T26] GPR00: c0000000005624d4 c000000004917860 c000000001cfc000 1800000000804a04
  [    4.489584][   T26] GPR04: c0000000003a2650 0000000000000cc0 c00000000000d3d8 c00000000000d3d8
  [    4.489584][   T26] GPR08: c0000000049175b0 a80e000000000000 0000000000000000 0000000017d78400
  [    4.489584][   T26] GPR12: 0000000044002204 c000000003790000 c00000000435003c c0000000043f1c40
  [    4.489584][   T26] GPR16: c0000000043f1c68 c0000000043501a0 c000000002106138 c0000000043f1c08
  [    4.489584][   T26] GPR20: c0000000043f1c10 c0000000043f1c20 c000000004146c40 c000000002fdb7f8
  [    4.489584][   T26] GPR24: c000000002fdb834 c000000003685e00 c000000004025030 c000000003522e90
  [    4.489584][   T26] GPR28: 0000000000000cc0 c0000000003a2650 c000000004025020 c000000004025020
  [    4.491201][   T26] NIP [c00000000062ec6c] .kasan_byte_accessible+0xc/0x20
  [    4.491430][   T26] LR [c00000000062bb84] .__kasan_check_byte+0x24/0x90
  [    4.491767][   T26] Call Trace:
  [    4.491941][   T26] [c000000004917860] [c00000000062ae70] .__kasan_kmalloc+0xc0/0x110 (unreliable)
  [    4.492270][   T26] [c0000000049178f0] [c0000000005624d4] .krealloc+0x54/0x1c0
  [    4.492453][   T26] [c000000004917990] [c0000000003a2650] .create_trace_option_files+0x280/0x530
  [    4.492613][   T26] [c000000004917a90] [c000000002050d90] .tracer_init_tracefs_work_func+0x274/0x2c0
  [    4.492771][   T26] [c000000004917b40] [c0000000001f9948] .process_one_work+0x578/0x9f0
  [    4.492927][   T26] [c000000004917c30] [c0000000001f9ebc] .worker_thread+0xfc/0x950
  [    4.493084][   T26] [c000000004917d60] [c00000000020be84] .kthread+0x1a4/0x1b0
  [    4.493232][   T26] [c000000004917e10] [c00000000000d3d8] .ret_from_kernel_thread+0x58/0x60
  [    4.495642][   T26] Code: 60000000 7cc802a6 38a00000 4bfffc78 60000000 7cc802a6 38a00001 4bfffc68 60000000 3d20a80e 7863e8c2 792907c6 <7c6348ae> 20630007 78630fe0 68630001
  [    4.496704][   T26] ---[ end trace 0000000000000000 ]---

The Oops is due to kasan_byte_accessible() not checking the readiness of
KASAN.  Add missing call to kasan_arch_is_ready() and bail out when not
ready.  The same problem is observed with ____kasan_kfree_large() so fix
it the same.

Also, as KASAN is not available and no shadow area is allocated for linear
memory mapping, there is no point in allocating shadow mem for vmalloc
memory as shown below in /sys/kernel/debug/kernel_page_tables

  ---[ kasan shadow mem start ]---
  0xc00f000000000000-0xc00f00000006ffff  0x00000000040f0000       448K         r  w       pte  valid  present        dirty  accessed
  0xc00f000000860000-0xc00f00000086ffff  0x000000000ac10000        64K         r  w       pte  valid  present        dirty  accessed
  0xc00f3ffffffe0000-0xc00f3fffffffffff  0x0000000004d10000       128K         r  w       pte  valid  present        dirty  accessed
  ---[ kasan shadow mem end ]---

So, also verify KASAN readiness before allocating and poisoning
shadow mem for VMAs.

Link: https://lkml.kernel.org/r/150768c55722311699fdcf8f5379e8256749f47d.1674716617.git.christophe.leroy@csgroup.eu
Fixes: 41b7a347bf14 ("powerpc: Book3S 64-bit outline-only KASAN support")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reported-by: Nathan Lynch <nathanl@linux.ibm.com>
Suggested-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: <stable@vger.kernel.org>	[5.19+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kasan/common.c  |  3 +++
 mm/kasan/generic.c |  7 ++++++-
 mm/kasan/shadow.c  | 12 ++++++++++++
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/mm/kasan/common.c b/mm/kasan/common.c
index 833bf2cfd2a3..21e66d7f261d 100644
--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -246,6 +246,9 @@ bool __kasan_slab_free(struct kmem_cache *cache, void *object,
 
 static inline bool ____kasan_kfree_large(void *ptr, unsigned long ip)
 {
+	if (!kasan_arch_is_ready())
+		return false;
+
 	if (ptr != page_address(virt_to_head_page(ptr))) {
 		kasan_report_invalid_free(ptr, ip, KASAN_REPORT_INVALID_FREE);
 		return true;
diff --git a/mm/kasan/generic.c b/mm/kasan/generic.c
index b076f597a378..cb762982c8ba 100644
--- a/mm/kasan/generic.c
+++ b/mm/kasan/generic.c
@@ -191,7 +191,12 @@ bool kasan_check_range(unsigned long addr, size_t size, bool write,
 
 bool kasan_byte_accessible(const void *addr)
 {
-	s8 shadow_byte = READ_ONCE(*(s8 *)kasan_mem_to_shadow(addr));
+	s8 shadow_byte;
+
+	if (!kasan_arch_is_ready())
+		return true;
+
+	shadow_byte = READ_ONCE(*(s8 *)kasan_mem_to_shadow(addr));
 
 	return shadow_byte >= 0 && shadow_byte < KASAN_GRANULE_SIZE;
 }
diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
index 2fba1f51f042..15cfb34d16a1 100644
--- a/mm/kasan/shadow.c
+++ b/mm/kasan/shadow.c
@@ -291,6 +291,9 @@ int kasan_populate_vmalloc(unsigned long addr, unsigned long size)
 	unsigned long shadow_start, shadow_end;
 	int ret;
 
+	if (!kasan_arch_is_ready())
+		return 0;
+
 	if (!is_vmalloc_or_module_addr((void *)addr))
 		return 0;
 
@@ -459,6 +462,9 @@ void kasan_release_vmalloc(unsigned long start, unsigned long end,
 	unsigned long region_start, region_end;
 	unsigned long size;
 
+	if (!kasan_arch_is_ready())
+		return;
+
 	region_start = ALIGN(start, KASAN_MEMORY_PER_SHADOW_PAGE);
 	region_end = ALIGN_DOWN(end, KASAN_MEMORY_PER_SHADOW_PAGE);
 
@@ -502,6 +508,9 @@ void *__kasan_unpoison_vmalloc(const void *start, unsigned long size,
 	 * with setting memory tags, so the KASAN_VMALLOC_INIT flag is ignored.
 	 */
 
+	if (!kasan_arch_is_ready())
+		return (void *)start;
+
 	if (!is_vmalloc_or_module_addr(start))
 		return (void *)start;
 
@@ -524,6 +533,9 @@ void *__kasan_unpoison_vmalloc(const void *start, unsigned long size,
  */
 void __kasan_poison_vmalloc(const void *start, unsigned long size)
 {
+	if (!kasan_arch_is_ready())
+		return;
+
 	if (!is_vmalloc_or_module_addr(start))
 		return;
 
-- 
2.39.1



