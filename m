Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C713D541CF9
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382904AbiFGWHS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383640AbiFGWGF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:06:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6F3419597C;
        Tue,  7 Jun 2022 12:16:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5BA9AB8237B;
        Tue,  7 Jun 2022 19:16:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B94B0C385A5;
        Tue,  7 Jun 2022 19:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629414;
        bh=cS/PCrKP+OTSk8TnOzP6IK71ttgEcg004RYgis44HMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UvqfM0MAhL9aVQKa8PMbOOf18PB89oVI2GHPbBAO+2S9/eniga0PkW6nkisfy2zf7
         anBfLENQFe7iJf2KLPJyZdCyf32y7jm8QZmWcWmaxft+9TgMiBIkVcLuhtnJTCup24
         wQNyiSB2n9x1MGUnpdPHJphWkWGf3peYAQjFXU7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Wysochanski <dwysocha@redhat.com>,
        Daire Byrne <daire@dneg.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 683/879] NFS: Pass i_size to fscache_unuse_cookie() when a file is released
Date:   Tue,  7 Jun 2022 19:03:21 +0200
Message-Id: <20220607165022.670982025@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Wysochanski <dwysocha@redhat.com>

[ Upstream commit 9c4a5c75a62e83963083efd4eea5d5bd1583193c ]

Pass updated i_size in fscache_unuse_cookie() when called
from nfs_fscache_release_file(), which ensures the size of
an fscache object gets written to the cache storage.  Failing
to do so results in unnessary reads from the NFS server, even
when the data is cached, due to a cachefiles object coherency
check failing with a trace similar to the following:
  cachefiles_coherency: o=0000000e BAD osiz B=afbb3 c=0

This problem can be reproduced as follows:
  #!/bin/bash
  v=4.2; NFS_SERVER=127.0.0.1
  set -e; trap cleanup EXIT; rc=1
  function cleanup {
          umount /mnt/nfs > /dev/null 2>&1
          RC_STR="TEST PASS"
          [ $rc -eq 1 ] && RC_STR="TEST FAIL"
          echo "$RC_STR on $(uname -r) with NFSv$v and server $NFS_SERVER"
  }
  mount -o vers=$v,fsc $NFS_SERVER:/export /mnt/nfs
  rm -f /mnt/nfs/file1.bin > /dev/null 2>&1
  dd if=/dev/zero of=/mnt/nfs/file1.bin bs=4096 count=1 > /dev/null 2>&1
  echo 3 > /proc/sys/vm/drop_caches
  echo Read file 1st time from NFS server into fscache
  dd if=/mnt/nfs/file1.bin of=/dev/null > /dev/null 2>&1
  umount /mnt/nfs && mount -o vers=$v,fsc $NFS_SERVER:/export /mnt/nfs
  echo 3 > /proc/sys/vm/drop_caches
  echo Read file 2nd time from fscache
  dd if=/mnt/nfs/file1.bin of=/dev/null > /dev/null 2>&1
  echo Check mountstats for NFS read
  grep -q "READ: 0" /proc/self/mountstats # (1st number) == 0
  [ $? -eq 0 ] && rc=0

Fixes: a6b5a28eb56c "nfs: Convert to new fscache volume/cookie API"
Signed-off-by: Dave Wysochanski <dwysocha@redhat.com>
Tested-by: Daire Byrne <daire@dneg.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/fscache.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/fscache.c b/fs/nfs/fscache.c
index f73c09a9cf0a..e861d7bae305 100644
--- a/fs/nfs/fscache.c
+++ b/fs/nfs/fscache.c
@@ -231,11 +231,10 @@ void nfs_fscache_release_file(struct inode *inode, struct file *filp)
 {
 	struct nfs_fscache_inode_auxdata auxdata;
 	struct fscache_cookie *cookie = nfs_i_fscache(inode);
+	loff_t i_size = i_size_read(inode);
 
-	if (fscache_cookie_valid(cookie)) {
-		nfs_fscache_update_auxdata(&auxdata, inode);
-		fscache_unuse_cookie(cookie, &auxdata, NULL);
-	}
+	nfs_fscache_update_auxdata(&auxdata, inode);
+	fscache_unuse_cookie(cookie, &auxdata, &i_size);
 }
 
 /*
-- 
2.35.1



