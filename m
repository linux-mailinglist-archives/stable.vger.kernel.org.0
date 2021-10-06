Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E80D424771
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 21:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239528AbhJFTsP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 15:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239507AbhJFTsM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 15:48:12 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C246C061755
        for <stable@vger.kernel.org>; Wed,  6 Oct 2021 12:46:20 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id z2-20020a254c02000000b005b68ef4fe24so4784433yba.11
        for <stable@vger.kernel.org>; Wed, 06 Oct 2021 12:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+cJ2U8Kdfy1yQQcGk3LARYGCqa9M8jIliNAIu7s74eQ=;
        b=ZvJyaUxlzhtcsgadNpmuGGUBZT76eQqyEVoB8on2XenmCdJm9gZ6R2RDf+xiH8rMFG
         1qN5V/UD5aOJs8Hf+hNMD/y6MJMO2w469S+KdFUi+IIo0pJ9S4959sStXjvF7imp5s1w
         Ob9eaIYx5Q95X1D4mzr7Hvi1k54zuwi2eUnK3ftn06t6/bX3gsBzqF2IPr9cJkEs+0UF
         mhBehHkdB00HeaH0+BEtSaaQh1xMDssE8KeuYFm1U5yF8qgcRSJpDrMErZLNHycGQ/FL
         u9Z2R+tNbEc4r6wr6vKtKhYsHcoD35c2RxK1kBQeQA9o8fp0riETFiZRHe6WIpcMZv5f
         rjWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+cJ2U8Kdfy1yQQcGk3LARYGCqa9M8jIliNAIu7s74eQ=;
        b=ZLmnpaTs1eqk0TbYisnVjCC/4/mHLh5Oene6xa+ygskE4QsmlIYqC+gCWMobby5xai
         aqgqVE9uaDsfz3fvBhAZ6ZB3uF38RJMwehq6hhh/OL0fNXNApoQa475gdKafdpoApz3I
         Z28lJh+vK29gwRsYrI8qyCi9z58b9+uxvXoK9/i6J5P6KREBfuK4EVawWmNc2WBXke1N
         wtopUpbO8Sp7jlQePW2rfeJzAVZ3y5SvZPuaUxzjkzm6iN1ttpMehKUG0xrjptmhu0yC
         XTv1jpGFMj0nIzPf69SHhJohbR6850ER8puJQYXfO6mgzH6t1dzOdci0nkVXTdgcMxj6
         gt2A==
X-Gm-Message-State: AOAM530USO7ogNOzQhjKjyFQ1+h5qiKjdI74vYGxGzN8925htgPj5TU1
        ++gWX2JBpsuWRmHfPO64NhZX8Uo+aw==
X-Google-Smtp-Source: ABdhPJx4NII6suHk437Oza4d9GhybnDEU0XlzwSKDh6uVO5Hgr9ofng+eRpQ+vrF7M4hFmvgSyMBKr4gIA==
X-Received: from ava-linux2.mtv.corp.google.com ([2620:15c:211:200:6ff2:347f:ac4a:8a04])
 (user=tkjos job=sendgmr) by 2002:a25:e4c7:: with SMTP id b190mr47234ybh.28.1633549579410;
 Wed, 06 Oct 2021 12:46:19 -0700 (PDT)
Date:   Wed,  6 Oct 2021 12:46:09 -0700
In-Reply-To: <20211006194610.953319-1-tkjos@google.com>
Message-Id: <20211006194610.953319-3-tkjos@google.com>
Mime-Version: 1.0
References: <20211006194610.953319-1-tkjos@google.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH v3 2/3] binder: use cred instead of task for getsecid
From:   Todd Kjos <tkjos@google.com>
To:     gregkh@linuxfoundation.org, arve@android.com, tkjos@android.com,
        maco@android.com, christian@brauner.io, jmorris@namei.org,
        serge@hallyn.com, paul@paul-moore.com,
        stephen.smalley.work@gmail.com, eparis@parisplace.org,
        keescook@chromium.org, jannh@google.com, jeffv@google.com,
        zohar@linux.ibm.com, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc:     joel@joelfernandes.org, kernel-team@android.com,
        Todd Kjos <tkjos@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Use the 'struct cred' saved at binder_open() to lookup
the security ID via security_cred_getsecid(). This
ensures that the security context that opened binder
is the one used to generate the secctx.

Fixes: ec74136ded79 ("binder: create node flag to request sender's
security context")
Signed-off-by: Todd Kjos <tkjos@google.com>
Suggested-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: stable@vger.kernel.org # 5.4+
---
v3: added this patch to series

 drivers/android/binder.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index ca599ebdea4a..989afd0804ca 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2722,16 +2722,7 @@ static void binder_transaction(struct binder_proc *proc,
 		u32 secid;
 		size_t added_size;
 
-		/*
-		 * Arguably this should be the task's subjective LSM secid but
-		 * we can't reliably access the subjective creds of a task
-		 * other than our own so we must use the objective creds, which
-		 * are safe to access.  The downside is that if a task is
-		 * temporarily overriding it's creds it will not be reflected
-		 * here; however, it isn't clear that binder would handle that
-		 * case well anyway.
-		 */
-		security_task_getsecid_obj(proc->tsk, &secid);
+		security_cred_getsecid(proc->cred, &secid);
 		ret = security_secid_to_secctx(secid, &secctx, &secctx_sz);
 		if (ret) {
 			return_error = BR_FAILED_REPLY;
-- 
2.33.0.800.g4c38ced690-goog

