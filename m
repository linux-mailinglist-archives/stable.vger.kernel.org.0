Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8DD0541E88
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380697AbiFGWcN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383160AbiFGWam (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:30:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A4AC275584;
        Tue,  7 Jun 2022 12:23:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D449B823CE;
        Tue,  7 Jun 2022 19:23:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7614C385A2;
        Tue,  7 Jun 2022 19:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629833;
        bh=VPxZ/GdfHEX7gRFDxyW4jJq1K2qEinKRi73TYp6DpWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LTiQKUwLfEXq6J91AgNOUJNIsett/GlTXyIx41i1745v8ZBJ8BdYTxEtpt/YdrmyE
         pk8zN3Dj3h/iMa78fiA/2MIojueD1YA0eiKDgq5/FIpdNv1dtjBxpFaeBt9ldSBHoP
         kLTlyNYLZ9x81KTrT1092e99DJ5ubJRudLz7nGM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Oscar Salvador <osalvador@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.18 833/879] mm/memremap: fix missing call to untrack_pfn() in pagemap_range()
Date:   Tue,  7 Jun 2022 19:05:51 +0200
Message-Id: <20220607165027.035342389@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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
@@ -214,7 +214,7 @@ static int pagemap_range(struct dev_page
 
 	if (!mhp_range_allowed(range->start, range_len(range), !is_private)) {
 		error = -EINVAL;
-		goto err_pfn_remap;
+		goto err_kasan;
 	}
 
 	mem_hotplug_begin();


