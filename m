Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 902CD60AAF9
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236095AbiJXNma (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:42:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236220AbiJXNja (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:39:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 428D9B03C0;
        Mon, 24 Oct 2022 05:36:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F137561338;
        Mon, 24 Oct 2022 12:36:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D853C433C1;
        Mon, 24 Oct 2022 12:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614981;
        bh=um3TlDirkaO8Yd9NWj9UcXiZF1CG49YqDeFKM79ZEno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ExqiGb+A3CQtkg9Fd6q4FumAN2hNj0bWXmo2iwmXSDkAv6TIVUSDLBo0trEjPyzbY
         NVx7x9NyP7OeklpdU1TyCA4F8csp/y6tK64kTlpxDva0bFPQFDfFKPHQs1CpcF8eSn
         qEyxgpoXheQeedxZ/V7jXOVSX2Dc7gDdR1I5xr9I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <smfrench@gmail.com>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 077/530] ksmbd: Fix user namespace mapping
Date:   Mon, 24 Oct 2022 13:27:01 +0200
Message-Id: <20221024113048.494978107@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -624,8 +626,8 @@ int ksmbd_override_fsids(struct ksmbd_wo
 	if (!cred)
 		return -ENOMEM;
 
-	cred->fsuid = make_kuid(current_user_ns(), uid);
-	cred->fsgid = make_kgid(current_user_ns(), gid);
+	cred->fsuid = make_kuid(&init_user_ns, uid);
+	cred->fsgid = make_kgid(&init_user_ns, gid);
 
 	gi = groups_alloc(0);
 	if (!gi) {


