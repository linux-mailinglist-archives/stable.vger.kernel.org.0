Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21B5653D2FB
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 22:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347128AbiFCU5z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 16:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbiFCU5y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 16:57:54 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1DB5326ED
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 13:57:52 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-30047b94aa8so77158477b3.1
        for <stable@vger.kernel.org>; Fri, 03 Jun 2022 13:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=rLWu+mkuMiZJwNpdLayTrCXX3MnKK+cmNqmcZ/mBvwY=;
        b=OBEwrNSluEd0bNvqaMjphL7UKxoam5UzDjKcYtfrt3UGHt3Qi+VteT1dPI86v82gxo
         7iD9PmFt/LmOhUWsfiNZAxJHTwT84Xp3h+lC6zdjUIeW2k0oqndllnhpQyv11QEirI/G
         kE/r0HZXFRlKMsdZyMdnv35UVZisCr5fXdGOkf23c6VBxC8j6aSHLvKkrU1JqEZCUDSW
         6txWhhL5DQYMAb4pepUqYRJaz6RlhnkKWBCRWSnNnEspIxSU98Jn73KP6f/4++sNOriK
         omKdxky4CMNnpADLPvSRq1sqBvreuVQ01WClJEU0YNUIoeJeRjlw3n6DGlbzXrkFMkGR
         XrWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=rLWu+mkuMiZJwNpdLayTrCXX3MnKK+cmNqmcZ/mBvwY=;
        b=w6qHob4fFA1WUkUa6utv82BP9v5oIi6LwIlxEasUIIk0YGmbJHZDKH8lyVOV6ENXdd
         +DRocJCm4g74iv0kGPKqBtXXPgPhXOjt6VA9m7aiwiJY2t2pCbt3jmFvXT9Rt+4Q5c81
         CWzl1DfPzwEYANji0ePLfEmgCgOGA8gu9lHdnEjcGgPdsBWXl622ki0nEhIjqtii16bW
         rFfBefBO+qC7MRYdTJLysHt0bwFluTK5P9PyUWKRwvT6v8c5Bh7Pnlr8dTfRMRts4kHx
         leXxX7OT3ZJpI8CR8qupsIgboI/cZ/fAZ9tS3nOBoPQtMmCSeHyzELyeULxPGrjNLzCE
         5byQ==
X-Gm-Message-State: AOAM532FG8KHhKOr1GJ9YGO0IrXh94mfeTyYUhhqEKMbFilHG28C/HIk
        TWvGrkEyuLBIfELdIP74c0ajkKWOiS4wVEDpJYgw
X-Google-Smtp-Source: ABdhPJwriWQgdUK7gB2ED+zM3smPBkANF/4W6Hz3s3ybmUltLgXLxLrOFBaxoeax8EHhui11zuzLSibrLNZ5aDNy7w5B
X-Received: from ajr0.svl.corp.google.com ([2620:15c:2cd:203:fbb0:d120:cc2e:23c1])
 (user=axelrasmussen job=sendgmr) by 2002:a25:c883:0:b0:64e:a298:304 with SMTP
 id y125-20020a25c883000000b0064ea2980304mr13114666ybf.38.1654289871981; Fri,
 03 Jun 2022 13:57:51 -0700 (PDT)
Date:   Fri,  3 Jun 2022 13:57:41 -0700
Message-Id: <20220603205741.12888-1-axelrasmussen@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH] mm: userfaultfd: fix UFFDIO_CONTINUE on fallocated shmem pages
From:   Axel Rasmussen <axelrasmussen@google.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>, Hugh Dickins <hughd@google.com>
Cc:     Axel Rasmussen <axelrasmussen@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When fallocate() is used on a shmem file, the pages we allocate can end
up with !PageUptodate.

Since UFFDIO_CONTINUE tries to find the existing page the user wants to
map with SGP_READ, we would fail to find such a page, since
shmem_getpage_gfp returns with a "NULL" pagep for SGP_READ if it
discovers !PageUptodate. As a result, UFFDIO_CONTINUE returns -EFAULT,
as it would do if the page wasn't found in the page cache at all.

This isn't the intended behavior. UFFDIO_CONTINUE is just trying to find
if a page exists, and doesn't care whether it still needs to be cleared
or not. So, instead of SGP_READ, pass in SGP_NOALLOC. This is the same,
except for one critical difference: in the !PageUptodate case,
SGP_NOALLOC will clear the page and then return it. With this change,
UFFDIO_CONTINUE works properly (succeeds) on a shmem file which has been
fallocated, but otherwise not modified.

Fixes: 153132571f02 ("userfaultfd/shmem: support UFFDIO_CONTINUE for shmem")
Cc: stable@vger.kernel.org
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
---
 mm/userfaultfd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 4f4892a5f767..c156f7f5b854 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -246,7 +246,7 @@ static int mcontinue_atomic_pte(struct mm_struct *dst_mm,
 	struct page *page;
 	int ret;
 
-	ret = shmem_getpage(inode, pgoff, &page, SGP_READ);
+	ret = shmem_getpage(inode, pgoff, &page, SGP_NOALLOC);
 	if (ret)
 		goto out;
 	if (!page) {
-- 
2.36.1.255.ge46751e96f-goog

