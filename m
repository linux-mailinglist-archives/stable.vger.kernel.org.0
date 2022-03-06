Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7B84CEA25
	for <lists+stable@lfdr.de>; Sun,  6 Mar 2022 10:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbiCFJGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Mar 2022 04:06:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbiCFJGQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Mar 2022 04:06:16 -0500
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C9E355759
        for <stable@vger.kernel.org>; Sun,  6 Mar 2022 01:05:24 -0800 (PST)
Received: by mail-qk1-x731.google.com with SMTP id b13so9742591qkj.12
        for <stable@vger.kernel.org>; Sun, 06 Mar 2022 01:05:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=TRvVg/QqU9hBjOyhICZFUAABJ+Msd6HOEwv/V8roqv0=;
        b=mEg6BYGC1G8OobksDAbWxRa1ILz09bxr4XCB2/ijRlu705TNTMbGWiF5bcK1qXKljX
         fscNiWp7or4rMWNCSwN4MnXupYkPlHieOsjXLFqsC9BhSLdRobM1VwlXFhVEdSNvgICG
         LcJ+cvSSZdX0VoRAD+Fx86Fw/eW7u+0iRyrUSmR7f/TdT9IglvpEpLSZYCH1N/XhFtJN
         fW7ouMvGaTNMJ5xq6+lB8LRtJfisBpSF32IwiKzhIZa8luz5cShm60QZTbPT3g/L1Z95
         Gdxx9rhVYKP7X9wZj4V2vLo+6XFEpwuIfZ9jie7KNcDuy0OxxybWdM/uYSM2hFodvuS5
         63Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:mime-version;
        bh=TRvVg/QqU9hBjOyhICZFUAABJ+Msd6HOEwv/V8roqv0=;
        b=IV1hkycV6EZsjH5+cElaeaMcPwD6tCTq/6aiKsuNqrlejf9hEalX6jTFmkZ9qBm0jF
         End4V9P1273uteDZ8dBwmhIwD02IuujuPOyQCPtenuqz8SUonrfrwxfPQwIfyAejVluU
         PUz2Nke3Q7Cg1R0+n0P1/FqoXyXbVYqlMcVJcAKbU0pgxrfLZRUd0Lao0czvOV7ORXZP
         jmV01+wQv2RSifbL8QRPahsQV9kNqRN1anllKOcODBF9xD10hjwcGDcAHsSvedPlAAkV
         5d5LA4MKxyqfRn4o7TG1urQehIiYdUNBhWVphRId5oz5gcbS3ai1eAS0zQ1YbexmQJf3
         7Y4Q==
X-Gm-Message-State: AOAM531WvNF9ah6UUv0mX6bpWq+gccWJKmSsDWyXrMv/zXinv31+2VeO
        ghfqujfnCUV6OIRn6bNcRGxOYA==
X-Google-Smtp-Source: ABdhPJzkCbSHTalZdM3O8nT5RhFtNJIlilde7UHJQPWk0h7eewgpTaLyoM0br6HOENhWNZqR64LfoA==
X-Received: by 2002:a05:620a:191b:b0:67b:1436:7f98 with SMTP id bj27-20020a05620a191b00b0067b14367f98mr854286qkb.256.1646557523201;
        Sun, 06 Mar 2022 01:05:23 -0800 (PST)
Received: from ripple.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id y17-20020a05622a121100b002e05657e88dsm3030218qtx.0.2022.03.06.01.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 01:05:22 -0800 (PST)
Date:   Sun, 6 Mar 2022 01:05:09 -0800 (PST)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@ripple.anvils
To:     gregkh@linuxfoundation.org
cc:     akpm@linux-foundation.org, cgel.zte@gmail.com, hughd@google.com,
        kirill@shutemov.name, mike.kravetz@oracle.com,
        songliubraving@fb.com, torvalds@linux-foundation.org,
        wang.yong12@zte.com.cn, willy@infradead.org,
        yang.yang29@zte.com.cn, zealci@zte.com.cn, yongw.pur@gmail.com,
        stable@vger.kernel.org
Subject: Re: Patch "memfd: fix F_SEAL_WRITE after shmem huge page allocated"
 has been added to the 5.4-stable tree
In-Reply-To: <1646512773164108@kroah.com>
Message-ID: <a54af58e-def-62fb-4f51-76bc093bbd2@google.com>
References: <1646512773164108@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 5 Mar 2022, gregkh@linuxfoundation.org wrote:
> 
> This is a note to let you know that I've just added the patch titled
> 
>     memfd: fix F_SEAL_WRITE after shmem huge page allocated
> 
> to the 5.4-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      memfd-fix-f_seal_write-after-shmem-huge-page-allocated.patch
> and it can be found in the queue-5.4 subdirectory.

