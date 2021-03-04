Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3851632CF52
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 10:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbhCDJKV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 04:10:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234172AbhCDJJ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 04:09:57 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE47C061760;
        Thu,  4 Mar 2021 01:09:17 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id u16so8746635wrt.1;
        Thu, 04 Mar 2021 01:09:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=161KZtAlDNDkL2xZkmWdNftP9DSpz5Gv9P0Bz0LZfOI=;
        b=JPFRmHaQ/M5Y68hjPgnUsWTTW4oXaELplPvHjQoH2t7rnj22N1PG27gschMdR6vits
         tjVNLP0kMfkd/RR3jxNy8mxTKZQGpefGoboI3Lx0BwMdTivRyLncEwjoreCi9G+Hdmt5
         s2c6khZHeyeMbnBQewrgavdtW5WrHvTBZsn5Syicv8AzxbpP+uc/Ny6ELn2VHrln+E/P
         DqxzGX3vKUCFoQeoGYKdBWW7z6Fs3xD8EPZjZmjxfFmemfBGVHJJMi0B+a0s0ja1MNae
         UWdmfQz3EG9mXkiPUa302Nhesm6u48t977+AOjgK3vMCImJuiO9Ans8nxT9xI24EtOdD
         VzRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=161KZtAlDNDkL2xZkmWdNftP9DSpz5Gv9P0Bz0LZfOI=;
        b=eLJMbKGxgJUpQBFZabZGxRtbGhqt4uj4wLnoBzA4WT64Nrf875eH1SBCSoIoloqTFi
         0IZOy8PP04vB3kgNYzhOGwvoBXjXKnwICONBd7lA73LlOM9QTskMrOOs3l2mhEEve60c
         VYRx+eAZeEyIdtNMN36TfNG7CMv0QNLpYGY0kS/5e8Fkf3496hE0Jwevlj+x8EyMBQW5
         mqUCYUKgyJIRALKLhhUdYXaldXl+nTYmFy6Q5lGentDwt39vG5r7rLICh+1HMs8IidL3
         UDkqHTZGwQBMbBgFtliQ81eMdku+z6ssMGEOteyeMOBPOKftQII1Aa0kvdi72mR7Rxsc
         AYJw==
X-Gm-Message-State: AOAM532mtPZ0MQ6zmvb2aGYokfRRrGOc6DAfYuuPU86f45P0ppIWFn2i
        mjO/fOgi2CROmiJGBhYuCJc=
X-Google-Smtp-Source: ABdhPJz2QLDgcCQzGMIF36jixqTS5tBirWOj+a6Hc6BoI0rzp6fVYWI3miZP8LcHqYXH1By0jF5o3Q==
X-Received: by 2002:adf:ed44:: with SMTP id u4mr2842091wro.35.1614848955836;
        Thu, 04 Mar 2021 01:09:15 -0800 (PST)
Received: from localhost.localdomain ([141.226.13.117])
        by smtp.gmail.com with ESMTPSA id m17sm15147234wrx.92.2021.03.04.01.09.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 01:09:15 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] fuse: fix live lock in fuse_iget()
Date:   Thu,  4 Mar 2021 11:09:12 +0200
Message-Id: <20210304090912.3936334-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 5d069dbe8aaf ("fuse: fix bad inode") replaced make_bad_inode()
in fuse_iget() with a private implementation fuse_make_bad().

The private implementation fails to remove the bad inode from inode
cache, so the retry loop with iget5_locked() finds the same bad inode
and marks it bad forever.

kmsg snip:

[ ] rcu: INFO: rcu_sched self-detected stall on CPU
...
[ ]  ? bit_wait_io+0x50/0x50
[ ]  ? fuse_init_file_inode+0x70/0x70
[ ]  ? find_inode.isra.32+0x60/0xb0
[ ]  ? fuse_init_file_inode+0x70/0x70
[ ]  ilookup5_nowait+0x65/0x90
[ ]  ? fuse_init_file_inode+0x70/0x70
[ ]  ilookup5.part.36+0x2e/0x80
[ ]  ? fuse_init_file_inode+0x70/0x70
[ ]  ? fuse_inode_eq+0x20/0x20
[ ]  iget5_locked+0x21/0x80
[ ]  ? fuse_inode_eq+0x20/0x20
[ ]  fuse_iget+0x96/0x1b0

Fixes: 5d069dbe8aaf ("fuse: fix bad inode")
Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Miklos,

This live lock showed up on a stress test in my system after upgarde to
kernel 5.10.  It's 100% reproducible when trying to rsync from a davfs2
filesystem with severel 1000 files.

Thanks,
Amir.

 fs/fuse/fuse_i.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 68cca8d4db6e..63d97a15ffde 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -863,6 +863,7 @@ static inline u64 fuse_get_attr_version(struct fuse_conn *fc)
 
 static inline void fuse_make_bad(struct inode *inode)
 {
+	remove_inode_hash(inode);
 	set_bit(FUSE_I_BAD, &get_fuse_inode(inode)->state);
 }
 
-- 
2.30.0

