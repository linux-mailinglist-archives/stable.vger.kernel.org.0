Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A87DF541027
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352512AbiFGTS3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355363AbiFGTPe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:15:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094F319595F;
        Tue,  7 Jun 2022 11:07:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AE5061866;
        Tue,  7 Jun 2022 18:07:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B30CC385A5;
        Tue,  7 Jun 2022 18:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625258;
        bh=rTq3T8s/mMdhdO1WKGt3rpCnJl6XvTisZiFJN7ZqxnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dtz9twAF/eY96uQkEiVXzRbfxW8xIEyXrv2tQsTTh4jHJj7LoC8sSdzxmHXeZnfcS
         2sF1M3Le4WWt7T2sOv3dVpR+ix46OLYTpYlW0DWyuZtZBefrkIjJ1xG1CngMfIbdhL
         Z1xP9mxprdulr0rjzc4CGrKYXLxZeU7jvPOv6My0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Oscar Salvador <osalvador@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 623/667] mm/memremap: fix missing call to untrack_pfn() in pagemap_range()
Date:   Tue,  7 Jun 2022 19:04:48 +0200
Message-Id: <20220607164953.354471855@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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

From: Miaohe Lin <linmiaohe@huawei.com>

commit a04e1928e2ead144dc2f369768bc0a0f3110af89 upstream.

We forget to call untrack_pfn() to pair with track_pfn_remap() when range
is not allowed to hotplug.  Fix it by jump err_kasan.

Link: https://lkml.kernel.org/r/20220531122643.25249-1-linmiaohe@huawei.com
Fixes: bca3feaa0764 ("mm/memory_hotplug: prevalidate the address range being added with platform")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Muchun Song <songmuchun@bytedance.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -245,7 +245,7 @@ static int pagemap_range(struct dev_page
 
 	if (!mhp_range_allowed(range->start, range_len(range), !is_private)) {
 		error = -EINVAL;
-		goto err_pfn_remap;
+		goto err_kasan;
 	}
 
 	mem_hotplug_begin();


