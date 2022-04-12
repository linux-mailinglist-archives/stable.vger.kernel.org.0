Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01ADD4FD4EB
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377268AbiDLHta (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358392AbiDLHle (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:41:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C61F84B1CC;
        Tue, 12 Apr 2022 00:17:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0014D616E7;
        Tue, 12 Apr 2022 07:17:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DADCC385A5;
        Tue, 12 Apr 2022 07:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747874;
        bh=1kvO8kzrocGOeyhH3q7quzIPRU0KgSJ0xpJoB6yzKzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=esBlPdLALJWjT52vkc5aH1ml7HLF3JxkGQLt9hcjqQFYNIw3Y+c8CrfmTE/v+Hzmx
         v1bes7OB0H+3Gl4UkDHEAy6EkhRxyusNwhAaq7V0SAV9EQQgHuA7Pq9jIC8dLQMDN3
         W//5IcLguFcegjYDAsj/I/z5cMbDeWrboZCf0OSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyu Tao <tao.lyu@epfl.ch>,
        ChenXiaoSong <chenxiaosong2@huawei.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 197/343] Revert "NFSv4: Handle the special Linux file open access mode"
Date:   Tue, 12 Apr 2022 08:30:15 +0200
Message-Id: <20220412062957.042415016@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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
index d96baa4450e3..e4fb939a2904 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1180,7 +1180,6 @@ int nfs_open(struct inode *inode, struct file *filp)
 	nfs_fscache_open_file(inode, filp);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(nfs_open);
 
 /*
  * This function is called whenever some part of NFS notices that
diff --git a/fs/nfs/nfs4file.c b/fs/nfs/nfs4file.c
index e79ae4cbc395..c178db86a6e8 100644
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



