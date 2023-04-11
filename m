Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 206976DD016
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 05:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbjDKDVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 23:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjDKDVm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 23:21:42 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07784132
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 20:21:40 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id d22-20020a17090a111600b0023d1b009f52so9541619pja.2
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 20:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681183300; x=1683775300;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9UyhFGYVBO6J2LL0JHf4g4uyhvqbAKlSIet58s8I5Mw=;
        b=as+gRpkS2ZJsv66XY++KMVVSJk6elXBWznBb21aqqmOYACImyQFI4hMaGAlZXIrkwY
         O7LDIC088Vt/2DWEVA2fOPro0M0dSQSQxtoj9ZNcspGmgW/uvcdB7tOhH7AzbK8/8wGd
         HhhmqTEZiTzciNgLKDOz1CjggE9g+8PFEVWMp+uwFBon/1LIuzyigXh/KFRLn49/oRkF
         ww8sYA46QXEgJoIc3f3tDtn4uEbLXYJUJ6jrhWi8Uo8vo00bGP+Kt8MWLy0M3MP+rfQO
         CUQfOZ1jjHJmaHWpSXnFQ54QSmUy3+ZeXJiNstygntA7p6LDPaELUaoliHoz6LSao+7A
         jx6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681183300; x=1683775300;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9UyhFGYVBO6J2LL0JHf4g4uyhvqbAKlSIet58s8I5Mw=;
        b=fIdfqnNm29IEIo+uBYfUDNN3Fatc3HWk0umxOU7ObO28WVYlDMiiQCoj7vRyeEYqiM
         EYKOxK7idLq3ZPj9Q2RXmmoGyZdQ7ICKHXBjXJnwyteT5dR3/5SVKs0bxBZSQulhqDR9
         doIomUMlR2jlJ0MjjjFAip0ZDHtJrIeM5lRH68kJbxbJvxGJ6j3p9NICi7H2fzuaXdr2
         7vmwPLlu6WbnXR84SCt1kk3+VRAIDOYTPQOgLVEMQk6dzhW9KJqRXKAxZ0fCHavjp0Gs
         ntZmQ448HqDnD9yF6GMNjPew7rTQsiqLxCTg4VlTMozgHiGLSvUEa46IW7wUPgOAdBTv
         n77A==
X-Gm-Message-State: AAQBX9fGLCwasMRE5GdM9fP/eE6r+NTKUInuqjpIuWqDfNetXILiUiww
        825Dz3k4qKKiLsoRWXp8y24tsBcoHMcbcA==
X-Google-Smtp-Source: AKy350b3axGkH+SteeL8aTK+zlSIWmI2RG/gUUe+PYcy/Eqh9ac4FLyfexpJRwtxlkz3fgQ/tO6JYA==
X-Received: by 2002:a17:902:e74d:b0:19a:a9d8:e47f with SMTP id p13-20020a170902e74d00b0019aa9d8e47fmr18983315plf.36.1681183300123;
        Mon, 10 Apr 2023 20:21:40 -0700 (PDT)
Received: from localhost.localdomain ([47.96.236.37])
        by smtp.gmail.com with ESMTPSA id m4-20020a63fd44000000b004ff6b744248sm7743195pgj.48.2023.04.10.20.21.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 20:21:39 -0700 (PDT)
From:   Yang Bo <yyyeer.bo@gmail.com>
X-Google-Original-From: Yang Bo <yb203166@antfin.com>
To:     stable@vger.kernel.org
Cc:     Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 4/6] fuse: fix attr version comparison in fuse_read_update_size()
Date:   Tue, 11 Apr 2023 11:21:09 +0800
Message-Id: <20230411032111.1213-4-yb203166@antfin.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230411032111.1213-1-yb203166@antfin.com>
References: <20230411032111.1213-1-yb203166@antfin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit 484ce65715b06aead8c4901f01ca32c5a240bc71 upstream.

[backport for 5.10.y]

A READ request returning a short count is taken as indication of EOF, and
the cached file size is modified accordingly.

Fix the attribute version checking to allow for changes to fc->attr_version
on other inodes.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/fuse/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 504389568dac..94fe2c690676 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -782,7 +782,7 @@ static void fuse_read_update_size(struct inode *inode, loff_t size,
 	struct fuse_inode *fi = get_fuse_inode(inode);
 
 	spin_lock(&fi->lock);
-	if (attr_ver == fi->attr_version && size < inode->i_size &&
+	if (attr_ver >= fi->attr_version && size < inode->i_size &&
 	    !test_bit(FUSE_I_SIZE_UNSTABLE, &fi->state)) {
 		fi->attr_version = atomic64_inc_return(&fc->attr_version);
 		i_size_write(inode, size);
-- 
2.40.0

