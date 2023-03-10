Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47D286B4389
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbjCJOPZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:15:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232007AbjCJOPE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:15:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6438DF26B
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:13:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20F2760D29
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:13:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B32DC433D2;
        Fri, 10 Mar 2023 14:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457636;
        bh=2oINvL1ZqkSayJ6Hx4HjcWWrCFaBKh6yTMLAaPP2+4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=onKXlOxCIS3fEJ9isiAxhvpzMqAOhi3hccXfqyLpWtoB3iwaFyhfDeXCb0O5VLpT8
         w4YLZ9L/5qxcHeftTRGyt8YnGTtKDUT1fZLsaR80PLqP6k/PaoTMzgIw/7M2wqR81s
         rtQ8+Uldox5xpIQIfVN+z9Z+hWXGzUXFMZlOdDBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peter Collingbourne <pcc@google.com>,
        =?UTF-8?q?Kuan-Ying=20Lee=20 ?= <Kuan-Ying.Lee@mediatek.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.1 199/200] arm64: Reset KASAN tag in copy_highpage with HW tags only
Date:   Fri, 10 Mar 2023 14:40:06 +0100
Message-Id: <20230310133723.189654176@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Collingbourne <pcc@google.com>

commit e74a68468062d7ebd8ce17069e12ccc64cc6a58c upstream.

During page migration, the copy_highpage function is used to copy the
page data to the target page. If the source page is a userspace page
with MTE tags, the KASAN tag of the target page must have the match-all
tag in order to avoid tag check faults during subsequent accesses to the
page by the kernel. However, the target page may have been allocated in
a number of ways, some of which will use the KASAN allocator and will
therefore end up setting the KASAN tag to a non-match-all tag. Therefore,
update the target page's KASAN tag to match the source page.

We ended up unintentionally fixing this issue as a result of a bad
merge conflict resolution between commit e059853d14ca ("arm64: mte:
Fix/clarify the PG_mte_tagged semantics") and commit 20794545c146 ("arm64:
kasan: Revert "arm64: mte: reset the page tag in page->flags""), which
preserved a tag reset for PG_mte_tagged pages which was considered to be
unnecessary at the time. Because SW tags KASAN uses separate tag storage,
update the code to only reset the tags when HW tags KASAN is enabled.

Signed-off-by: Peter Collingbourne <pcc@google.com>
Link: https://linux-review.googlesource.com/id/If303d8a709438d3ff5af5fd85706505830f52e0c
Reported-by: "Kuan-Ying Lee (李冠穎)" <Kuan-Ying.Lee@mediatek.com>
Cc: <stable@vger.kernel.org> # 6.1
Fixes: 20794545c146 ("arm64: kasan: Revert "arm64: mte: reset the page tag in page->flags"")
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Link: https://lore.kernel.org/r/20230215050911.1433132-1-pcc@google.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/mm/copypage.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm64/mm/copypage.c
+++ b/arch/arm64/mm/copypage.c
@@ -22,7 +22,8 @@ void copy_highpage(struct page *to, stru
 	copy_page(kto, kfrom);
 
 	if (system_supports_mte() && page_mte_tagged(from)) {
-		page_kasan_tag_reset(to);
+		if (kasan_hw_tags_enabled())
+			page_kasan_tag_reset(to);
 		mte_copy_page_tags(kto, kfrom);
 		set_page_mte_tagged(to);
 	}


