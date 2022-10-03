Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E17B5F2953
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbiJCHRr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbiJCHQq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:16:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CCDA46604;
        Mon,  3 Oct 2022 00:13:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF1F660F9C;
        Mon,  3 Oct 2022 07:13:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0167CC433C1;
        Mon,  3 Oct 2022 07:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781232;
        bh=WH8xXGMb++7ru7vAHuHr8eK/naEzy0QN+TcJ34WR0qw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JMWfcZYh23t+vT5K/IkC3vGLJkXNJscPk1GdCzW2kLFifPynFaRhe/5GP+oiS1lJl
         jvn+FF+MQcbIUEb/cB5kMEQQK5pPk050YnXJ0GYA6W8E8ulbUz+JJVAxqqFxkRDRoy
         e3QVb8cdK06Ra2gR3FtuFBnsUy8B5mB21vVl0R8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Oscar Salvador <osalvador@suse.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.19 045/101] mm/hugetlb: correct demote page offset logic
Date:   Mon,  3 Oct 2022 09:10:41 +0200
Message-Id: <20221003070725.581159438@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
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

From: Doug Berger <opendmb@gmail.com>

commit 317314527d173e1f139ceaf8cb87cb1746abf240 upstream.

With gigantic pages it may not be true that struct page structures are
contiguous across the entire gigantic page.  The nth_page macro is used
here in place of direct pointer arithmetic to correct for this.

Mike said:

: This error could cause addressing exceptions.  However, this is only
: possible in configurations where CONFIG_SPARSEMEM &&
: !CONFIG_SPARSEMEM_VMEMMAP.  Such a configuration option is rare and
: unknown to be the default anywhere.

Link: https://lkml.kernel.org/r/20220914190917.3517663-1-opendmb@gmail.com
Fixes: 8531fc6f52f5 ("hugetlb: add hugetlb demote page support")
Signed-off-by: Doug Berger <opendmb@gmail.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3418,6 +3418,7 @@ static int demote_free_huge_page(struct
 {
 	int i, nid = page_to_nid(page);
 	struct hstate *target_hstate;
+	struct page *subpage;
 	int rc = 0;
 
 	target_hstate = size_to_hstate(PAGE_SIZE << h->demote_order);
@@ -3451,15 +3452,16 @@ static int demote_free_huge_page(struct
 	mutex_lock(&target_hstate->resize_lock);
 	for (i = 0; i < pages_per_huge_page(h);
 				i += pages_per_huge_page(target_hstate)) {
+		subpage = nth_page(page, i);
 		if (hstate_is_gigantic(target_hstate))
-			prep_compound_gigantic_page_for_demote(page + i,
+			prep_compound_gigantic_page_for_demote(subpage,
 							target_hstate->order);
 		else
-			prep_compound_page(page + i, target_hstate->order);
-		set_page_private(page + i, 0);
-		set_page_refcounted(page + i);
-		prep_new_huge_page(target_hstate, page + i, nid);
-		put_page(page + i);
+			prep_compound_page(subpage, target_hstate->order);
+		set_page_private(subpage, 0);
+		set_page_refcounted(subpage);
+		prep_new_huge_page(target_hstate, subpage, nid);
+		put_page(subpage);
 	}
 	mutex_unlock(&target_hstate->resize_lock);
 


