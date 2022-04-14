Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEA945013F3
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244960AbiDNNh6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344259AbiDNNb1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:31:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9A22E6;
        Thu, 14 Apr 2022 06:29:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D022B82986;
        Thu, 14 Apr 2022 13:29:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD5DC385A5;
        Thu, 14 Apr 2022 13:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942940;
        bh=cBmM5eMSCAjjmEck3uOO3XNupINSU0Q3msvBUXYe6V4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0AgVCIAPdnbvZm0MZW7ItsUd+ci3gLNCBdl9kqJmlH5gXVYzxnU34retWmwkscVc3
         KEJ73V8nR/hdqqDywa2jo4J4b7mBNfq9vgJgs4lX09EKLYuY2ddANi3dxr1i6tXe1M
         z4oUQvja8namcyIymalnDW6qzjbN/fOjgfDxIln8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+6bde52d89cfdf9f61425@syzkaller.appspotmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 315/338] mmmremap.c: avoid pointless invalidate_range_start/end on mremap(old_size=0)
Date:   Thu, 14 Apr 2022 15:13:38 +0200
Message-Id: <20220414110847.853715846@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 01e67e04c28170c47700c2c226d732bbfedb1ad0 upstream.

If an mremap() syscall with old_size=0 ends up in move_page_tables(), it
will call invalidate_range_start()/invalidate_range_end() unnecessarily,
i.e.  with an empty range.

This causes a WARN in KVM's mmu_notifier.  In the past, empty ranges
have been diagnosed to be off-by-one bugs, hence the WARNing.  Given the
low (so far) number of unique reports, the benefits of detecting more
buggy callers seem to outweigh the cost of having to fix cases such as
this one, where userspace is doing something silly.  In this particular
case, an early return from move_page_tables() is enough to fix the
issue.

Link: https://lkml.kernel.org/r/20220329173155.172439-1-pbonzini@redhat.com
Reported-by: syzbot+6bde52d89cfdf9f61425@syzkaller.appspotmail.com
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mremap.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -201,6 +201,9 @@ unsigned long move_page_tables(struct vm
 	unsigned long mmun_start;	/* For mmu_notifiers */
 	unsigned long mmun_end;		/* For mmu_notifiers */
 
+	if (!len)
+		return 0;
+
 	old_end = old_addr + len;
 	flush_cache_range(vma, old_addr, old_end);
 


