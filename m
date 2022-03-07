Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFE64CF520
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236647AbiCGJYg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:24:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237385AbiCGJXz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:23:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C64654F89;
        Mon,  7 Mar 2022 01:23:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48749B80E70;
        Mon,  7 Mar 2022 09:23:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7747BC340E9;
        Mon,  7 Mar 2022 09:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646644979;
        bh=9k9TnfFJxozCmdGaI4LQIZC5djFmfCDCM4ic8RTYkgs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TdmY04xYnW6AyTlJuJHq6eyNKYR9jVYEHG13iLjHc5nZMqMn55R63uCYiu7eF3T1e
         fiHMhcnAJWQoPDc3uxfspxxLfFTkjVCI7EkcJfCon0VuokGG8O50ro7JdHZPq8cUJj
         sP52WxhiQ6QvLgF4lYqBtE1a1yRyzrZu6lqjl9m0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Zeal Robot <zealci@zte.com.cn>,
        wangyong <wang.yong12@zte.com.cn>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        CGEL ZTE <cgel.zte@gmail.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Song Liu <songliubraving@fb.com>,
        Yang Yang <yang.yang29@zte.com.cn>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 41/42] memfd: fix F_SEAL_WRITE after shmem huge page allocated
Date:   Mon,  7 Mar 2022 10:19:15 +0100
Message-Id: <20220307091637.348617653@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091636.146155347@linuxfoundation.org>
References: <20220307091636.146155347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/shmem.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2689,7 +2689,8 @@ static void shmem_tag_pins(struct addres
 				slot = radix_tree_iter_retry(&iter);
 				continue;
 			}
-		} else if (page_count(page) - page_mapcount(page) > 1) {
+		} else if (!PageTail(page) && page_count(page) !=
+			   hpage_nr_pages(page) + total_mapcount(page)) {
 			radix_tree_tag_set(&mapping->page_tree, iter.index,
 					   SHMEM_TAG_PINNED);
 		}
@@ -2749,8 +2750,8 @@ static int shmem_wait_for_pins(struct ad
 				page = NULL;
 			}
 
-			if (page &&
-			    page_count(page) - page_mapcount(page) != 1) {
+			if (page && page_count(page) !=
+			    hpage_nr_pages(page) + total_mapcount(page)) {
 				if (scan < LAST_SCAN)
 					goto continue_resched;
 


