Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8175489CB
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353060AbiFMLWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353959AbiFMLUU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:20:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073CC3BFA2;
        Mon, 13 Jun 2022 03:42:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D27D9611E6;
        Mon, 13 Jun 2022 10:42:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDEB4C34114;
        Mon, 13 Jun 2022 10:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116920;
        bh=PUTPjROtLyVNT58smec3UBqX9VYk+lysdAUTKWyczE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wDKQWgVROrMLM7gsVmig1zVKb5S3wv94/mAqa4FxXvvQLmzneey0yQPWGtQcO5KVM
         U6l0Gm5s45DBPFH22aDvLW42XxZFM7iJdyaY5vMobrhv/mWvJiQ92dM6n4sqwpxDpD
         7KTm6a33RBdRe1S1UaAucThkWzmuh0ARcngvwdSI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rei Yamamoto <yamamoto.rei@jp.fujitsu.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Oscar Salvador <osalvador@suse.de>,
        Don Dutile <ddutile@redhat.com>,
        Wonhyuk Yang <vvghjk1234@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.4 233/411] mm, compaction: fast_find_migrateblock() should return pfn in the target zone
Date:   Mon, 13 Jun 2022 12:08:26 +0200
Message-Id: <20220613094935.773417425@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rei Yamamoto <yamamoto.rei@jp.fujitsu.com>

commit bbe832b9db2e1ad21522f8f0bf02775fff8a0e0e upstream.

At present, pages not in the target zone are added to cc->migratepages
list in isolate_migratepages_block().  As a result, pages may migrate
between nodes unintentionally.

This would be a serious problem for older kernels without commit
a984226f457f849e ("mm: memcontrol: remove the pgdata parameter of
mem_cgroup_page_lruvec"), because it can corrupt the lru list by
handling pages in list without holding proper lru_lock.

Avoid returning a pfn outside the target zone in the case that it is
not aligned with a pageblock boundary.  Otherwise
isolate_migratepages_block() will handle pages not in the target zone.

Link: https://lkml.kernel.org/r/20220511044300.4069-1-yamamoto.rei@jp.fujitsu.com
Fixes: 70b44595eafe ("mm, compaction: use free lists to quickly locate a migration source")
Signed-off-by: Rei Yamamoto <yamamoto.rei@jp.fujitsu.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Don Dutile <ddutile@redhat.com>
Cc: Wonhyuk Yang <vvghjk1234@gmail.com>
Cc: Rei Yamamoto <yamamoto.rei@jp.fujitsu.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/compaction.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1709,6 +1709,8 @@ static unsigned long fast_find_migratebl
 
 				update_fast_start_pfn(cc, free_pfn);
 				pfn = pageblock_start_pfn(free_pfn);
+				if (pfn < cc->zone->zone_start_pfn)
+					pfn = cc->zone->zone_start_pfn;
 				cc->fast_search_fail = 0;
 				found_block = true;
 				set_pageblock_skip(freepage);


