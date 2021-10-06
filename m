Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98D23424769
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 21:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239507AbhJFTsZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 15:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239522AbhJFTsP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 15:48:15 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB8CC061762
        for <stable@vger.kernel.org>; Wed,  6 Oct 2021 12:46:22 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id l22-20020ac87b36000000b002a6c575f419so3064170qtu.23
        for <stable@vger.kernel.org>; Wed, 06 Oct 2021 12:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=S46yz478S8g1jd3FQde3QS+N6MClLovbhy1xDKfV8s4=;
        b=LTnJjPOs+ZrjG0fHZJG5cMVX7InUq2MqrkMbeo48RoAHPz31PRLdH8EOCHwXyVPyc1
         X10w6ZZcI/Hsx7ienxn79JbwedGc+RPfPqaKzL5G/tmWw7NSxvn6Q4nw541XyO7uOiy2
         jJIVJfZILKhWwS3qA1i7qPKnmFdKmYF56wf3Xityp9t7QBQTeFhPdok+rnGnUwLmP9c4
         kTMU7DwzzBEDSl5VEmeAFQQ5twDjGLJLEnvb/JeuNTKjr0YTbuTXc0UCmpHGy0P8tCS1
         Z2XjLcil0IT80vK0kdj7sKduydQnvvj4LI6rlUBOnIu3KJ4NsuTDZLY5lZA6h6CVNn9T
         QHIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=S46yz478S8g1jd3FQde3QS+N6MClLovbhy1xDKfV8s4=;
        b=sDqVLhbDWkwiwSojrj4qCdKvjXi1uy6Q5NmxSbJu4IhhnP1pfkSHz9MMY12aAPEBBy
         pL7NY5EDCJDrppZAAPtM70BeyPPAnaxSzPKfLShYgx6uBr64dmgP84tUehaRcPzkG7VJ
         l+vDfl3B9bcBJf+x0WE/v5b6qCiVYSoW9QWkQQUxtUkW6yqZQQIuB89BgHwMztNGmJWn
         btRrDoY3OLnWkHj//+jDKI0Kll6Oj3ZMr/aYg1wVYk0J3XiaoHwGWTAH8vNI7oSFgt6v
         XiT3N+8zbuEWjJrkLx5ismiAEkZRx7YcyGe61lgBouZfq5B5p0+uS89nmkSRRO4byN5Z
         C02w==
X-Gm-Message-State: AOAM532ULiFJjhPVPPAmaotEx/oi5PIPH+5Efj9YvibvCN0BRYawdTgF
        aOVzZxy0XBNxuZLt9/LHOIA1X11kcw==
X-Google-Smtp-Source: ABdhPJwethn/u+nenu/8wM0paTR5+kkIhr4fatlk63zkiST7M/XeOk6Gp0cs5DvZ0ktg8MeudPwnwmd6zQ==
X-Received: from ava-linux2.mtv.corp.google.com ([2620:15c:211:200:6ff2:347f:ac4a:8a04])
 (user=tkjos job=sendgmr) by 2002:a05:622a:188e:: with SMTP id
 v14mr108103qtc.62.1633549581824; Wed, 06 Oct 2021 12:46:21 -0700 (PDT)
Date:   Wed,  6 Oct 2021 12:46:10 -0700
In-Reply-To: <20211006194610.953319-1-tkjos@google.com>
Message-Id: <20211006194610.953319-4-tkjos@google.com>
Mime-Version: 1.0
References: <20211006194610.953319-1-tkjos@google.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH v3 3/3] binder: use euid from cred instead of using task
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

Set a transaction's sender_euid from the the 'struct cred'
saved at binder_open() instead of looking up the euid
from the binder proc's 'struct task'. This ensures
the euid is associated with the security context that
of the task that opened binder.

Fixes: 457b9a6f09f0 ("Staging: android: add binder driver")
Signed-off-by: Todd Kjos <tkjos@google.com>
Stephen Smalley <stephen.smalley.work@gmail.com>
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

