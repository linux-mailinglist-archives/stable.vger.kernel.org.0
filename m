Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB1F5B3C08
	for <lists+stable@lfdr.de>; Fri,  9 Sep 2022 17:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbiIIPdr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Sep 2022 11:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232375AbiIIPdF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Sep 2022 11:33:05 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26428103065;
        Fri,  9 Sep 2022 08:32:47 -0700 (PDT)
Date:   Fri, 09 Sep 2022 15:31:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1662737479;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k9FDm3Ib1dQyrhUGRzp0xqUKNj7z1QvqPgHlgBP29rA=;
        b=m6HD0wjw6zgEALpojXyv9ZtWUmLrkdKSVJMz6a01Nafm+QRfheuaTqWRy+vkO9fJT63JRx
        DbtWzJtV3fU/uz74hy2Qx24qQuAVfd4+y7RF2tCDHyuqiIOQffscoMNawQT0iqCKPb2Y6i
        YyxwNKy/gVTPcjWIP+W3AVJMzu4c88lrlnl7R19mFgEC98WD9zp3GbhBRDvlaRAmg62mOM
        AekcC2ejHvj5vT7RUGB2bgwdMI99H6bXt83TEPCYISiAtGWXv3RicEHNq4JYWg/acjFatO
        O+n7PapzTI4HUyZlzfYrbEshpV5CTvf4YSdAmwqCeMKdZk5/NgTHfGM8L1wMpg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1662737479;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k9FDm3Ib1dQyrhUGRzp0xqUKNj7z1QvqPgHlgBP29rA=;
        b=th3aBRkJ0iv8aqqv8loZwL69ruUc9pIBypLX7ODyccQJgdQG3E+EG4XgZc6sjUkVKlLxxh
        JkD+ZFtbATANxCAg==
From:   "tip-bot2 for Jarkko Sakkinen" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/sgx: Do not fail on incomplete sanitization on
 premature stop of ksgxd
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20220906000221.34286-2-jarkko@kernel.org>
References: <20220906000221.34286-2-jarkko@kernel.org>
MIME-Version: 1.0
Message-ID: <166273747840.401.14241387909242643974.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     133e049a3f8c91b175029fb6a59b6039d5e79cba
Gitweb:        https://git.kernel.org/tip/133e049a3f8c91b175029fb6a59b6039d5e79cba
Author:        Jarkko Sakkinen <jarkko@kernel.org>
AuthorDate:    Tue, 06 Sep 2022 03:02:20 +03:00
Committer:     Dave Hansen <dave.hansen@linux.intel.com>
CommitterDate: Thu, 08 Sep 2022 13:27:44 -07:00

x86/sgx: Do not fail on incomplete sanitization on premature stop of ksgxd

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

Fixes: 51ab30eb2ad4 ("x86/sgx: Replace section->init_laundry_list with sgx_dirty_page_list")
Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-sgx/20220825051827.246698-1-jarkko@kernel.org/T/#u
Link: https://lkml.kernel.org/r/20220906000221.34286-2-jarkko@kernel.org
---
 arch/x86/kernel/cpu/sgx/main.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 515e2a5..0aad028 100644
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
