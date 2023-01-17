Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAE8866DAC6
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 11:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235873AbjAQKTp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 05:19:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235525AbjAQKTn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 05:19:43 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32DB10F3;
        Tue, 17 Jan 2023 02:19:42 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 83A8D38319;
        Tue, 17 Jan 2023 10:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1673950781; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=UTVHq9dqZLKTnxoacLYbqbw1DksZEoMSGKP4V1CCGyE=;
        b=otgKSDs/4JpBatRD9Uyk6RUBbfoOxcFlHu2acUs6DQetNtZ/n4o7KQBNf97dA84Wqop5Gx
        FUh7bLqlED5rcOegRYsHenWz15hsjmEovM8WQa5KXoLfCuJmOQd8YQHU0EQs+lo3g39stP
        Lyo4lXcZa2nOfpMbDBAE/8oIvE6QNZw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1673950781;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=UTVHq9dqZLKTnxoacLYbqbw1DksZEoMSGKP4V1CCGyE=;
        b=Sst3FRrTIY5EJQy/YcXbA4kWi2X6HIK1fMH/lBV6B5b/+R6+/8eF4sLu/pvadiVxhC9GNn
        u4PH6rwKzK+pluCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 530BA13357;
        Tue, 17 Jan 2023 10:19:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id faB5Ez12xmO+FwAAMHmgww
        (envelope-from <vbabka@suse.cz>); Tue, 17 Jan 2023 10:19:41 +0000
From:   Vlastimil Babka <vbabka@suse.cz>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        regressions@leemhuis.info, regressions@lists.linux.dev,
        Vlastimil Babka <vbabka@suse.cz>, Fabian Vogt <fvogt@suse.com>,
        =?UTF-8?q?Jakub=20Mat=C4=9Bna?= <matenajakub@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH for 6.1 regression] mm, mremap: fix mremap() expanding for vma's with vm_ops->close()
Date:   Tue, 17 Jan 2023 11:19:39 +0100
Message-Id: <20230117101939.9753-1-vbabka@suse.cz>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fabian has reported another regression in 6.1 due to ca3d76b0aa80 ("mm:
add merging after mremap resize"). The problem is that vma_merge() can
fail when vma has a vm_ops->close() method, causing is_mergeable_vma()
test to be negative. This was happening for vma mapping a file from
fuse-overlayfs, which does have the method. But when we are simply
expanding the vma, we never remove it due to the "merge" with the added
area, so the test should not prevent the expansion.

As a quick fix, check for such vmas and expand them using vma_adjust()
directly as was done before commit ca3d76b0aa80. For a more robust long
term solution we should try to limit the check for vma_ops->close only
to cases that actually result in vma removal, so that no merge would be
prevented unnecessarily.

Reported-by: Fabian Vogt <fvogt@suse.com>
Link: https://bugzilla.suse.com/show_bug.cgi?id=1206359#c35
Fixes: ca3d76b0aa80 ("mm: add merging after mremap resize")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jakub Matěna <matenajakub@gmail.com>
Cc: <stable@vger.kernel.org>
Tested-by: Fabian Vogt <fvogt@suse.com>
---
Thorsten: this should be added to the previous regression which wasn't
fully fixed by the previous patch:
https://linux-regtracking.leemhuis.info/regzbot/regression/20221216163227.24648-1-vbabka@suse.cz/
 mm/mremap.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index fe587c5d6591..1e234fd95547 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1032,11 +1032,22 @@ SYSCALL_DEFINE5(mremap, unsigned long, addr, unsigned long, old_len,
 			 * the already existing vma (expand operation itself) and possibly also
 			 * with the next vma if it becomes adjacent to the expanded vma and
 			 * otherwise compatible.
+			 *
+			 * However, vma_merge() can currently fail due to is_mergeable_vma()
+			 * check for vm_ops->close (see the comment there). Yet this should not
+			 * prevent vma expanding, so perform a simple expand for such vma.
+			 * Ideally the check for close op should be only done when a vma would
+			 * be actually removed due to a merge.
 			 */
-			vma = vma_merge(mm, vma, extension_start, extension_end,
+			if (!vma->vm_ops || !vma->vm_ops->close) {
+				vma = vma_merge(mm, vma, extension_start, extension_end,
 					vma->vm_flags, vma->anon_vma, vma->vm_file,
 					extension_pgoff, vma_policy(vma),
 					vma->vm_userfaultfd_ctx, anon_vma_name(vma));
+			} else if (vma_adjust(vma, vma->vm_start, addr + new_len,
+                                   vma->vm_pgoff, NULL)) {
+				vma = NULL;
+			}
 			if (!vma) {
 				vm_unacct_memory(pages);
 				ret = -ENOMEM;
-- 
2.38.1

