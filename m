Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D93C604837
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233387AbiJSNwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233180AbiJSNwG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:52:06 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D10106A75;
        Wed, 19 Oct 2022 06:35:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 523E1CE20EF;
        Wed, 19 Oct 2022 08:44:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 499DEC433D7;
        Wed, 19 Oct 2022 08:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169087;
        bh=zRbI9r4T8ATwG60e0stmIJjCAwfIsLK3ZdgJqhNquO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nQhVd5fnzuNumD7Ikg/PmTRpQkUqsLbwreGVl03cA/CScDGMcysinwkcD4bimUZWE
         A1J370Y0HH0HTQDyFThxC5piP9arJDvmiwW08BPVQZf16nDMN0xTBdvfXtUQUlcAlv
         FkAFLDQBS/K3f0ErGqWBx5ji6PFxhJMGbKkrkQs0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <smfrench@gmail.com>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.0 116/862] ksmbd: Fix user namespace mapping
Date:   Wed, 19 Oct 2022 10:23:23 +0200
Message-Id: <20221019083255.053626341@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mickaël Salaün <mic@digikod.net>

commit 7c88c1e0ab1704bacb751341ee6431c3be34b834 upstream.

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
Cc: Steve French <smfrench@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Link: https://lore.kernel.org/r/20220929100447.108468-1-mic@digikod.net
Acked-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb_common.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

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
@@ -625,8 +627,8 @@ int ksmbd_override_fsids(struct ksmbd_wo
 	if (!cred)
 		return -ENOMEM;
 
-	cred->fsuid = make_kuid(current_user_ns(), uid);
-	cred->fsgid = make_kgid(current_user_ns(), gid);
+	cred->fsuid = make_kuid(&init_user_ns, uid);
+	cred->fsgid = make_kgid(&init_user_ns, gid);
 
 	gi = groups_alloc(0);
 	if (!gi) {


