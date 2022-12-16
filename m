Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE9964EF2E
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 17:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbiLPQcj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 11:32:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbiLPQcc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 11:32:32 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E33CDE2D;
        Fri, 16 Dec 2022 08:32:30 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 86A1A3454D;
        Fri, 16 Dec 2022 16:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1671208349; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ifpYR2PdESJAbvJefyXjW1EWj/1z2L0zImGtUVLVTog=;
        b=G0OuXHi/vYNbH57ZVsfKkJHhPgNpbk73CrPzwAWNhyKC3Xh8oDQOLuRGpTKYCaTgy2aXzB
        k0KaxX3xKjrzsD+IFm28RtsBbuoo+JfPz565cOawN8pNgSC13NF9g2u/aUaZ1t/RcOUdug
        Qo9E/fq7nu67Auoe/CaI7a2LO2TRDg8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1671208349;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ifpYR2PdESJAbvJefyXjW1EWj/1z2L0zImGtUVLVTog=;
        b=yah1WAubrE2ujAH04CMoJ6yYkHNQn4D1DQrpz87GR8v/vJCOlcD2/p8mCcKOkvRmP0v02E
        soZWIZ2/b5FHFHAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 580D0138F0;
        Fri, 16 Dec 2022 16:32:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id /03PFJ2dnGOaKQAAMHmgww
        (envelope-from <vbabka@suse.cz>); Fri, 16 Dec 2022 16:32:29 +0000
From:   Vlastimil Babka <vbabka@suse.cz>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-mm@kvack.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        Jiri Slaby <jirislaby@kernel.org>,
        =?UTF-8?q?Jakub=20Mat=C4=9Bna?= <matenajakub@gmail.com>,
        stable@vger.kernel.org,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Liam Howlett <liam.howlett@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Michal Hocko <mhocko@kernel.org>
Subject: [PATCH for v6.1 regression] mm, mremap: fix mremap() expanding vma with addr inside vma
Date:   Fri, 16 Dec 2022 17:32:27 +0100
Message-Id: <20221216163227.24648-1-vbabka@suse.cz>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since 6.1 we have noticed random rpm install failures that were tracked
to mremap() returning -ENOMEM and to commit ca3d76b0aa80 ("mm: add
merging after mremap resize").

The problem occurs when mremap() expands a VMA in place, but using an
starting address that's not vma->vm_start, but somewhere in the middle.
The extension_pgoff calculation introduced by the commit is wrong in
that case, so vma_merge() fails due to pgoffs not being compatible.
Fix the calculation.

By the way it seems that the situations, where rpm now expands a vma
from the middle, were made possible also due to that commit, thanks to
the improved vma merging. Yet it should work just fine, except for the
buggy calculation.

Reported-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://bugzilla.suse.com/show_bug.cgi?id=1206359
Fixes: ca3d76b0aa80 ("mm: add merging after mremap resize")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jakub Matěna <matenajakub@gmail.com>
Cc: <stable@vger.kernel.org>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
---
Hi, this fixes a regression in 6.1 so please process ASAP so that stable
6.1.y can get the fix.

 mm/mremap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index e465ffe279bb..fe587c5d6591 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1016,7 +1016,8 @@ SYSCALL_DEFINE5(mremap, unsigned long, addr, unsigned long, old_len,
 			long pages = (new_len - old_len) >> PAGE_SHIFT;
 			unsigned long extension_start = addr + old_len;
 			unsigned long extension_end = addr + new_len;
-			pgoff_t extension_pgoff = vma->vm_pgoff + (old_len >> PAGE_SHIFT);
+			pgoff_t extension_pgoff = vma->vm_pgoff +
+				((extension_start - vma->vm_start) >> PAGE_SHIFT);
 
 			if (vma->vm_flags & VM_ACCOUNT) {
 				if (security_vm_enough_memory_mm(mm, pages)) {
-- 
2.38.1

