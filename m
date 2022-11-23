Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8049B636865
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 19:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239429AbiKWSOH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 13:14:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239536AbiKWSNc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 13:13:32 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9EA8BC3B
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 10:09:25 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id b18-20020a170903229200b00186e357f3b9so14121587plh.6
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 10:09:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8AnrcGQxermayS9lzY4/PftYYJ1h7RYNfHX8xCVtV1c=;
        b=mLkBARzh9DEoczzapN40SjDSvfSO9nAnK4l7SEQlkecJWP9ks6Bnl+jjSjXJFx96mP
         X/zxr5Gdo+FYdbk0nY5U+gtLuL1HoNADzQsH1vNYJ3aHZjb5OWnAkVWeYx1Nr4cx608+
         5rCF9s1+CsORn3Gva3cK6mJniR0xr8NdKtzQ/lt/wo61RW1zH4tnHKYqX+nl2bZMMJmO
         P19cZl/P1PQEyizWuij5WoOIv41uIflr/80PPs00WtxoMR/gbsEqqJSyrAeFhZGKAW5v
         9FWFTV250Y2UnKZXM0FOoER96PJUv6pk6HezB4soFYS5xu5FUh9wZ5o49oM2hkb5wfk+
         uqWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8AnrcGQxermayS9lzY4/PftYYJ1h7RYNfHX8xCVtV1c=;
        b=YXdDsyaIw+JBYYTFbkf5mOc2Ntrfyp8cOLQvihF529uWfKZrVikakMnMibqXjV4Rl8
         I8KivRQ18QCiQqU8MnhRkiai9bqYbYTt3RQyY56MTQQXJIu5Js231a4eKR7BdnigB1oM
         CMIOIkUvkGFuAOhVCHdbN5D7Mu1Q9P82ctmyQfJ3jkxaAsYlS4D0nT7/0fPNZKxhPw1u
         kZ6eARPqkc920JXTimfngFDSY7Tm8FRUn2zFfkWp5cGemYV5Qd/VVc1gH7xL9OIl0mFE
         iKmn+WeYO3rhv5Qc5BmcqcomK9vN150tRO0VjJpiFv31Vh+XL7SC3bm59cjFO7i8lIGV
         HzAg==
X-Gm-Message-State: ANoB5pkWeujZ7JApaHM8vUFpDBoMsFFU4Vd/A4jUWt7SPm9J8/luTUla
        cPpGJkekRRjeg1o0kroDTp+nu2KWxxbuAw==
X-Google-Smtp-Source: AA0mqf5Xc1KOJwNTNf49TsdXYL1qiDu6Xvj71CD7OpYTPMjz0vmWKZRCyaIGhUW8iWfg/r1x3ex8Wa7SZojBNw==
X-Received: from xllamas.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5070])
 (user=cmllamas job=sendgmr) by 2002:a17:90a:cf08:b0:218:6bd8:3114 with SMTP
 id h8-20020a17090acf0800b002186bd83114mr31561207pju.128.1669226965293; Wed,
 23 Nov 2022 10:09:25 -0800 (PST)
Date:   Wed, 23 Nov 2022 18:09:21 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221123180922.1502550-1-cmllamas@google.com>
Subject: [PATCH 5.15] binder: validate alloc->mm in ->mmap() handler
From:   Carlos Llamas <cmllamas@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "=?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?=" <arve@android.com>,
        Todd Kjos <tkjos@android.com>,
        Martijn Coenen <maco@android.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Christian Brauner <christian@brauner.io>,
        Hridya Valsaraju <hridya@google.com>,
        Suren Baghdasaryan <surenb@google.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Carlos Llamas <cmllamas@google.com>
Cc:     linux-kernel@vger.kernel.org, kernel-team@android.com,
        Jann Horn <jannh@google.com>, stable@vger.kernel.org,
        Todd Kjos <tkjos@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 3ce00bb7e91cf57d723905371507af57182c37ef upstream.

Since commit 1da52815d5f1 ("binder: fix alloc->vma_vm_mm null-ptr
dereference") binder caches a pointer to the current->mm during open().
This fixes a null-ptr dereference reported by syzkaller. Unfortunately,
it also opens the door for a process to update its mm after the open(),
(e.g. via execve) making the cached alloc->mm pointer invalid.

Things get worse when the process continues to mmap() a vma. From this
point forward, binder will attempt to find this vma using an obsolete
alloc->mm reference. Such as in binder_update_page_range(), where the
wrong vma is obtained via vma_lookup(), yet binder proceeds to happily
insert new pages into it.

To avoid this issue fail the ->mmap() callback if we detect a mismatch
between the vma->vm_mm and the original alloc->mm pointer. This prevents
alloc->vm_addr from getting set, so that any subsequent vma_lookup()
calls fail as expected.

Fixes: 1da52815d5f1 ("binder: fix alloc->vma_vm_mm null-ptr dereference")
Reported-by: Jann Horn <jannh@google.com>
Cc: <stable@vger.kernel.org> # 5.15+
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Acked-by: Todd Kjos <tkjos@google.com>
Link: https://lore.kernel.org/r/20221104231235.348958-1-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[cmllamas: renamed alloc->mm since missing e66b77e50522]
Signed-off-by: Carlos Llamas <cmllamas@google.com>
---
 drivers/android/binder_alloc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
index 8ed450125c92..6acfb896b2e5 100644
--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -753,6 +753,12 @@ int binder_alloc_mmap_handler(struct binder_alloc *alloc,
 	const char *failure_string;
 	struct binder_buffer *buffer;
 
+	if (unlikely(vma->vm_mm != alloc->vma_vm_mm)) {
+		ret = -EINVAL;
+		failure_string = "invalid vma->vm_mm";
+		goto err_invalid_mm;
+	}
+
 	mutex_lock(&binder_alloc_mmap_lock);
 	if (alloc->buffer_size) {
 		ret = -EBUSY;
@@ -799,6 +805,7 @@ int binder_alloc_mmap_handler(struct binder_alloc *alloc,
 	alloc->buffer_size = 0;
 err_already_mapped:
 	mutex_unlock(&binder_alloc_mmap_lock);
+err_invalid_mm:
 	binder_alloc_debug(BINDER_DEBUG_USER_ERROR,
 			   "%s: %d %lx-%lx %s failed %d\n", __func__,
 			   alloc->pid, vma->vm_start, vma->vm_end,
-- 
2.38.1.584.g0f3c55d4c2-goog

