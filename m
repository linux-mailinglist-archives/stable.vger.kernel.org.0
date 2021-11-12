Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 270F244EC71
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 19:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235552AbhKLSKQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Nov 2021 13:10:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235420AbhKLSKP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Nov 2021 13:10:15 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03642C061767
        for <stable@vger.kernel.org>; Fri, 12 Nov 2021 10:07:25 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id k9-20020a170902c40900b001421e921ccaso4584571plk.22
        for <stable@vger.kernel.org>; Fri, 12 Nov 2021 10:07:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=GhhOdgquJDTmTXM6T9YlgdPGJ3obcugzwjKl+qkCXjU=;
        b=EFar4ORGAOm2ynZp0zNUZ6bCQJzatXMR2zAuyfEU+eUK1vhBFETulnczi01R0evyQV
         VaGLSeyMxT+kGUi7k1E48wgV4p1xNIacnRgOUZweJ1n5iRnVo341Zt6Nneobe6IEboim
         OPuPMhyVLzXnJD5E20gQWoWm2TLZ/I701ZS4jqgBC2H42ZpFcw45TrZpmySlckJbzpBv
         2nIO/H6w13LKAtM5XDHXBBeG/6Tm8tnXkeNG7Y639B8UwZ87s81dmhuYuVYOk80Jvr6Z
         n4kJwTlUjfaecDfCdLjE31RRbDnypf/FWc4T6FWmPuHZrnF+2yQMIj4JTR1fKSsLXQnp
         5AYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=GhhOdgquJDTmTXM6T9YlgdPGJ3obcugzwjKl+qkCXjU=;
        b=ldJnUGez6jLiv07YGwitJzSV1hUa3SXFmJ2bH2KkqdMX2vTM2rbrsKo6zERaR5IOtE
         XqYOhzi4zCzrETrlNUkw82JAJM4D8j0i5hW+t/ttTnuzzKRim6tmYu0IOCYaBCX+zY5o
         i4jE5AIZoSbKc7KYRwWo84/zbwUtqLZvyLq55G/nhSCfqfYiRTMgTGfzOO4F/v3itJ4Q
         u1jpoZXAXZ+bdJ75sLpAjnjCH9xpAcjbqjP3UFM1Od/WzXK5Zb8CQEToJezYwHigOI85
         8AjoWXm6kslyOUMEK+bATQy7Li9BIDbQIbHvVtwsvD1YGwcXVtLlHZeJTrb2/Ud1/wl+
         dWXA==
X-Gm-Message-State: AOAM533yNgplsZaCVD9MCZOBfBLNFbhCcwzYzdkgNn28oqaTWTpAo5IW
        bryAgvnqZ3LrSzAQLypaqJ2B7ybA7g==
X-Google-Smtp-Source: ABdhPJxVApQCL2FxYvBZ7ZeJ66SWOHkQyxFWnt62j83MthQwK7TXY5fEllH7KrQyJ2b0sHRYYGRgSU81Uw==
X-Received: from tkjos-desktop.mtv.corp.google.com ([2620:15c:211:200:8825:328e:2a73:f3f0])
 (user=tkjos job=sendgmr) by 2002:a17:903:408c:b0:142:45a9:672c with SMTP id
 z12-20020a170903408c00b0014245a9672cmr9940846plc.7.1636740444394; Fri, 12 Nov
 2021 10:07:24 -0800 (PST)
Date:   Fri, 12 Nov 2021 10:07:20 -0800
Message-Id: <20211112180720.2858135-1-tkjos@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [PATCH] binder: fix test regression due to sender_euid change
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

This is a partial revert of commit
29bc22ac5e5b ("binder: use euid from cred instead of using task").
Setting sender_euid using proc->cred caused some Android system test
regressions that need further investigation. It is a partial
reversion because subsequent patches rely on proc->cred.

Cc: stable@vger.kernel.org # 4.4+
Fixes: 29bc22ac5e5b ("binder: use euid from cred instead of using task")
Signed-off-by: Todd Kjos <tkjos@google.com>
Change-Id: I9b1769a3510fed250bb21859ef8beebabe034c66
---
- the issue was introduced in 5.16-rc1, so please apply to 5.16
- this should apply cleanly to all stable branches back to 4.4
  that contain "binder: use euid from cred instead of using task"


 drivers/android/binder.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 49fb74196d02..cffbe57a8e08 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2710,7 +2710,7 @@ static void binder_transaction(struct binder_proc *proc,
 		t->from = thread;
 	else
 		t->from = NULL;
-	t->sender_euid = proc->cred->euid;
+	t->sender_euid = task_euid(proc->tsk);
 	t->to_proc = target_proc;
 	t->to_thread = target_thread;
 	t->code = tr->code;
-- 
2.34.0.rc1.387.gb447b232ab-goog

