Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE146E9DB1
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 23:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbjDTVKF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 17:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjDTVKC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 17:10:02 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC43119
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 14:10:01 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-b8ed0a07a6fso1426294276.0
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 14:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682025000; x=1684617000;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=z8h/G6KklbzPNQ9jczk/GigGAZbyVMnEE1fOx6AWhk0=;
        b=Tsfu7N3sgp7w1vKNJM9c81o728KVru0BquBWnMQY/b0rj89/J7YDKEvS0qTHAxya8o
         Dzx598eMlhbDY1y7Vsp1bFSwyCiXLS46NE+zJwUvgWx4/0830zIDiWgClXVhidYUy4g/
         1Sq6rO+y8jIi9tsI/n0Zh+hFlb7z6CCrUyG1u9y4zllMqsoALTUu9MBE54/EGabk62uw
         m2ulxPu1ZJjFH0tl98CKI+NczD04CyPP9ho0xRDgp6V9CeOW6xN/cH9AwqUanFLKKR5z
         3AAdyGky/r2mC1b1VMT5AGyu79grJ75LGGHokL7aJMin3FbAbG9rz6wezsXePG49VskW
         eyVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682025000; x=1684617000;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z8h/G6KklbzPNQ9jczk/GigGAZbyVMnEE1fOx6AWhk0=;
        b=Gk79BwaUhQHjg1SdW+irTEmpV5gKNUJoHe6QiJcQlRyfXjZ/zfk4m7QTDn8wGfZfKL
         lrpeQ7iZoZm36qUjmqTmL5qKLQt9EcUHr+YBt93NdoWerI+FHKHakA7K73yXrn++sCtY
         IzWF4yag89dUVnMvrxhAe4Iux+EHwFbpjfvWHVcNtp7Bxqa3NG6RxwIhUzRsA5fjmBq4
         7bOWGP5qpYdCfP0AXgrDJYF+5rcFfGlNuIc7C6YJgD7knBRn1N5zNDjVBqmVKIetMfsX
         nzG2wGvGGXZTZe2tFJfmoRamwqhT9Oj3OkqC9VlCY7QNwyQTu2J5ozetwR8khRQ5z+9s
         pvoQ==
X-Gm-Message-State: AAQBX9fA92Ti3Q8aKS4M17p6b7XTjFYF0jpBT5qA9ez8iw9XjMqNXHkr
        P2LXwGZ8BL2Hua379Co8Ab/mjwo=
X-Google-Smtp-Source: AKy350aKMhHVQ7iipV9l0amJ4UENFSScgBz98TKfwb3TKU8QIOIzHCJygyFU0PqVoUYPVprNhXly068=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2d3:205:651e:f743:4850:3ce])
 (user=pcc job=sendgmr) by 2002:a25:e097:0:b0:b95:4128:bff6 with SMTP id
 x145-20020a25e097000000b00b954128bff6mr274448ybg.1.1682025000734; Thu, 20 Apr
 2023 14:10:00 -0700 (PDT)
Date:   Thu, 20 Apr 2023 14:09:45 -0700
Message-Id: <20230420210945.2313627-1-pcc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.396.gfff15efe05-goog
Subject: [PATCH] arm64: Also reset KASAN tag if page is not PG_mte_tagged
From:   Peter Collingbourne <pcc@google.com>
To:     catalin.marinas@arm.com, andreyknvl@gmail.com
Cc:     Peter Collingbourne <pcc@google.com>,
        "=?UTF-8?q?Qun-wei=20Lin=20=28=E6=9E=97=E7=BE=A4=E5=B4=B4=29?=" 
        <Qun-wei.Lin@mediatek.com>,
        "=?UTF-8?q?Guangye=20Yang=20=28=E6=9D=A8=E5=85=89=E4=B8=9A=29?=" 
        <guangye.yang@mediatek.com>, linux-mm@kvack.org,
        "=?UTF-8?q?Chinwen=20Chang=20=28=E5=BC=B5=E9=8C=A6=E6=96=87=29?=" 
        <chinwen.chang@mediatek.com>, kasan-dev@googlegroups.com,
        ryabinin.a.a@gmail.com, linux-arm-kernel@lists.infradead.org,
        vincenzo.frascino@arm.com, will@kernel.org, eugenis@google.com,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Consider the following sequence of events:

1) A page in a PROT_READ|PROT_WRITE VMA is faulted.
2) Page migration allocates a page with the KASAN allocator,
   causing it to receive a non-match-all tag, and uses it
   to replace the page faulted in 1.
3) The program uses mprotect() to enable PROT_MTE on the page faulted in 1.

As a result of step 3, we are left with a non-match-all tag for a page
with tags accessible to userspace, which can lead to the same kind of
tag check faults that commit e74a68468062 ("arm64: Reset KASAN tag in
copy_highpage with HW tags only") intended to fix.

The general invariant that we have for pages in a VMA with VM_MTE_ALLOWED
is that they cannot have a non-match-all tag. As a result of step 2, the
invariant is broken. This means that the fix in the referenced commit
was incomplete and we also need to reset the tag for pages without
PG_mte_tagged.

Fixes: e5b8d9218951 ("arm64: mte: reset the page tag in page->flags")
Cc: <stable@vger.kernel.org> # 5.15
Link: https://linux-review.googlesource.com/id/I7409cdd41acbcb215c2a7417c1e50d37b875beff
Signed-off-by: Peter Collingbourne <pcc@google.com>
---
 arch/arm64/mm/copypage.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/copypage.c b/arch/arm64/mm/copypage.c
index 4aadcfb01754..a7bb20055ce0 100644
--- a/arch/arm64/mm/copypage.c
+++ b/arch/arm64/mm/copypage.c
@@ -21,9 +21,10 @@ void copy_highpage(struct page *to, struct page *from)
 
 	copy_page(kto, kfrom);
 
+	if (kasan_hw_tags_enabled())
+		page_kasan_tag_reset(to);
+
 	if (system_supports_mte() && page_mte_tagged(from)) {
-		if (kasan_hw_tags_enabled())
-			page_kasan_tag_reset(to);
 		/* It's a new page, shouldn't have been tagged yet */
 		WARN_ON_ONCE(!try_page_mte_tagging(to));
 		mte_copy_page_tags(kto, kfrom);
-- 
2.40.0.396.gfff15efe05-goog

