Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5DB5EF2F9
	for <lists+stable@lfdr.de>; Thu, 29 Sep 2022 12:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbiI2KFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 06:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234980AbiI2KFE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 06:05:04 -0400
Received: from smtp-8fad.mail.infomaniak.ch (smtp-8fad.mail.infomaniak.ch [IPv6:2001:1600:3:17::8fad])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20CC648EB1
        for <stable@vger.kernel.org>; Thu, 29 Sep 2022 03:04:58 -0700 (PDT)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4MdTVq5WPNzMqdYs;
        Thu, 29 Sep 2022 12:04:51 +0200 (CEST)
Received: from localhost (unknown [23.97.221.149])
        by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4MdTVq2P01zx0;
        Thu, 29 Sep 2022 12:04:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1664445891;
        bh=fYqQCGtQCa3m0DU5iOI8aAuy8TqxREsNUaE2lVvrtvU=;
        h=From:To:Cc:Subject:Date:From;
        b=XnxZ9wKnSfinXr5GG5T4qDJcLypqXxk4DzLU2rJ2gkjhcapYMYZeApInqNtdxPUsn
         as8ZX30HWnMJqP4bb0VdwXCD9CFi5CBlgUsj6Efxk+CLyvDG3AFyZV6JQbkVntbMPG
         ToyoSbpL3CAnDl39ivVU5Glxkg/b5Soo45D0ZxfA=
From:   =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To:     Hyunchul Lee <hyc.lee@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <smfrench@gmail.com>
Cc:     =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v1] ksmbd: Fix user namespace mapping
Date:   Thu, 29 Sep 2022 12:04:47 +0200
Message-Id: <20220929100447.108468-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A kernel daemon should not rely on the current thread, which is unknown
and might be malicious.  Before this security fix,
ksmbd_override_fsids() didn't correctly override FS UID/GID which means
that arbitrary user space threads could trick the kernel to impersonate
arbitrary users or groups for file system access checks, leading to
file system access bypass.

This was found while investigating truncate support for Landlock:
https://lore.kernel.org/r/CAKYAXd8fpMJ7guizOjHgxEyyjoUwPsx3jLOPZP=wPYcbhkVXqA@mail.gmail.com

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Link: https://lore.kernel.org/r/20220929100447.108468-1-mic@digikod.net
---
 fs/ksmbd/smb_common.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
index 7f8ab14fb8ec..d96da872d70a 100644
--- a/fs/ksmbd/smb_common.c
+++ b/fs/ksmbd/smb_common.c
@@ -4,6 +4,8 @@
  *   Copyright (C) 2018 Namjae Jeon <linkinjeon@kernel.org>
  */
 
+#include <linux/user_namespace.h>
+
 #include "smb_common.h"
 #include "server.h"
 #include "misc.h"
@@ -625,8 +627,8 @@ int ksmbd_override_fsids(struct ksmbd_work *work)
 	if (!cred)
 		return -ENOMEM;
 
-	cred->fsuid = make_kuid(current_user_ns(), uid);
-	cred->fsgid = make_kgid(current_user_ns(), gid);
+	cred->fsuid = make_kuid(&init_user_ns, uid);
+	cred->fsgid = make_kgid(&init_user_ns, gid);
 
 	gi = groups_alloc(0);
 	if (!gi) {

base-commit: f76349cf41451c5c42a99f18a9163377e4b364ff
-- 
2.37.2

