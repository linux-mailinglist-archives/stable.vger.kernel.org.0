Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB57456FE32
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 12:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234460AbiGKKFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 06:05:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233909AbiGKKDh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 06:03:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7074D66AFC;
        Mon, 11 Jul 2022 02:29:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 020A161411;
        Mon, 11 Jul 2022 09:29:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11603C34115;
        Mon, 11 Jul 2022 09:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531784;
        bh=t9YP5Tngn5X3VBS+MR/tAb2ZKRQvST36CAK14z8o50Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0MIh8IgOWwcyRU+BLwu/3VvBkcDQonJd2yfZdSgD80leERKtdz1C/UOxA8w7FTba8
         RwazltTILfzPPLP8enyuFwJLKTDp5oL1yinQOy6vkNeLJHR85530EiMGJGD9Gi1HZw
         yeKFM0ZVOb/mExWN3CSFCt/e4j0Esa85AN907+rA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Yang Shi <shy828301@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 219/230] Revert "mm/memory-failure.c: fix race with changing page compound again"
Date:   Mon, 11 Jul 2022 11:07:55 +0200
Message-Id: <20220711090610.314638268@linuxfoundation.org>
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

From: Naoya Horiguchi <naoya.horiguchi@nec.com>

commit 2ba2b008a8bf5fd268a43d03ba79e0ad464d6836 upstream.

Reverts commit 888af2701db7 ("mm/memory-failure.c: fix race with changing
page compound again") because now we fetch the page refcount under
hugetlb_lock in try_memory_failure_hugetlb() so that the race check is no
longer necessary.

Link: https://lkml.kernel.org/r/20220408135323.1559401-4-naoya.horiguchi@linux.dev
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Suggested-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mm.h      |    1 -
 include/ras/ras_event.h |    1 -
 mm/memory-failure.c     |   11 -----------
 3 files changed, 13 deletions(-)

--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3175,7 +3175,6 @@ enum mf_action_page_type {
 	MF_MSG_BUDDY_2ND,
 	MF_MSG_DAX,
 	MF_MSG_UNSPLIT_THP,
-	MF_MSG_DIFFERENT_PAGE_SIZE,
 	MF_MSG_UNKNOWN,
 };
 
--- a/include/ras/ras_event.h
+++ b/include/ras/ras_event.h
@@ -376,7 +376,6 @@ TRACE_EVENT(aer_event,
 	EM ( MF_MSG_BUDDY_2ND, "free buddy page (2nd try)" )		\
 	EM ( MF_MSG_DAX, "dax page" )					\
 	EM ( MF_MSG_UNSPLIT_THP, "unsplit thp" )			\
-	EM ( MF_MSG_DIFFERENT_PAGE_SIZE, "different page size" )	\
 	EMe ( MF_MSG_UNKNOWN, "unknown page" )
 
 /*
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -741,7 +741,6 @@ static const char * const action_page_ty
 	[MF_MSG_BUDDY_2ND]		= "free buddy page (2nd try)",
 	[MF_MSG_DAX]			= "dax page",
 	[MF_MSG_UNSPLIT_THP]		= "unsplit thp",
-	[MF_MSG_DIFFERENT_PAGE_SIZE]	= "different page size",
 	[MF_MSG_UNKNOWN]		= "unknown page",
 };
 
@@ -1526,16 +1525,6 @@ retry:
 		return res == MF_RECOVERED ? 0 : -EBUSY;
 	}
 
-	/*
-	 * The page could have changed compound pages due to race window.
-	 * If this happens just bail out.
-	 */
-	if (!PageHuge(p) || compound_head(p) != head) {
-		action_result(pfn, MF_MSG_DIFFERENT_PAGE_SIZE, MF_IGNORED);
-		res = -EBUSY;
-		goto out;
-	}
-
 	page_flags = head->flags;
 
 	/*