Thank you for adding that patch to 5.16, 5.15, 5.10 and 5.4:
please accept the substitute patch below for 4.19 - thanks.
A different patch will follow for 4.14 and 4.9.

From f2b277c4d1c63a85127e8aa2588e9cc3bd21cb99 Mon Sep 17 00:00:00 2001
From: Hugh Dickins <hughd@google.com>
Date: Fri, 4 Mar 2022 20:29:01 -0800
Subject: memfd: fix F_SEAL_WRITE after shmem huge page allocated

From: Hugh Dickins <hughd@google.com>

commit f2b277c4d1c63a85127e8aa2588e9cc3bd21cb99 upstream.

Wangyong reports: after enabling tmpfs filesystem to support transparent
hugepage with the following command:

  echo always > /sys/kernel/mm/transparent_hugepage/shmem_enabled

the docker program tries to add F_SEAL_WRITE through the following
command, but it fails unexpectedly with errno EBUSY:

  fcntl(5, F_ADD_SEALS, F_SEAL_WRITE) = -1.

That is because memfd_tag_pins() and memfd_wait_for_pins() were never
updated for shmem huge pages: checking page_mapcount() against
page_count() is hopeless on THP subpages - they need to check
total_mapcount() against page_count() on THP heads only.

Make memfd_tag_pins() (compared > 1) as strict as memfd_wait_for_pins()
(compared != 1): either can be justified, but given the non-atomic
total_mapcount() calculation, it is better now to be strict.  Bear in
mind that total_mapcount() itself scans all of the THP subpages, when
choosing to take an XA_CHECK_SCHED latency break.

Also fix the unlikely xa_is_value() case in memfd_wait_for_pins(): if a
page has been swapped out since memfd_tag_pins(), then its refcount must
have fallen, and so it can safely be untagged.

Link: https://lkml.kernel.org/r/a4f79248-df75-2c8c-3df-ba3317ccb5da@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Zeal Robot <zealci@zte.com.cn>
Reported-by: wangyong <wang.yong12@zte.com.cn>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: CGEL ZTE <cgel.zte@gmail.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 mm/memfd.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -34,26 +34,35 @@ static void memfd_tag_pins(struct address_space *mapping)
 	void __rcu **slot;
 	pgoff_t start;
 	struct page *page;
-	unsigned int tagged = 0;
+	int latency = 0;
+	int cache_count;
 
 	lru_add_drain();
 	start = 0;
 
 	xa_lock_irq(&mapping->i_pages);
 	radix_tree_for_each_slot(slot, &mapping->i_pages, &iter, start) {
+		cache_count = 1;
 		page = radix_tree_deref_slot_protected(slot, &mapping->i_pages.xa_lock);
-		if (!page || radix_tree_exception(page)) {
+		if (!page || radix_tree_exception(page) || PageTail(page)) {
 			if (radix_tree_deref_retry(page)) {
 				slot = radix_tree_iter_retry(&iter);
 				continue;
 			}
-		} else if (page_count(page) - page_mapcount(page) > 1) {
-			radix_tree_tag_set(&mapping->i_pages, iter.index,
-					   MEMFD_TAG_PINNED);
+		} else {
+			if (PageTransHuge(page) && !PageHuge(page))
+				cache_count = HPAGE_PMD_NR;
+			if (cache_count !=
+			    page_count(page) - total_mapcount(page)) {
+				radix_tree_tag_set(&mapping->i_pages,
+						iter.index, MEMFD_TAG_PINNED);
+			}
 		}
 
-		if (++tagged % 1024)
+		latency += cache_count;
+		if (latency < 1024)
 			continue;
+		latency = 0;
 
 		slot = radix_tree_iter_resume(slot, &iter);
 		xa_unlock_irq(&mapping->i_pages);
@@ -79,6 +88,7 @@ static int memfd_wait_for_pins(struct address_space *mapping)
 	pgoff_t start;
 	struct page *page;
 	int error, scan;
+	int cache_count;
 
 	memfd_tag_pins(mapping);
 
@@ -107,8 +117,12 @@ static int memfd_wait_for_pins(struct address_space *mapping)
 				page = NULL;
 			}
 
-			if (page &&
-			    page_count(page) - page_mapcount(page) != 1) {
+			cache_count = 1;
+			if (page && PageTransHuge(page) && !PageHuge(page))
+				cache_count = HPAGE_PMD_NR;
+
+			if (page && cache_count !=
+			    page_count(page) - total_mapcount(page)) {
 				if (scan < LAST_SCAN)
 					goto continue_resched;
 
