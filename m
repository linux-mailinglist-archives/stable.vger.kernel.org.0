Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBB75591E61
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 07:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbiHNFO0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 01:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiHNFOZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 01:14:25 -0400
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A0B11E3C5;
        Sat, 13 Aug 2022 22:14:25 -0700 (PDT)
Received: by mail-pf1-f173.google.com with SMTP id q19so4266344pfg.8;
        Sat, 13 Aug 2022 22:14:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=14NPMXyjjrXGjW8hanxzbHCYc24FuB+QqAulXXLKvvY=;
        b=7ghYEeEwVwdBePCfjIC2yHz/J0S7Hmv5v8+MPOjg4QXvp+LlAwxN1UNN5vyWK/+zof
         enm6QmxFiH6GgQh0Gc4+dxyOJvL97DJtdjMZJUTs4kKnBRZra1E3qZYDpH4xlrzlsSvR
         dQYW7QEw3m8C0oujVYHyjMJHiZqWavBvRIqfYWGsHp8DzD5lthqTQklV8xJFc5WsOX7W
         AH2h1hsPdJWop/HtwQMNOkcdp46XoBxZjsnyVkAz8X+mKxEejaVlKpDrg1KgTOizspZb
         eDHKWaUxXilbdDlLXiX7CLQ8/P46jDZ7IHwDFvcISLQUDlELCN+jMsH1WRKE9hW+KpOg
         waLg==
X-Gm-Message-State: ACgBeo2XGFvkilJwfcbPoRzreKhgfZvSDXQaHwm1SKdStA7Yb4kj8DNE
        pgHjotYQO+V2KzR+V/aKIPzTZZeRxX4=
X-Google-Smtp-Source: AA6agR4Q6oEq3zTcdn6Dj149eLmZq8xWzocxdWcstQO+W571NufzVQGhWXGV0cskzifOPWn6mNLeeg==
X-Received: by 2002:a05:6a00:1bcb:b0:52e:d2ca:1b5a with SMTP id o11-20020a056a001bcb00b0052ed2ca1b5amr10710906pfw.16.1660454064036;
        Sat, 13 Aug 2022 22:14:24 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id p123-20020a634281000000b0041c9a4001ebsm3790376pga.21.2022.08.13.22.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Aug 2022 22:14:23 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, hyc.lee@gmail.com, senozhatsky@chromium.org,
        Namjae Jeon <linkinjeon@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v2] ksmbd: don't remove dos attribute xattr on O_TRUNC open
Date:   Sun, 14 Aug 2022 14:04:33 +0900
Message-Id: <20220814050433.7458-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When smb client open file in ksmbd share with O_TRUNC, dos attribute
xattr is removed as well as data in file. This cause the FSCTL_SET_SPARSE
request from the client fails because ksmbd can't update the dos attribute
after setting ATTR_SPARSE_FILE. And this patch fix xfstests generic/469
test also.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 v2:
   - don't remove other xattr class also.
   - add fixes and stable tags.

 fs/ksmbd/smb2pdu.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index a136d5e4943b..c2daef28a214 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -2330,10 +2330,9 @@ static int smb2_remove_smb_xattrs(struct path *path)
 			name += strlen(name) + 1) {
 		ksmbd_debug(SMB, "%s, len %zd\n", name, strlen(name));
 
-		if (strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN) &&
-		    strncmp(&name[XATTR_USER_PREFIX_LEN], DOS_ATTRIBUTE_PREFIX,
-			    DOS_ATTRIBUTE_PREFIX_LEN) &&
-		    strncmp(&name[XATTR_USER_PREFIX_LEN], STREAM_PREFIX, STREAM_PREFIX_LEN))
+		if (strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN) ||
+		    (!strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN) &&
+		     strncmp(&name[XATTR_USER_PREFIX_LEN], STREAM_PREFIX, STREAM_PREFIX_LEN)))
 			continue;
 
 		err = ksmbd_vfs_remove_xattr(user_ns, path->dentry, name);
-- 
2.25.1

