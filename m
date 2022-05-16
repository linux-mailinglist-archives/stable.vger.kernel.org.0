Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81A37528F9E
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348088AbiEPUGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348876AbiEPT7B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:59:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97BABDF10;
        Mon, 16 May 2022 12:51:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3362360ABE;
        Mon, 16 May 2022 19:51:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2332CC385AA;
        Mon, 16 May 2022 19:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730705;
        bh=xeK6HRxi1mPhpbtlWLLpg+A8vnqO0N4E6B3fLZdB0xw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ffp/RtRGNdeLSduB+03h4TXnRwqbWqzlXPmARafLLnAEt9sj0UYBq0jkNe0dMOrvg
         urlqwmAGBb7aMh0UycQn7GwEevtNs9AliWEusXIF9Qpl3AuVX8FgdmVwdtSN5oH0cO
         KKyMxDaGDWxTOx06C912jXwcPfkQ1vd2MXrVdQ68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xu Yu <xuyu@linux.alibaba.com>,
        Yang Shi <shy828301@gmail.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 082/102] Revert "mm/memory-failure.c: skip huge_zero_page in memory_failure()"
Date:   Mon, 16 May 2022 21:36:56 +0200
Message-Id: <20220516193626.346807892@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193623.989270214@linuxfoundation.org>
References: <20220516193623.989270214@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xu Yu <xuyu@linux.alibaba.com>

commit b4e61fc031b11dd807dffc46cebbf0e25966d3d1 upstream.

Patch series "mm/memory-failure: rework fix on huge_zero_page splitting".


This patch (of 2):

This reverts commit d173d5417fb67411e623d394aab986d847e47dad.

The commit d173d5417fb6 ("mm/memory-failure.c: skip huge_zero_page in
memory_failure()") explicitly skips huge_zero_page in memory_failure(), in
order to avoid triggering VM_BUG_ON_PAGE on huge_zero_page in
split_huge_page_to_list().

This works, but Yang Shi thinks that,

    Raising BUG is overkilling for splitting huge_zero_page. The
    huge_zero_page can't be met from normal paths other than memory
    failure, but memory failure is a valid caller. So I tend to replace
    the BUG to WARN + returning -EBUSY. If we don't care about the
    reason code in memory failure, we don't have to touch memory
    failure.

And for the issue that huge_zero_page will be set PG_has_hwpoisoned,
Yang Shi comments that,

    The anonymous page fault doesn't check if the page is poisoned or
    not since it typically gets a fresh allocated page and assumes the
    poisoned page (isolated successfully) can't be reallocated again.
    But huge zero page and base zero page are reused every time. So no
    matter what fix we pick, the issue is always there.

Finally, Yang, David, Anshuman and Naoya all agree to fix the bug, i.e.,
to split huge_zero_page, in split_huge_page_to_list().

This reverts the commit d173d5417fb6 ("mm/memory-failure.c: skip
huge_zero_page in memory_failure()"), and the original bug will be fixed
by the next patch.

Link: https://lkml.kernel.org/r/872cefb182ba1dd686b0e7db1e6b2ebe5a4fff87.1651039624.git.xuyu@linux.alibaba.com
Fixes: d173d5417fb6 ("mm/memory-failure.c: skip huge_zero_page in memory_failure()")
Fixes: 6a46079cf57a ("HWPOISON: The high level memory error handler in the VM v7")
Signed-off-by: Xu Yu <xuyu@linux.alibaba.com>
Suggested-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory-failure.c |   13 -------------
 1 file changed, 13 deletions(-)

--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1692,19 +1692,6 @@ try_again:
 
 	if (PageTransHuge(hpage)) {
 		/*
-		 * Bail out before SetPageHasHWPoisoned() if hpage is
-		 * huge_zero_page, although PG_has_hwpoisoned is not
-		 * checked in set_huge_zero_page().
-		 *
-		 * TODO: Handle memory failure of huge_zero_page thoroughly.
-		 */
-		if (is_huge_zero_page(hpage)) {
-			action_result(pfn, MF_MSG_UNSPLIT_THP, MF_IGNORED);
-			res = -EBUSY;
-			goto unlock_mutex;
-		}
-
-		/*
 		 * The flag must be set after the refcount is bumped
 		 * otherwise it may race with THP split.
 		 * And the flag can't be set in get_hwpoison_page() since


