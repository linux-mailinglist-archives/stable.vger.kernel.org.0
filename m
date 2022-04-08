Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0B6E4F9E0A
	for <lists+stable@lfdr.de>; Fri,  8 Apr 2022 22:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239395AbiDHULQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Apr 2022 16:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239412AbiDHULP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Apr 2022 16:11:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8756353ABD;
        Fri,  8 Apr 2022 13:09:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40D4261E3D;
        Fri,  8 Apr 2022 20:09:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943B7C385A5;
        Fri,  8 Apr 2022 20:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649448545;
        bh=Uwe61k3TCdIIAb9jWMhOFX99NiRwkoxxsB+Q7xD3Mck=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=vP/PnsHIBa1QkY85u2AzCWADg8BR56BgOHgbNPxvhlodwAHV2uFg+4GZaQnYjzxR7
         yTGwqWwXKwNBQeH/KgPabxhmHs3C/yGHkHOxAjQusbesROJyu/SMVuFs3OGvcXXsTI
         WxKEvc8QjUp4poAk0vPDkxfNm2Euhwq6YXdQ791g=
Date:   Fri, 08 Apr 2022 13:09:04 -0700
To:     stable@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220408130819.a89195e527ce58dfbe0700b9@linux-foundation.org>
Subject: [patch 5/9] mmmremap.c: avoid pointless invalidate_range_start/end on mremap(old_size=0)
Message-Id: <20220408200905.943B7C385A5@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>
Subject: mmmremap.c: avoid pointless invalidate_range_start/end on mremap(old_size=0)

If an mremap() syscall with old_size=0 ends up in move_page_tables(), it
will call invalidate_range_start()/invalidate_range_end() unnecessarily,
i.e.  with an empty range.

This causes a WARN in KVM's mmu_notifier.  In the past, empty ranges have
been diagnosed to be off-by-one bugs, hence the WARNing.  Given the low
(so far) number of unique reports, the benefits of detecting more buggy
callers seem to outweigh the cost of having to fix cases such as this one,
where userspace is doing something silly.  In this particular case, an
early return from move_page_tables() is enough to fix the issue.

Link: https://lkml.kernel.org/r/20220329173155.172439-1-pbonzini@redhat.com
Reported-by: syzbot+6bde52d89cfdf9f61425@syzkaller.appspotmail.com
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/mremap.c~mm-avoid-pointless-invalidate_range_start-end-on-mremapold_size=0
+++ a/mm/mremap.c
@@ -486,6 +486,9 @@ unsigned long move_page_tables(struct vm
 	pmd_t *old_pmd, *new_pmd;
 	pud_t *old_pud, *new_pud;
 
+	if (!len)
+		return 0;
+
 	old_end = old_addr + len;
 	flush_cache_range(vma, old_addr, old_end);
 
_
