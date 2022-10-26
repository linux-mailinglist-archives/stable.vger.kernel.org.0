Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A62C060E56C
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 18:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233126AbiJZQYx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 12:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233040AbiJZQYw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 12:24:52 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70F6818B0A
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 09:24:51 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id t6-20020a25b706000000b006b38040b6f7so15202634ybj.6
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 09:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AvqO8nC63zEnLtk0lpLMxAmVoxSfR1oGtN8HLK//Nv0=;
        b=FCHhZnavo/zt2Q5XtNsHMM7TCNo5E2Ylh22rqBZ9OQ7z0MfCx/xQn6t43aUZERsJSG
         kwcpmCg95ACLxm78+4aiOsypMQdfH3565pj1W2yX64GyaagdLn7maupHCXwVy3yNpemp
         Xr4pFIlzxzyPV9t0eoGdcNYNz7skz4jKts2diqqSk0sPP44A+Y8SVbcou7ntxv1k8xSx
         BWPiRzlSBJ9Qa1g3UmZL72+5AVFBs74ZOyzlElyZsxqBx01QQs03Q/ZgJOouacC3B90j
         ad/KXAGP3Fq8bC00KTR72fbipGIyjAOlEgstdVsyZA8jOAcfInszv7X9EoUycpub7yXf
         jSBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AvqO8nC63zEnLtk0lpLMxAmVoxSfR1oGtN8HLK//Nv0=;
        b=KzartHSh/2bDfQKJlqtoqhrAWylFVFtXWxjk/xv+hvO2fhbgdRCOCqImdA9EUKmbYs
         F8dJNJMTM57R7W2Wdse+joeGeMnNp9uLSwJgTBd8/jJWxhIQYYyfvNARESU7jbKiie+A
         8h21iz6xuZW7uC8kwSCD3dCIyVqiztgKAbSj8FKDAnVtCBJ0doWL6Zldb2tSScWPFLiE
         Y7HcZNuDLdfNfwyYxAdxXoi9j/Z1UUn1UdrkWTToVeY3OE4/jqFYMoW4K8sMoD2kVY/0
         j1LhLHzGXNECYMVXXJ6qUnr6PujazMsd9SqTLNtlo1JEso1vyaaWy1WP2MryVeFvTESk
         7WTQ==
X-Gm-Message-State: ACrzQf2tt5YkGSZgoDT4aOY12JbepT3/YnOCu/5oy3CgnFjSGV9dXazn
        0r7uBahHC4iDBbSg3IPj1OJilZc2EOFgViIeDfU7V+fmxnLOOaLNDyidfH1f4K91pB9YC/08urY
        ZKzFP7kXreC1MpI6cUKhc+DMLBnUoASrIRnLTLForchhgkClGVrwlnRRoYzwYP70VPSRlvomtd+
        c=
X-Google-Smtp-Source: AMsMyM700A/IJkjvsywg23+0kPhWDGRh/XehN4J48tPiKvjpsqk9PGyeK5HCaWIRmfOz0XS7lEdlagMzyFtZHquqWw==
X-Received: from roguebantha-cloud.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:1eee])
 (user=sethjenkins job=sendgmr) by 2002:a25:7b42:0:b0:6ca:1d03:2254 with SMTP
 id w63-20020a257b42000000b006ca1d032254mr31679918ybc.584.1666801490602; Wed,
 26 Oct 2022 09:24:50 -0700 (PDT)
Date:   Wed, 26 Oct 2022 12:24:38 -0400
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.135.g90850a2211-goog
Message-ID: <20221026162438.711738-1-sethjenkins@google.com>
Subject: [PATCH stable 4.19-5.19] mm: /proc/pid/smaps_rollup: fix no vma's null-deref
From:   Seth Jenkins <sethjenkins@google.com>
To:     stable@vger.kernel.org
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Seth Jenkins <sethjenkins@google.com>,
        Alexey Dobriyan <adobriyan@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 258f669e7e88 ("mm: /proc/pid/smaps_rollup: convert to single value
seq_file") introduced a null-deref if there are no vma's in the task in
show_smaps_rollup.

Fixes: 258f669e7e88 ("mm: /proc/pid/smaps_rollup: convert to single value seq_file")
Signed-off-by: Seth Jenkins <sethjenkins@google.com>
Reviewed-by: Alexey Dobriyan <adobriyan@gmail.com>
Tested-by: Alexey Dobriyan <adobriyan@gmail.com>
---
c4c84f06285e on upstream resolves this issue, but a fix must still be applied to stable trees 4.19-5.19.

 fs/proc/task_mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 4e0023643f8b..1e7bbc0873a4 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -969,7 +969,7 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
 		vma = vma->vm_next;
 	}
 
-	show_vma_header_prefix(m, priv->mm->mmap->vm_start,
+	show_vma_header_prefix(m, priv->mm->mmap ? priv->mm->mmap->vm_start : 0,
 			       last_vma_end, 0, 0, 0, 0);
 	seq_pad(m, ' ');
 	seq_puts(m, "[rollup]\n");
-- 
2.38.0.rc1.362.ged0d419d3c-goog

