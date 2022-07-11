Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6022656FD3A
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233951AbiGKJwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233270AbiGKJwB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:52:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF32ACEE5;
        Mon, 11 Jul 2022 02:25:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F04706124E;
        Mon, 11 Jul 2022 09:25:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9261C34115;
        Mon, 11 Jul 2022 09:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531510;
        bh=9K04RVcc5+Of6dPmUZUF7MfhV/bdoktf5T5hjkB0ntw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eXC9+49lgVNTgEhlxEohSlTfn5cog2wd29rOWzRTLSYtks6fzG3xWY98eg5xbQ9/J
         E//BuVMT5nsJpvW7jJALjtX+i1CRJza+R9FJgXFqpFsaCuuWmcxNf83jeydohP4RU7
         H+8dSmjwEam0cLaLUyYAp9ffsuz1LI85Jr9xt8oE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Yang Shi <shy828301@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 129/230] mm/memory-failure.c: fix race with changing page compound again
Date:   Mon, 11 Jul 2022 11:06:25 +0200
Message-Id: <20220711090607.725243061@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

[ Upstream commit 888af2701db79b9b27c7e37f9ede528a5ca53b76 ]

Patch series "A few fixup patches for memory failure", v2.

This series contains a few patches to fix the race with changing page
compound page, make non-LRU movable pages unhandlable and so on.  More
details can be found in the respective changelogs.

There is a race window where we got the compound_head, the hugetlb page
could be freed to buddy, or even changed to another compound page just
before we try to get hwpoison page.  Think about the below race window:

  CPU 1					  CPU 2
  memory_failure_hugetlb
  struct page *head = compound_head(p);
					  hugetlb page might be freed to
					  buddy, or even changed to another
					  compound page.

  get_hwpoison_page -- page is not what we want now...

If this race happens, just bail out.  Also MF_MSG_DIFFERENT_PAGE_SIZE is
introduced to record this event.

[akpm@linux-foundation.org: s@/**@/*@, per Naoya Horiguchi]

Link: https://lkml.kernel.org/r/20220312074613.4798-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20220312074613.4798-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mm.h      |  1 +
 include/ras/ras_event.h |  1 +
 mm/memory-failure.c     | 12 ++++++++++++
 3 files changed, 14 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 85205adcdd0d..7a80a08eec84 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3167,6 +3167,7 @@ enum mf_action_page_type {
 	MF_MSG_BUDDY_2ND,
 	MF_MSG_DAX,
 	MF_MSG_UNSPLIT_THP,
+	MF_MSG_DIFFERENT_PAGE_SIZE,
 	MF_MSG_UNKNOWN,
 };
 
diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
index 0bdbc0d17d2f..cac13ff1d6eb 100644
--- a/include/ras/ras_event.h
+++ b/include/ras/ras_event.h
@@ -376,6 +376,7 @@ TRACE_EVENT(aer_event,
 	EM ( MF_MSG_BUDDY_2ND, "free buddy page (2nd try)" )		\
 	EM ( MF_MSG_DAX, "dax page" )					\
 	EM ( MF_MSG_UNSPLIT_THP, "unsplit thp" )			\
+	EM ( MF_MSG_DIFFERENT_PAGE_SIZE, "different page size" )	\
 	EMe ( MF_MSG_UNKNOWN, "unknown page" )
 
 /*
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 5664bafd5e77..a4d70c21c146 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -741,6 +741,7 @@ static const char * const action_page_types[] = {
 	[MF_MSG_BUDDY_2ND]		= "free buddy page (2nd try)",
 	[MF_MSG_DAX]			= "dax page",
 	[MF_MSG_UNSPLIT_THP]		= "unsplit thp",
+	[MF_MSG_DIFFERENT_PAGE_SIZE]	= "different page size",
 	[MF_MSG_UNKNOWN]		= "unknown page",
 };
 
@@ -1461,6 +1462,17 @@ static int memory_failure_hugetlb(unsigned long pfn, int flags)
 	}
 
 	lock_page(head);
+
+	/*
+	 * The page could have changed compound pages due to race window.
+	 * If this happens just bail out.
+	 */
+	if (!PageHuge(p) || compound_head(p) != head) {
+		action_result(pfn, MF_MSG_DIFFERENT_PAGE_SIZE, MF_IGNORED);
+		res = -EBUSY;
+		goto out;
+	}
+
 	page_flags = head->flags;
 
 	/*
-- 
2.35.1



