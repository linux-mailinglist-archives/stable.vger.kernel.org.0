Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ACB25AB23E
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 15:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238412AbiIBNxb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 09:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235543AbiIBNxO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 09:53:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1202413973E;
        Fri,  2 Sep 2022 06:27:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61B83B82A96;
        Fri,  2 Sep 2022 13:26:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89E0C433C1;
        Fri,  2 Sep 2022 13:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662125216;
        bh=e4t/z7lUD4RwCQ9WcN91ar/BpZr/QZPbrCmW90DDfuU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J24bxSmZym6a32xwgOgabGub+S5f+xw+pz7Y5Zdi+zfzlRIbZz1aYcUxSXxqwbOBY
         omCxQn+E7zzcsTTXwVCLKOfxEPAZO2nF8oFrupaWMySub0vlT114r6CqvpZ1rM170M
         e1DBqmZ9cfNQQFXWZne4FJXy8pe/2lXIdZUNA6QtxlgmZuDPhucTI/t05x79lYfsxb
         bJfUKcCCy28zSPBvhmhiM7AwuOzktzMenx6KZrYoKWwm3I37r/oOjfgm8/yLVT4uxd
         zHpTRviavfzFSK+/R8aYbjI0iq4CtKPj8n/KP16OVzqXCtnYy+4e5975gIh6UUEG7u
         anQS+Vx2sAIog==
Date:   Fri, 2 Sep 2022 16:26:51 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Vijay Dhanraj <vijay.dhanraj@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/6] x86/sgx: Do not consider unsanitized pages an
 error
Message-ID: <YxIEm4uHVvUY/rv6@kernel.org>
References: <20220831173829.126661-1-jarkko@kernel.org>
 <20220831173829.126661-3-jarkko@kernel.org>
 <24906e57-461f-6c94-9e78-0d8507df01bb@intel.com>
 <YxEp8Ji+ukLBoNE+@kernel.org>
 <84b8eb06-7b77-675f-5bc8-292fe27dd2f5@intel.com>
 <YxFGykqMb+TD4L4l@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="zH23CSNPZKs2jfpL"
Content-Disposition: inline
In-Reply-To: <YxFGykqMb+TD4L4l@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--zH23CSNPZKs2jfpL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 02, 2022 at 02:57:01AM +0300, Jarkko Sakkinen wrote:
> > Understood that the goal is to only print the
> > number of unsanitized pages if ksgxd has not been
> > stopped prematurely.
> 
> Yeah, and thus give as useful information for sysadmin/developer
> as we can.

I figured out how to get best of both worlds. See the
attached patch. I'll send formal series later on.

Keeps the accurancy, just postpones the exit.

BR, Jarkko

--zH23CSNPZKs2jfpL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="tmp.patch"

From 31c43c3276667cef0a7f0687d489552f26da877b Mon Sep 17 00:00:00 2001
From: Jarkko Sakkinen <jarkko@kernel.org>
Date: Thu, 25 Aug 2022 08:12:30 +0300
Subject: [PATCH] x86/sgx: Do not consider unsanitized pages an error

In sgx_init(), if misc_register() fails or misc_register() succeeds but
neither sgx_drv_init() nor sgx_vepc_init() succeeds, then ksgxd will be
prematurely stopped. This may leave some unsanitized pages, which does
not matter, because SGX will be disabled for the whole power cycle.

This triggers WARN_ON() because sgx_dirty_page_list ends up being
non-empty, and dumps the call stack:

[    0.268103] sgx: EPC section 0x40200000-0x45f7ffff
[    0.268591] ------------[ cut here ]------------
[    0.268592] WARNING: CPU: 6 PID: 83 at
arch/x86/kernel/cpu/sgx/main.c:401 ksgxd+0x1b7/0x1d0
[    0.268598] Modules linked in:
[    0.268600] CPU: 6 PID: 83 Comm: ksgxd Not tainted 6.0.0-rc2 #382
[    0.268603] Hardware name: Dell Inc. XPS 13 9370/0RMYH9, BIOS 1.21.0
07/06/2022
[    0.268604] RIP: 0010:ksgxd+0x1b7/0x1d0
[    0.268607] Code: ff e9 f2 fe ff ff 48 89 df e8 75 07 0e 00 84 c0 0f
84 c3 fe ff ff 31 ff e8 e6 07 0e 00 84 c0 0f 85 94 fe ff ff e9 af fe ff
ff <0f> 0b e9 7f fe ff ff e8 dd 9c 95 00 66 66 2e 0f 1f 84 00 00 00 00
[    0.268608] RSP: 0000:ffffb6c7404f3ed8 EFLAGS: 00010287
[    0.268610] RAX: ffffb6c740431a10 RBX: ffff8dcd8117b400 RCX:
0000000000000000
[    0.268612] RDX: 0000000080000000 RSI: ffffb6c7404319d0 RDI:
00000000ffffffff
[    0.268613] RBP: ffff8dcd820a4d80 R08: ffff8dcd820a4180 R09:
ffff8dcd820a4180
[    0.268614] R10: 0000000000000000 R11: 0000000000000006 R12:
ffffb6c74006bce0
[    0.268615] R13: ffff8dcd80e63880 R14: ffffffffa8a60f10 R15:
0000000000000000
[    0.268616] FS:  0000000000000000(0000) GS:ffff8dcf25580000(0000)
knlGS:0000000000000000
[    0.268617] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.268619] CR2: 0000000000000000 CR3: 0000000213410001 CR4:
00000000003706e0
[    0.268620] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[    0.268621] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[    0.268622] Call Trace:
[    0.268624]  <TASK>
[    0.268627]  ? _raw_spin_lock_irqsave+0x24/0x60
[    0.268632]  ? _raw_spin_unlock_irqrestore+0x23/0x40
[    0.268634]  ? __kthread_parkme+0x36/0x90
[    0.268637]  kthread+0xe5/0x110
[    0.268639]  ? kthread_complete_and_exit+0x20/0x20
[    0.268642]  ret_from_fork+0x1f/0x30
[    0.268647]  </TASK>
[    0.268648] ---[ end trace 0000000000000000 ]---

