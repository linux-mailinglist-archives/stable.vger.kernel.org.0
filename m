Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4386BF971
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 11:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbjCRKQO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Mar 2023 06:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbjCRKQB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Mar 2023 06:16:01 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C562392B6;
        Sat, 18 Mar 2023 03:15:59 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id c8-20020a05600c0ac800b003ed2f97a63eso6419992wmr.3;
        Sat, 18 Mar 2023 03:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679134558;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fHjSWW/YZEGEGz44nnM9t/++2Yb+yS/AmGPiI8kwmpU=;
        b=l8Ua+bKX5fGvv0MYSPpTTcyP8HkXfmSEgfep+W5+19RyD7IsF+RZF/oHC6GtXz7g1L
         Nx82ja9W/XG0zztQgCynC5FBzxIZ7pAufeop9pg9QRvpYGv0wt97Qc6Tm46CbArbOKx+
         McGbJR/Vd9ranrh5vssV/EC1jeCvwAYRrwOn51A9Tp93nxDpIRjVl9x/dpP2cDgPxEZw
         jkPZvUKv28H3BL0S35Y0UTCej2uVenT+ej+ilLXrhg1qg47jyl6IEQn7yK4OewMRf3d5
         MWqsPL80mvKNhm5Xb6hfUMwHlJITljehsGcxc+zyPL/7QfaETLOB9wBLc0tL1yQb9isa
         37Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679134558;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fHjSWW/YZEGEGz44nnM9t/++2Yb+yS/AmGPiI8kwmpU=;
        b=Y8FZsWQr2twNMr/LFSytaf/dH230FGv4BSzxN2dXPM4ys1wYRXcse9PjND3jGIaw/T
         IaCCN7x0uYIKQwVd7eQA0JWzIDzBXqBFDcQnvbXWEsYzK5K3KE0HyqI7DuMJmZ0SoOTX
         zXNbZoyAYuGoYFSD+xOpfZeQcSN4a7shhofFPpnIg74BB3My0mhPMI/ttoAP4eOLOHKy
         2cJn8Rhd8CxGyvgpkg2m3pCuhRsX3Em3qIbIN+uHSYJIkuZUhDjcp02WpH130RnXrine
         cOSf0i526m+g85+sIJGKdo5JqK/cTULNGMvZGNT24EA3INEHJOqKVrmI5xs/ZFUMrudY
         xe2w==
X-Gm-Message-State: AO0yUKVNXYvoTsYwEi4caBg6lK/Nbg0e1dFDVCFx3ML7WD70CP+poc/z
        x03hEJiGgdLAlnQYW258EQoDlsEwUU4=
X-Google-Smtp-Source: AK7set/8cGeWnyT/kjwQEnZZrYLFcw5MaspMjNHWhsV5r485by8ve6ax7iyRNb9YE5SGrcK1K7PS7Q==
X-Received: by 2002:a05:600c:548d:b0:3eb:2da5:e19 with SMTP id iv13-20020a05600c548d00b003eb2da50e19mr27182285wmb.27.1679134558462;
        Sat, 18 Mar 2023 03:15:58 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id v26-20020a05600c215a00b003eafc47eb09sm4333965wml.43.2023.03.18.03.15.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Mar 2023 03:15:58 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Christian Brauner <brauner@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>
Subject: [PATCH 5.10 14/15] fs: use consistent setgid checks in is_sxid()
Date:   Sat, 18 Mar 2023 12:15:28 +0200
Message-Id: <20230318101529.1361673-15-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230318101529.1361673-1-amir73il@gmail.com>
References: <20230318101529.1361673-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <brauner@kernel.org>

commit 8d84e39d76bd83474b26cb44f4b338635676e7e8 upstream.

Now that we made the VFS setgid checking consistent an inode can't be
marked security irrelevant even if the setgid bit is still set. Make
this function consistent with all other helpers.

Note that enforcing consistent setgid stripping checks for file
modification and mode- and ownership changes will cause the setgid bit
to be lost in more cases than useed to be the case. If an unprivileged
user wrote to a non-executable setgid file that they don't have
privilege over the setgid bit will be dropped. This will lead to
temporary failures in some xfstests until they have been updated.

Reported-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 include/linux/fs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 57afa4fa5e7b..8ce9e5c61ede 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3408,7 +3408,7 @@ int __init get_filesystem_list(char *buf);
 
 static inline bool is_sxid(umode_t mode)
 {
-	return (mode & S_ISUID) || ((mode & S_ISGID) && (mode & S_IXGRP));
+	return mode & (S_ISUID | S_ISGID);
 }
 
 static inline int check_sticky(struct inode *dir, struct inode *inode)
-- 
2.34.1

