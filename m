Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3779D4EB2B7
	for <lists+stable@lfdr.de>; Tue, 29 Mar 2022 19:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240208AbiC2Re7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Mar 2022 13:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235372AbiC2Re6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Mar 2022 13:34:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B469433E9E
        for <stable@vger.kernel.org>; Tue, 29 Mar 2022 10:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648575194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=DoTRqQDJbdqwPWMurSzwBFSAKdvVaPy59umte0ZT9sw=;
        b=jHRukHdtpllu1E00xlymQthyrUdAHvs5LN5RPPvyL/JGCGX5+tRh04+cGMEMQwky29KOow
        wR3vuRDJCq6qBNooojmvHvJVUyoF5XVHCaaOXm+Ifl/NWg0RSXQBjcTETY/k/F7Gjpd7yo
        UqABBFZxh+Gv/Y2/3Z3O5uLg3fWq1s4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-wM6pXmknNyezFYRp8c2AZw-1; Tue, 29 Mar 2022 13:32:03 -0400
X-MC-Unique: wM6pXmknNyezFYRp8c2AZw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 10F218F11D5;
        Tue, 29 Mar 2022 17:32:02 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B422AC0809D;
        Tue, 29 Mar 2022 17:31:57 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com,
        syzbot+6bde52d89cfdf9f61425@syzkaller.appspotmail.com,
        linux-mm@kvack.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [PATCH] mm: avoid pointless invalidate_range_start/end on mremap(old_size=0)
Date:   Tue, 29 Mar 2022 13:31:55 -0400
Message-Id: <20220329173155.172439-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If an mremap() syscall with old_size=0 ends up in move_page_tables(),
it will call invalidate_range_start()/invalidate_range_end() unnecessarily,
i.e. with an empty range.

This causes a WARN in KVM's mmu_notifier.  In the past, empty ranges
have been diagnosed to be off-by-one bugs, hence the WARNing.
Given the low (so far) number of unique reports, the benefits of
detecting more buggy callers seem to outweigh the cost of having
to fix cases such as this one, where userspace is doing something
silly.  In this particular case, an early return from move_page_tables()
is enough to fix the issue.

Reported-by: syzbot+6bde52d89cfdf9f61425@syzkaller.appspotmail.com
Cc: linux-mm@kvack.org
Cc: akpm@linux-foundation.org
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 mm/mremap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/mremap.c b/mm/mremap.c
index 002eec83e91e..0e175aef536e 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -486,6 +486,9 @@ unsigned long move_page_tables(struct vm_area_struct *vma,
 	pmd_t *old_pmd, *new_pmd;
 	pud_t *old_pud, *new_pud;
 
+	if (!len)
+		return 0;
+
 	old_end = old_addr + len;
 	flush_cache_range(vma, old_addr, old_end);
 
-- 
2.31.1

