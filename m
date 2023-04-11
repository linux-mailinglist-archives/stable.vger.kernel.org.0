Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E58596DD017
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 05:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjDKDVr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 23:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjDKDVq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 23:21:46 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D24410CA
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 20:21:45 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id px4so4477174pjb.3
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 20:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681183304; x=1683775304;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tJoMkdHoZDF4QE/3mJWCsNazezG0uRa2e0KFHHVDxRQ=;
        b=XnS8cRHQYEMLqXlT5IdSyKkAt6YWkv9rfEXIr3doa+a6Guckr6n1KVdnoJORSTfppG
         tulbnnwTfaEBooE/i7DVBBbHcgVIK2iXeX7xERZQUmjF07mSCpfxlj7+193NiiFaXUhj
         IsRjrugICV7adFh+oPuEIqVuaO01y+yZj5LJ13P3q8H66iFuSUj0iERMjkAjB5EyYIgd
         ADXdT9Acy84jAFXqqA/XCmRowPiPW20BPpp6e7ef+35NquGid8VSIXa9pKWW/TU1nGsi
         Dlg7/zEeaAE1il6L0IgiIKAyUvElpsQWEBPnGUO3EejM1AloMWhk1hIzMQGe1yYdDgpx
         tP5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681183304; x=1683775304;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tJoMkdHoZDF4QE/3mJWCsNazezG0uRa2e0KFHHVDxRQ=;
        b=3DbRteq2PuZj7okC0/U7PNgwzuvNW86xUL0M7vzIRfk72DeqlMW1buKHMwSCN1UIlb
         3eLcTLMbCbqQ/vmMx9VBJZt+gCrv7DJlz/X8N/67iYcZbk4WFV/KJ0QmFMNK7hlC2gGB
         F+A3Jc3MYpSFZlRJf+TDqpFnI6QrnwsgErPKsKZ9rBdNpnvIx+hnuTflCExRLI1qNUtR
         nWHXmmo8puZaklxj9mTQGYQ7IC+gsVku2cC/IKhG0QO4O//2QmAW4UpQH/hyHVJLnIBI
         yWblQDOlu48wAkN/745++/8Svdl3hng2B2Ur73HyJM57/gbHJd1dwcdu3ccj7M6rF+Kg
         kYFQ==
X-Gm-Message-State: AAQBX9duEUx0Kh7GWYxRqwfouhjVzzY/q1ybrTGQZi8DmEsKk1z3Og/p
        xsYg3ojZTepX25WWBfjeGkq+TIlkGBNGyw==
X-Google-Smtp-Source: AKy350a+W9gaT9PdcsObLyAWwmnwjz3CGiR2QiuW1JTWC2yZjSsngoxR1o9f3w59UQIemyJRIO6OuA==
X-Received: by 2002:a17:903:1c3:b0:1a3:d392:2f29 with SMTP id e3-20020a17090301c300b001a3d3922f29mr18754560plh.20.1681183304270;
        Mon, 10 Apr 2023 20:21:44 -0700 (PDT)
Received: from localhost.localdomain ([47.96.236.37])
        by smtp.gmail.com with ESMTPSA id m4-20020a63fd44000000b004ff6b744248sm7743195pgj.48.2023.04.10.20.21.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 20:21:43 -0700 (PDT)
From:   Yang Bo <yyyeer.bo@gmail.com>
X-Google-Original-From: Yang Bo <yb203166@antfin.com>
To:     stable@vger.kernel.org
Cc:     Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>,
        Zhang Tianci <zhangtianci.1997@bytedance.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5/6] fuse: always revalidate rename target dentry
Date:   Tue, 11 Apr 2023 11:21:10 +0800
Message-Id: <20230411032111.1213-5-yb203166@antfin.com>
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

From: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>

commit ccc031e26afe60d2a5a3d93dabd9c978210825fb upstream.

[backport for 5.10.y]

The previous commit df8629af2934 ("fuse: always revalidate if exclusive
create") ensures that the dentries are revalidated on O_EXCL creates.  This
commit complements it by also performing revalidation for rename target
dentries.  Otherwise, a rename target file that only exists in kernel
dentry cache but not in the filesystem will result in EEXIST if
RENAME_NOREPLACE flag is used.

Signed-off-by: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Signed-off-by: Zhang Tianci <zhangtianci.1997@bytedance.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/fuse/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 80a9e50392a0..bdb04bea0da9 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -205,7 +205,7 @@ static int fuse_dentry_revalidate(struct dentry *entry, unsigned int flags)
 	if (inode && fuse_is_bad(inode))
 		goto invalid;
 	else if (time_before64(fuse_dentry_time(entry), get_jiffies_64()) ||
-		 (flags & (LOOKUP_EXCL | LOOKUP_REVAL))) {
+		 (flags & (LOOKUP_EXCL | LOOKUP_REVAL | LOOKUP_RENAME_TARGET))) {
 		struct fuse_entry_out outarg;
 		FUSE_ARGS(args);
 		struct fuse_forget_link *forget;
-- 
2.40.0

