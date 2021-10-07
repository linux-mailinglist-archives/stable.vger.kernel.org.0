Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99C15424B5B
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 02:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240153AbhJGAsm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 20:48:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240147AbhJGAsg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 20:48:36 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBDD7C061768
        for <stable@vger.kernel.org>; Wed,  6 Oct 2021 17:46:40 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id x16-20020a25b910000000b005b6b7f2f91cso5822060ybj.1
        for <stable@vger.kernel.org>; Wed, 06 Oct 2021 17:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zPCs1rEpKuQz4LUSoTxaJ0G3vwf7KAFSlUITLwZs6tU=;
        b=p7C8NObDL/qgsnHg5/TYMe/e2qJ6I/Lq4YqPZ2gUnySyfykd5F/A2vU/1m3ceyFytV
         I/7OeC1DNhDBO/Sg1SZmblT8zSDOS20AEaXhLm2H/qlJpIU+UkrwJgwQR6ZhajMJlwdg
         H0AQ8c2Ji4cC5UGLPFyjbyHiVLS1+KBXJaeDkVYrBsKAL2mDeRIuBNWlxuMFkZA9ZGV8
         A7qky4OO4I/PaZtI6fTe4+d1q4NwNuqcs2UJX5Gqm7isuGeOruusB375wUngfU0n4dV1
         v6iAo7zDuAInyEyLRn9Rt/0nvTXYRScq+aeug+gsRlashaZxAnGdEcAqgBxeJf60frPU
         Y76A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zPCs1rEpKuQz4LUSoTxaJ0G3vwf7KAFSlUITLwZs6tU=;
        b=lfr6h7EStZwmE+/0UNC0lr/lO7jJTZhXOBej5EnhxIzvaNrIlEYl79WrfmlCtmTY11
         a7QuUFLQ1dOLNQTwNtIcYGULg4aYxyrW0IsxZxOq0e+e5MTp96yXIsrN/cvNTq2PR01d
         XYl/LrZ4N/w8ZKx3pW0AYdeDIoxXpe4NMidOq/DqRJ2BpwBPKNw+UTJIbhqFtDdXGXyK
         jByIjzmGTa8aid42qu5CgTkghXrwyDmgqi3ZNSbyZVuG29Z2ZGPghloRMPS3Ipxey7qh
         8cnvJzH7QUpXJzrfGV4D6nTkD7LBUn5YRI5QHBU6GN/Wgs/KF2iXB29Fxg+iUtH4TErb
         ZbEQ==
X-Gm-Message-State: AOAM532/kd5MdPpgdkxe83acmoffmFKFuO6Cm5/eqnJ+/u1Z8aP+LgQ8
        i1iozB8PCEk1pfECv0CbPbq9Dh16LA==
X-Google-Smtp-Source: ABdhPJyjO6u79sIe1Ctn1/EYwfXuBQtVGMw40kM5yChFcDVNsb4RU39eXJBDBGttGXiLTmWRzysZNXQWxg==
X-Received: from ava-linux2.mtv.corp.google.com ([2620:15c:211:200:6ff2:347f:ac4a:8a04])
 (user=tkjos job=sendgmr) by 2002:a5b:501:: with SMTP id o1mr1359354ybp.402.1633567600035;
 Wed, 06 Oct 2021 17:46:40 -0700 (PDT)
Date:   Wed,  6 Oct 2021 17:46:29 -0700
In-Reply-To: <20211007004629.1113572-1-tkjos@google.com>
Message-Id: <20211007004629.1113572-4-tkjos@google.com>
Mime-Version: 1.0
References: <20211007004629.1113572-1-tkjos@google.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH v4 3/3] binder: use euid from cred instead of using task
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

Set a transaction's sender_euid from the 'struct cred'
saved at binder_open() instead of looking up the euid
from the binder proc's 'struct task'. This ensures
the euid is associated with the security context that
of the task that opened binder.

Fixes: 457b9a6f09f0 ("Staging: android: add binder driver")
Signed-off-by: Todd Kjos <tkjos@google.com>
Suggested-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: stable@vger.kernel.org # 4.4+
---
v3: added this patch to series

 drivers/android/binder.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 989afd0804ca..26382e982c5e 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2711,7 +2711,7 @@ static void binder_transaction(struct binder_proc *proc,
 		t->from = thread;
 	else
 		t->from = NULL;
-	t->sender_euid = task_euid(proc->tsk);
+	t->sender_euid = proc->cred->euid;
 	t->to_proc = target_proc;
 	t->to_thread = target_thread;
 	t->code = tr->code;
-- 
2.33.0.800.g4c38ced690-goog