Ultimately this can crash the kernel, if the following is set:

	/proc/sys/kernel/panic_on_warn

In premature stop, print nothing, as the number is by practical means a
random number. Otherwise, it is an indicator of a bug in the driver, and
therefore print the number of unsanitized pages with pr_err().

Link: https://lore.kernel.org/linux-sgx/20220825051827.246698-1-jarkko@kernel.org/T/#u
Fixes: 51ab30eb2ad4 ("x86/sgx: Replace section->init_laundry_list with sgx_dirty_page_list")
Cc: stable@vger.kernel.org # v5.13+
Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>

v6:
- Address Reinette's feedback:
  https://lore.kernel.org/linux-sgx/Yw6%2FiTzSdSw%2FY%2FVO@kernel.org/

v5:
- Add the klog dump and sysctl option to the commit message.

v4:
- Explain expectations for dirty_page_list in the function header, instead
  of an inline comment.
- Improve commit message to explain the conditions better.
- Return the number of pages left dirty to ksgxd() and print warning after
  the 2nd call, if there are any.

v3:
- Remove WARN_ON().
- Tuned comments and the commit message a bit.

v2:
- Replaced WARN_ON() with optional pr_info() inside
  __sgx_sanitize_pages().
- Rewrote the commit message.
- Added the fixes tag.
---
 arch/x86/kernel/cpu/sgx/main.c | 33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 515e2a5f25bb..f29dcaddd140 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -49,17 +49,23 @@ static LIST_HEAD(sgx_dirty_page_list);
  * Reset post-kexec EPC pages to the uninitialized state. The pages are removed
  * from the input list, and made available for the page allocator. SECS pages
  * prepending their children in the input list are left intact.
+ *
+ * Contents of the @dirty_page_list must be thread-local, i.e.
+ * not shared by multiple threads.
+ *
+ * Return 0 when sanitization was successful or kthread was stopped, and the
+ * number of unsanitized pages otherwise.
  */
-static void __sgx_sanitize_pages(struct list_head *dirty_page_list)
+static unsigned long __sgx_sanitize_pages(struct list_head *dirty_page_list)
 {
 	struct sgx_epc_page *page;
+	long left_dirty = 0;
 	LIST_HEAD(dirty);
 	int ret;
 
-	/* dirty_page_list is thread-local, no need for a lock: */
 	while (!list_empty(dirty_page_list)) {
 		if (kthread_should_stop())
-			return;
+			return 0;
 
 		page = list_first_entry(dirty_page_list, struct sgx_epc_page, list);
 
@@ -92,12 +98,14 @@ static void __sgx_sanitize_pages(struct list_head *dirty_page_list)
 		} else {
 			/* The page is not yet clean - move to the dirty list. */
 			list_move_tail(&page->list, &dirty);
+			left_dirty++;
 		}
 
 		cond_resched();
 	}
 
 	list_splice(&dirty, dirty_page_list);
+	return left_dirty;
 }
 
 static bool sgx_reclaimer_age(struct sgx_epc_page *epc_page)
@@ -388,17 +396,28 @@ void sgx_reclaim_direct(void)
 
 static int ksgxd(void *p)
 {
+	unsigned long left_dirty;
+
 	set_freezable();
 
 	/*
 	 * Sanitize pages in order to recover from kexec(). The 2nd pass is
 	 * required for SECS pages, whose child pages blocked EREMOVE.
 	 */
-	__sgx_sanitize_pages(&sgx_dirty_page_list);
-	__sgx_sanitize_pages(&sgx_dirty_page_list);
+	left_dirty = __sgx_sanitize_pages(&sgx_dirty_page_list);
+	pr_debug("%ld unsanitized pages\n", left_dirty);
 
-	/* sanity check: */
-	WARN_ON(!list_empty(&sgx_dirty_page_list));
+	left_dirty = __sgx_sanitize_pages(&sgx_dirty_page_list);
+	/*
+	 * Never expected to happen in a working driver. If it happens the bug
+	 * is expected to be in the sanitization process, but successfully
+	 * sanitized pages are still valid and driver can be used and most
+	 * importantly debugged without issues. To put short, the global state
+	 * of kernel is not corrupted so no reason to do any more complicated
+	 * rollback.
+	 */
+	if (ret)
+		pr_err("%ld unsanitized pages\n", left_dirty);
 
 	while (!kthread_should_stop()) {
 		if (try_to_freeze())
-- 
2.37.2


--zH23CSNPZKs2jfpL--
