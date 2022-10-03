Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB0B65F2C71
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 10:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbiJCIwS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 04:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbiJCIvv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 04:51:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9756C5A8AE;
        Mon,  3 Oct 2022 01:35:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EFCCDB80E6F;
        Mon,  3 Oct 2022 07:17:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67261C433D6;
        Mon,  3 Oct 2022 07:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781426;
        bh=yk41U2/x1V1jtnOx1oAS+KXJCG6Br0e4E/NOlvbPDTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yxtSLWW5PdKIGJjQxcO2DiMay9Eqk0h0kvKqgu8X3mIUSvw0GdkftiqNJyHFvO29O
         w8QrN1mgGWiiszoa59pY8POA4oOr9YdrhbjFfh10pAKCTQ92eAUE0xNcNG9qd8qsDa
         GT3/bSqd6QuBuNMZ+KmyeLpMn1YlEhlm4uzgcLm0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Menzel <pmenzel@molgen.mpg.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 5.15 16/83] x86/sgx: Do not fail on incomplete sanitization on premature stop of ksgxd
Date:   Mon,  3 Oct 2022 09:10:41 +0200
Message-Id: <20221003070722.390669625@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
References: <20221003070721.971297651@linuxfoundation.org>
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

From: Jarkko Sakkinen <jarkko@kernel.org>

commit 133e049a3f8c91b175029fb6a59b6039d5e79cba upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/sgx/main.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -46,9 +46,13 @@ static LIST_HEAD(sgx_dirty_page_list);
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
@@ -56,7 +60,7 @@ static void __sgx_sanitize_pages(struct
 	/* dirty_page_list is thread-local, no need for a lock: */
 	while (!list_empty(dirty_page_list)) {
 		if (kthread_should_stop())
-			return;
+			return 0;
 
 		page = list_first_entry(dirty_page_list, struct sgx_epc_page, list);
 
@@ -71,12 +75,14 @@ static void __sgx_sanitize_pages(struct
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
@@ -427,10 +433,7 @@ static int ksgxd(void *p)
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


