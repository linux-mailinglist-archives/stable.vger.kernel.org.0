Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C566E5ADC24
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 02:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbiIFACd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Sep 2022 20:02:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbiIFACc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Sep 2022 20:02:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF3FC67455;
        Mon,  5 Sep 2022 17:02:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80C61611A0;
        Tue,  6 Sep 2022 00:02:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90616C433D6;
        Tue,  6 Sep 2022 00:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662422550;
        bh=TMJ80vYAbA8KREyvuRGxIHEH4TEzdMwKMX5gDaCaSJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kgHE5mLNRCWUku1TGU9On94pxkwpyY6dwuE30/v/4i1/aw9p6AfBvpP/57H+OGHYB
         o6bCbE1EfvzMx9gUg3k4tzgBYmQ8dHe9IPN5s0424EjjzRggRi+94/K360gzozThZt
         Nytgw4B8lmopSZxty0i2xuFnZeP3hXVwbbtR3slfFRJogtOZlmd5aTUZ4TS7G8977V
         VMv3P2oGArApQ4JbY+pcmIzimq0wmQno1NJG/s1bHa+QU6rBKRIMt2NmN7UwYqcfR/
         wzhruhloRBnzTzAohr7kw9fZxgOL7LaKi5PdQBjqxtx4wu/xy2cBn2kPGrxPYz0kZj
         uiwdN0ttTPq8Q==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     Haitao Huang <haitao.huang@linux.intel.com>,
        Vijay Dhanraj <vijay.dhanraj@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Kai Huang <kai.huang@intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>, stable@vger.kernel.org,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT))
Subject: [PATCH v3 1/2] x86/sgx: Do not fail on incomplete sanitization on premature stop of ksgxd
Date:   Tue,  6 Sep 2022 03:02:20 +0300
Message-Id: <20220906000221.34286-2-jarkko@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220906000221.34286-1-jarkko@kernel.org>
References: <20220906000221.34286-1-jarkko@kernel.org>
MIME-Version: 1.0
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

Unsanitized pages trigger WARN_ON() unconditionally, which can panic the
whole computer, if /proc/sys/kernel/panic_on_warn is set.

In sgx_init(), if misc_register() fails or misc_register() succeeds but
neither sgx_drv_init() nor sgx_vepc_init() succeeds, then ksgxd will be
prematurely stopped. This may leave unsanitized pages, which will result a
false warning.

Refine __sgx_sanitize_pages() to return:

1. Zero when the sanitization process is complete or ksgxd has been
   requested to stop.
2. The number of unsanitized pages otherwise.

Link: https://lore.kernel.org/linux-sgx/20220825051827.246698-1-jarkko@kernel.org/T/#u
Fixes: 51ab30eb2ad4 ("x86/sgx: Replace section->init_laundry_list with sgx_dirty_page_list")
Cc: stable@vger.kernel.org # v5.13+
Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
v9:
- Remove left_dirty declaratio from ksgxd().
- Update commit message.

v8:
- Discard changes that are not relevant for the stable fix. This
  does absolutely minimum to address the bug:
  https://lore.kernel.org/linux-sgx/a5fa56bdc57d6472a306bd8d795afc674b724538.camel@intel.com/

v7:
- Rewrote commit message.
- Do not return -ECANCELED on premature stop. Instead use zero both
  premature stop and complete sanitization.

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
 arch/x86/kernel/cpu/sgx/main.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 515e2a5f25bb..0aad028f04d4 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -49,9 +49,13 @@ static LIST_HEAD(sgx_dirty_page_list);
  * Reset post-kexec EPC pages to the uninitialized state. The pages are removed
  * from the input list, and made available for the page allocator. SECS pages
  * prepending their children in the input list are left intact.
+ *
+ * Return 0 when sanitization was successful or kthread was stopped, and the
+ * number of unsanitized pages otherwise.
  */
-static void __sgx_sanitize_pages(struct list_head *dirty_page_list)
+static unsigned long __sgx_sanitize_pages(struct list_head *dirty_page_list)
 {
+	unsigned long left_dirty = 0;
 	struct sgx_epc_page *page;
 	LIST_HEAD(dirty);
 	int ret;
@@ -59,7 +63,7 @@ static void __sgx_sanitize_pages(struct list_head *dirty_page_list)
 	/* dirty_page_list is thread-local, no need for a lock: */
 	while (!list_empty(dirty_page_list)) {
 		if (kthread_should_stop())
-			return;
+			return 0;
 
 		page = list_first_entry(dirty_page_list, struct sgx_epc_page, list);
 
@@ -92,12 +96,14 @@ static void __sgx_sanitize_pages(struct list_head *dirty_page_list)
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
@@ -395,10 +401,7 @@ static int ksgxd(void *p)
 	 * required for SECS pages, whose child pages blocked EREMOVE.
 	 */
 	__sgx_sanitize_pages(&sgx_dirty_page_list);
-	__sgx_sanitize_pages(&sgx_dirty_page_list);
-
-	/* sanity check: */
-	WARN_ON(!list_empty(&sgx_dirty_page_list));
+	WARN_ON(__sgx_sanitize_pages(&sgx_dirty_page_list));
 
 	while (!kthread_should_stop()) {
 		if (try_to_freeze())
-- 
2.37.2

