Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 284DC579973
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238011AbiGSMC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237683AbiGSMCb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:02:31 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A8644B0EC;
        Tue, 19 Jul 2022 04:59:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 10A53CE1BDE;
        Tue, 19 Jul 2022 11:59:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C706FC341C6;
        Tue, 19 Jul 2022 11:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658231941;
        bh=8HYYKt81U3yopv59wRFpeEcTzqA00jt5nUVMcNaANm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1RxgzMnan1ZeM1bt93st5z31kMPT8vXl/gsgc+7Jwkcy00EF2qqo8MTgNdfRMueKi
         EfvENAzIMW4SvsgwGpcTpo7cTLFuUglpTZvHIXa7YbxrZMAypvW9on9Zb2hZotww5d
         shFfXBuytJTkV8Gm/C1xNESrQHbdU3Ob5YwnXwLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rik van Riel <riel@surriel.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Oscar Salvador <osalvador@suse.de>,
        John Hubbard <jhubbard@nvidia.com>,
        Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.14 42/43] mm: invalidate hwpoison page cache page in fault path
Date:   Tue, 19 Jul 2022 13:54:13 +0200
Message-Id: <20220719114525.516672930@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114521.868169025@linuxfoundation.org>
References: <20220719114521.868169025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rik van Riel <riel@surriel.com>

commit e53ac7374e64dede04d745ff0e70ff5048378d1f upstream.

Sometimes the page offlining code can leave behind a hwpoisoned clean
page cache page.  This can lead to programs being killed over and over
and over again as they fault in the hwpoisoned page, get killed, and
then get re-spawned by whatever wanted to run them.

This is particularly embarrassing when the page was offlined due to
having too many corrected memory errors.  Now we are killing tasks due
to them trying to access memory that probably isn't even corrupted.

This problem can be avoided by invalidating the page from the page fault
handler, which already has a branch for dealing with these kinds of
pages.  With this patch we simply pretend the page fault was successful
if the page was invalidated, return to userspace, incur another page
fault, read in the file from disk (to a new memory page), and then
everything works again.

Link: https://lkml.kernel.org/r/20220212213740.423efcea@imladris.surriel.com
Signed-off-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[sudip: use int instead of vm_fault_t]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3342,11 +3342,16 @@ static int __do_fault(struct vm_fault *v
 		return ret;
 
 	if (unlikely(PageHWPoison(vmf->page))) {
-		if (ret & VM_FAULT_LOCKED)
+		int poisonret = VM_FAULT_HWPOISON;
+		if (ret & VM_FAULT_LOCKED) {
+			/* Retry if a clean page was removed from the cache. */
+			if (invalidate_inode_page(vmf->page))
+				poisonret = 0;
 			unlock_page(vmf->page);
+		}
 		put_page(vmf->page);
 		vmf->page = NULL;
-		return VM_FAULT_HWPOISON;
+		return poisonret;
 	}
 
 	if (unlikely(!(ret & VM_FAULT_LOCKED)))


