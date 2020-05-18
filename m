Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E16C1D85CF
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730327AbgERRvl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:51:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:54444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730330AbgERRvh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:51:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA0FD20829;
        Mon, 18 May 2020 17:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824297;
        bh=SH8FZeK1r0kMgLiWFQS1MyVZECWgi/jMC86bQKXOmz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NRMXiK2yxZvQ5bdkT6uQxFJ2yGe7d7FGSNmqLi1VaVKVJP3xdgG/aCtpnJ7SKgrBX
         aOh0OBMV/xp8vi5jL1+NkQaqfPV+zzyQpUdUyqkR8O6XAdqfOstP1/faljnuq5YgDN
         adVEZU69luHUom3GcMSHAaR0uW376Y3RN8nyIwi8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Wysochanski <dwysocha@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 36/80] NFS: Fix fscache super_cookie index_key from changing after umount
Date:   Mon, 18 May 2020 19:36:54 +0200
Message-Id: <20200518173457.689854455@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.097837707@linuxfoundation.org>
References: <20200518173450.097837707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Wysochanski <dwysocha@redhat.com>

[ Upstream commit d9bfced1fbcb35b28d8fbed4e785d2807055ed2b ]

Commit 402cb8dda949 ("fscache: Attach the index key and aux data to
the cookie") added the index_key and index_key_len parameters to
fscache_acquire_cookie(), and updated the callers in the NFS client.
One of the callers was inside nfs_fscache_get_super_cookie()
and was changed to use the full struct nfs_fscache_key as the
index_key.  However, a couple members of this structure contain
pointers and thus will change each time the same NFS share is
remounted.  Since index_key is used for fscache_cookie->key_hash
and this subsequently is used to compare cookies, the effectiveness
of fscache with NFS is reduced to the point at which a umount
occurs.   Any subsequent remount of the same share will cause a
unique NFS super_block index_key and key_hash to be generated for
the same data, rendering any prior fscache data unable to be
found.  A simple reproducer demonstrates the problem.

1. Mount share with 'fsc', create a file, drop page cache
systemctl start cachefilesd
mount -o vers=3,fsc 127.0.0.1:/export /mnt
dd if=/dev/zero of=/mnt/file1.bin bs=4096 count=1
echo 3 > /proc/sys/vm/drop_caches

2. Read file into page cache and fscache, then unmount
dd if=/mnt/file1.bin of=/dev/null bs=4096 count=1
umount /mnt

3. Remount and re-read which should come from fscache
mount -o vers=3,fsc 127.0.0.1:/export /mnt
echo 3 > /proc/sys/vm/drop_caches
dd if=/mnt/file1.bin of=/dev/null bs=4096 count=1

4. Check for READ ops in mountstats - there should be none
grep READ: /proc/self/mountstats

Looking at the history and the removed function, nfs_super_get_key(),
we should only use nfs_fscache_key.key plus any uniquifier, for
the fscache index_key.

Fixes: 402cb8dda949 ("fscache: Attach the index key and aux data to the cookie")
Signed-off-by: Dave Wysochanski <dwysocha@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/fscache.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/fscache.c b/fs/nfs/fscache.c
index 6f45b1a957397..b931169c2bb24 100644
--- a/fs/nfs/fscache.c
+++ b/fs/nfs/fscache.c
@@ -192,7 +192,8 @@ void nfs_fscache_get_super_cookie(struct super_block *sb, const char *uniq, int
 	/* create a cache index for looking up filehandles */
 	nfss->fscache = fscache_acquire_cookie(nfss->nfs_client->fscache,
 					       &nfs_fscache_super_index_def,
-					       key, sizeof(*key) + ulen,
+					       &key->key,
+					       sizeof(key->key) + ulen,
 					       NULL, 0,
 					       nfss, 0, true);
 	dfprintk(FSCACHE, "NFS: get superblock cookie (0x%p/0x%p)\n",
-- 
2.20.1



