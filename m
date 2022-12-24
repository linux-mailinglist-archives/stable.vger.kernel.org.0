Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC7A765592A
	for <lists+stable@lfdr.de>; Sat, 24 Dec 2022 09:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbiLXIUm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Dec 2022 03:20:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbiLXIUl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Dec 2022 03:20:41 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B4C2DFA2
        for <stable@vger.kernel.org>; Sat, 24 Dec 2022 00:20:40 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id a1-20020a056a001d0100b0057a6f74d7bcso3576643pfx.1
        for <stable@vger.kernel.org>; Sat, 24 Dec 2022 00:20:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qHBgmM5FyY8tFESb+UZtZ7YHBNCfgMkVXvmSjVkn95c=;
        b=YIdgdTDlm/0rnNXmV/Ouxem7vSavubkjE/mlXtu3l2VNJp+VcHRwcxAqLRlRCht33T
         RjLRwnMH+83r29SKKJIBeQCmhsdRiiPnHm5RybHePQWkJtrnUBA8wvZoTReit57ZSQgj
         rb79t5GaIQFUYM+TelnB/YDfk3efw2LoXwE83oTT7NsNN0yVZUilRddaPER0eHid1zOn
         rFXxu33AQ1X9TIKISEarvlDOHXaIVzVHkuQDAvEdPao9/mUtIRnGOziez9pbYJtslSrk
         9oofFPc8G704Z1XNJl+3ESz0Xb773tj4avam3C858QsEl+9wi5oCzl9RAxGV4CrpOS/U
         Na7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qHBgmM5FyY8tFESb+UZtZ7YHBNCfgMkVXvmSjVkn95c=;
        b=1JQSKXLX5cmU5BDpXQP06qKy249L/vN9f3erknwEISKUfjZ7ivoJt/EvVwBPrh83ay
         1soA0VDZVMAnDGSSdHSEGiLKM1NTeFZnlVGPZZGDZxHCvaVysNwJ47sOSnAJibJNcVgc
         osZ37m6+YniffWMqnLiPSNyELknx3Ty6cY5l9/gyVYp4OE+SlQhmEOj4aa1VZWLoTE0D
         ZMMVSYFWoIOY3t7Yvx2p8tiqANACvWihJxtbMCq9dOVBdo+FeimXMCNzN7It57p1LVhs
         NVKS+cn7QpkrA88hxduSJSFgzFuGbDBBdQxxGp2pLS0fr8RBu8vaZX5sqoYnuOuqie2+
         S3hA==
X-Gm-Message-State: AFqh2kr2Bw6ZsGxZjiGpW6wrBgscurzx/nT93g6e/KV2+LNK2FSZj8SR
        4Nz69kjcS0MCDK2h66o7zhKK9eiPSprl
X-Google-Smtp-Source: AMrXdXtpnA9oa+kcg8UCtzsH2+zbPi8cE8h5FFqA3g8bAXygXEp5KA+R6LlQvnatJIrsuUCVCjwgqNmjUsVJ
X-Received: from zokeefe3.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1b6])
 (user=zokeefe job=sendgmr) by 2002:a17:90a:f018:b0:21a:150d:fe63 with SMTP id
 bt24-20020a17090af01800b0021a150dfe63mr1313517pjb.73.1671870039401; Sat, 24
 Dec 2022 00:20:39 -0800 (PST)
Date:   Sat, 24 Dec 2022 00:20:35 -0800
In-Reply-To: <20221224082035.3197140-1-zokeefe@google.com>
Mime-Version: 1.0
References: <20221224082035.3197140-1-zokeefe@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221224082035.3197140-2-zokeefe@google.com>
Subject: [PATCH v3 2/2] mm/shmem: restore SHMEM_HUGE_DENY precedence over MADV_COLLAPSE
From:   "Zach O'Keefe" <zokeefe@google.com>
To:     linux-mm@kvack.org
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Yang Shi <shy828301@gmail.com>,
        "Zach O'Keefe" <zokeefe@google.com>
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

SHMEM_HUGE_DENY is for emergency use by the admin, to disable allocation
of shmem huge pages if, for example, a dangerous bug is found in their
usage: see "deny" in Documentation/mm/transhuge.rst.  An app using
madvise(,,MADV_COLLAPSE) should not be allowed to override it: restore
its precedence over shmem_huge_force.

Restore SHMEM_HUGE_DENY precedence over MADV_COLLAPSE.

Fixes: 7c6c6cc4d3a2 ("mm/shmem: add flag to enforce shmem THP in hugepage_vma_check()")
Suggested-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: stable@vger.kernel.org
---
v2->v3: Add 'Cc: stable@vger.kernel.org' as per stable-kernel-rules.
v1->v2: Update changelog, and add note explaining rationale for
	backporting  (Andrew Morton).

Request to backport this to 6.1.X stable.  We'd like SHMEM_HUGE_DENY to
take precedence over MADV_COLLAPSE.  If we make this change later, it
will be a userspace API change.  As such, 6.1 cannot be allowed to
continue as-is, and we should fix up the code there.
---
 mm/shmem.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index c301487be5fb..0005ab2c29af 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -478,12 +478,10 @@ bool shmem_is_huge(struct vm_area_struct *vma, struct inode *inode,
 	if (vma && ((vma->vm_flags & VM_NOHUGEPAGE) ||
 	    test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags)))
 		return false;
-	if (shmem_huge_force)
-		return true;
-	if (shmem_huge == SHMEM_HUGE_FORCE)
-		return true;
 	if (shmem_huge == SHMEM_HUGE_DENY)
 		return false;
+	if (shmem_huge_force || shmem_huge == SHMEM_HUGE_FORCE)
+		return true;
 
 	switch (SHMEM_SB(inode->i_sb)->huge) {
 	case SHMEM_HUGE_ALWAYS:
-- 
2.39.0.314.g84b9a713c41-goog

