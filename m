Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B175F1ED53F
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 19:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbgFCRrV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 13:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbgFCRrV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jun 2020 13:47:21 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB2AC08C5C1
        for <stable@vger.kernel.org>; Wed,  3 Jun 2020 10:47:19 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id k35so2203217qva.18
        for <stable@vger.kernel.org>; Wed, 03 Jun 2020 10:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=fLjSsW/NTgyWecVWnnneUC+9Bt4TjOTIssgnySdQoyA=;
        b=jOQkwCJS99WcGmfd51kk60wxPiOKILfRB8GusbTg7LPsTQIDAsWczAhDblVosu5+ml
         BjGBUcc6n42Xpx9Lf/bPp7JK+HLXnXqC0UhtijIJwUGnsm6X0vdAfS+6e5MZXS5aL95G
         ttRSyfpzUVK7JqHpjbfUEM8wAnZx5tHIMMfwuwAps1p+b4rYU/Ww6oYxjv/A24uwRJqx
         jM3XJ3bU/MW1Jeijd6r22MH6RUEyN7c7GdyoaE1yZnm6B4xmVKaWlMUdjdZ7LWvFd7kO
         SEQccx0DItI3fmXi7zdty6heTWV5avdhJg7yDPQi8eD1neYsoU00QTiO24rsPDkbsnmf
         /n9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=fLjSsW/NTgyWecVWnnneUC+9Bt4TjOTIssgnySdQoyA=;
        b=E33wy3UfPRQVlIDx8vqEO2mH0tnCzNFZPjYkCso58Dn0Doep/TEp3rqr2mRSE6Fc9d
         pbLRshHpHnrKX+/uB2WFMweKZV3me0QoMZG3TKipuYXT+4ENuyukXY0++u5Z0SNc6B7Y
         esJ8BRUU3CR2XTD86Tjk4EHWAtvX3j0pB5W0GQW6se6i1eqEFf0KGRdbHbwe/mGYRqEa
         2BMx1ph9ziguZEicLV+5xaWgpKKt88Xd6lM/dQ5AKDwsoN8EhY/LkHqWmdMBfMYSI9Tu
         oQvVOJxcVJKyXh4RH7hvt7kWVDiBJrpPOAPoBzFbqwU1JTxqGHCgaFgTxICScfLPjWUz
         FyXA==
X-Gm-Message-State: AOAM533dzpXLk9Itkcb+/GkXKVxi6oHavifGkSIcFdC7NsSj4ucamGOe
        CL9Hk2ghHoI99VVvdU9jQj62MohFm1I=
X-Google-Smtp-Source: ABdhPJyTlHSzgJRLnJN7g81F8X0Rocv8raZHSS9nwnnwyEOSikK0OcS11Aw0N94+Ac4/qqujAbRMGPV8W90=
X-Received: by 2002:ad4:4e86:: with SMTP id dy6mr1006686qvb.106.1591206438886;
 Wed, 03 Jun 2020 10:47:18 -0700 (PDT)
Date:   Wed,  3 Jun 2020 19:47:14 +0200
Message-Id: <20200603174714.192027-1-glider@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.rc2.251.g90737beb825-goog
Subject: [PATCH] ovl: explicitly initialize error in ovl_copy_xattr()
From:   glider@google.com
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        keescook@chromium.org, royyang@google.com, stable@vger.kernel.org,
        Alexander Potapenko <glider@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Under certain circumstances (we found this out running Docker on a
Clang-built kernel with CONFIG_INIT_STACK_ALL) ovl_copy_xattr() may
return uninitialized value of |error| from ovl_copy_xattr().
It is then returned by ovl_create() to lookup_open(), which casts it to
an invalid dentry pointer, that can be further read or written by the
lookup_open() callers.

Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Roy Yang <royyang@google.com>
Cc: <stable@vger.kernel.org> # 4.1

---

It's unclear to me whether error should be initially 0 or some error
code (both seem to work), but I thought returning an error makes sense,
as the situation wasn't anticipated by the code authors.

The bug seem to date back to at least v4.1 where the annotation has been
introduced (i.e. the compilers started noticing error could be used
before being initialized). I hovever didn't try to prove that the
problem is actually reproducible on such ancient kernels. We've seen it
on a real machine running v4.4 as well.
---
 fs/overlayfs/copy_up.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 9709cf22cab3..428d43e2d016 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -47,7 +47,7 @@ int ovl_copy_xattr(struct dentry *old, struct dentry *new)
 {
 	ssize_t list_size, size, value_size = 0;
 	char *buf, *name, *value = NULL;
-	int uninitialized_var(error);
+	int error = -EINVAL;
 	size_t slen;
 
 	if (!(old->d_inode->i_opflags & IOP_XATTR) ||
-- 
2.27.0.rc2.251.g90737beb825-goog

