Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 593E241F40C
	for <lists+stable@lfdr.de>; Fri,  1 Oct 2021 19:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355277AbhJAR7F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Oct 2021 13:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238784AbhJAR7F (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Oct 2021 13:59:05 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7159C061775
        for <stable@vger.kernel.org>; Fri,  1 Oct 2021 10:57:20 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id a14so6065097qvb.6
        for <stable@vger.kernel.org>; Fri, 01 Oct 2021 10:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KAfCc84fA0nl5BgNa75JtikHfoT6ZhgcNsqO1iw6/ek=;
        b=JXukKVBFJGtJqtavWeTK1v8+7CHobkkn6JVhcQiHMU+rTk7imHZpfAmg0v/NdhDGwX
         Q8LXLWrijcrObhhqAXednMba7FfY3pDuijhUOpHSXCKO2K3a6MDEm0enXlpr9/GDbSP9
         xuvfPE6hm5BfwAEDURLdzxDHqq4l5BSkOs85A8AOyAFGF9aMJ5FzX9A9lFt+AqVNMCDW
         jzxtPkFoZcmaxw/+xVYOPMYOkqtIaaqt45qamROR1WacrAz3HNHWORUdWFeitSC70iUx
         xr9Eovywy9x0/K+7X8Gkx8O+JkVskw8l60E59PioNT8fiOEHl3fr001kq4l9xF6i/s7J
         x0PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KAfCc84fA0nl5BgNa75JtikHfoT6ZhgcNsqO1iw6/ek=;
        b=U3k8Im+KIz44B5O8TLCzFKPcHyhYlgKFCo6Ouc6pcyWMl805QFRQAZmaUpl6FCyPgm
         b/26k4UxHEXfdrhAnHLm0T0ta2uOydRYApND8CShy76o60nnV9oXMClClVN6GN02DG6G
         hBcLl2d2RSLS73uPpkH6lO0/LMR/Lvv5VL+T8zT2yjI6yUXDom5rwaY9SVcVoLZMHnud
         tzff3fWDI1tnmkLhBln7aDvLH7XeZQ7dyHIMmA9mAHdhnDxHlCeBxQZZgxbpmfs5rkhM
         2tpNe8EqhM1S3jS1iiKEVN5P3eEZm0sDUWJ1TNVOj4656h8tI66Adr2fSJnYR9FqIz2S
         BkFQ==
X-Gm-Message-State: AOAM531mgCkxyIgWzArvAEfo8fwt7Rk4FPdqbBa7VY4nONT6B8MSo/pf
        77oSQ9uoXfXEa1V7WsZSCh4iLw==
X-Google-Smtp-Source: ABdhPJzBTZqHpZkn0pxqF20tCDWxLRS6Kn+a2huP3pBc6pc+2OHwgOOYzTvhZxki8yzeG2nabJmhTw==
X-Received: by 2002:ad4:554a:: with SMTP id v10mr2233548qvy.29.1633111039867;
        Fri, 01 Oct 2021 10:57:19 -0700 (PDT)
Received: from localhost (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id v3sm3330640qkf.131.2021.10.01.10.57.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 10:57:19 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     stable@vger.kernel.org
Subject: [PATCH] btrfs: update refs for any root except tree log roots
Date:   Fri,  1 Oct 2021 13:57:18 -0400
Message-Id: <3b6169b5a9b7bda03e14bcc7e10f8dcda5e92374.1633111027.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I hit a stuck relocation on btrfs/061 during my overnight testing.  This
turned out to be because we had left over extent entries in our extent
root for a data reloc inode that no longer existed.  This happened
because in btrfs_drop_extents() we only update refs if we have SHAREABLE
set or we are the tree_root.  This regression was introduced by
aeb935a45581 ("btrfs: don't set SHAREABLE flag for data reloc tree")
where we stopped setting SHAREABLE for the data reloc tree.

The problem here is we actually do want to update extent references for
data extents in the data reloc tree, in fact we only don't want to
update extent references if the file extents are in the log tree.
Update this check to only skip updating references in the case of the
log tree.

This is relatively rare, because you have to be running scrub at the
same time, which is what btrfs/061 does.  The data reloc inode has its
extents pre-allcated, and then we copy the extent into the pre-allocated
chunks.  We theoretically should never be calling btrfs_drop_extents()
on a data reloc inode.  The exception of course is with scrub, if our
pre-allocated extent falls inside of the block group we are scrubbing,
then the block group will be marked read only and we will be forced to
cow that extent.  This means we will call btrfs_drop_extents() on that
range when we cow that file extent.

This isn't really problematic if we do this, the data reloc inode
requires that our extent lengths match exactly with the extent we are
copying, thankfully we validate the extent is correct with
get_new_location(), so if we happen to cow only part of the extent we
won't link it in when we do the relocation, so we are safe from any
other shenanigans that arise because of this interaction with scrub.

cc: stable@vger.kernel.org
Fixes: aeb935a45581 ("btrfs: don't set SHAREABLE flag for data reloc tree")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/file.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 04e29b40a38e..b7d3559efcf7 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -734,8 +734,7 @@ int btrfs_drop_extents(struct btrfs_trans_handle *trans,
 	if (args->start >= inode->disk_i_size && !args->replace_extent)
 		modify_tree = 0;
 
-	update_refs = (test_bit(BTRFS_ROOT_SHAREABLE, &root->state) ||
-		       root == fs_info->tree_root);
+	update_refs = root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID;
 	while (1) {
 		recow = 0;
 		ret = btrfs_lookup_file_extent(trans, root, path, ino,
-- 
2.26.3

