Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDE014FD1F8
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 09:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351209AbiDLHJy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352184AbiDLHE5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:04:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 083044704E;
        Mon, 11 Apr 2022 23:47:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0CB561093;
        Tue, 12 Apr 2022 06:47:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE8E6C385A6;
        Tue, 12 Apr 2022 06:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746066;
        bh=dXjkIaPMsz25SAGwMF4E8qaFYuUq0/Vrn7edkh+R0UU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SETMTuAMv7b2nSLZcq9yVH5DuD7zgFfiLtD957XPNaKcxC/taFDbAAmIxDBShHmun
         Sem/58fBoqnWcv4ZiFGNpwYhGfRdUPNF8q8NvWP1Pz6syYoFXazP3IW9A19GysOrZB
         t8zrjDeDYKGToUMjwnnUVpepGhnWVEiuL1HtVz4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyu Tao <tao.lyu@epfl.ch>,
        ChenXiaoSong <chenxiaosong2@huawei.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 149/277] Revert "NFSv4: Handle the special Linux file open access mode"
Date:   Tue, 12 Apr 2022 08:29:12 +0200
Message-Id: <20220412062946.348799645@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ChenXiaoSong <chenxiaosong2@huawei.com>

[ Upstream commit ab0fc21bc7105b54bafd85bd8b82742f9e68898a ]

This reverts commit 44942b4e457beda00981f616402a1a791e8c616e.

After secondly opening a file with O_ACCMODE|O_DIRECT flags,
nfs4_valid_open_stateid() will dereference NULL nfs4_state when lseek().

Reproducer:
  1. mount -t nfs -o vers=4.2 $server_ip:/ /mnt/
  2. fd = open("/mnt/file", O_ACCMODE|O_DIRECT|O_CREAT)
  3. close(fd)
  4. fd = open("/mnt/file", O_ACCMODE|O_DIRECT)
  5. lseek(fd)

Reported-by: Lyu Tao <tao.lyu@epfl.ch>
Signed-off-by: ChenXiaoSong <chenxiaosong2@huawei.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c    | 1 -
 fs/nfs/nfs4file.c | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 410f87bc48cc..f4f75db7a825 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1167,7 +1167,6 @@ int nfs_open(struct inode *inode, struct file *filp)
 	nfs_fscache_open_file(inode, filp);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(nfs_open);
 
 /*
  * This function is called whenever some part of NFS notices that
diff --git a/fs/nfs/nfs4file.c b/fs/nfs/nfs4file.c
index c91565227ea2..8f35b5e13e93 100644
--- a/fs/nfs/nfs4file.c
+++ b/fs/nfs/nfs4file.c
@@ -51,7 +51,7 @@ nfs4_file_open(struct inode *inode, struct file *filp)
 		return err;
 
 	if ((openflags & O_ACCMODE) == 3)
-		return nfs_open(inode, filp);
+		openflags--;
 
 	/* We can't create new files here */
 	openflags &= ~(O_CREAT|O_EXCL);
-- 
2.35.1



