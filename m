Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6CD66C86D6
	for <lists+stable@lfdr.de>; Fri, 24 Mar 2023 21:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231959AbjCXU1Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Mar 2023 16:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232122AbjCXU1N (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Mar 2023 16:27:13 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED2B720D3D;
        Fri, 24 Mar 2023 13:26:57 -0700 (PDT)
Received: from fpc.intra.ispras.ru (unknown [10.10.165.3])
        by mail.ispras.ru (Postfix) with ESMTPSA id D7E6940737B7;
        Fri, 24 Mar 2023 20:26:55 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru D7E6940737B7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1679689615;
        bh=SD9ABHl1mnNNgCo/hHrrR+sNtq8mwXQEIZPV990DhHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C6Au3DZFokbzNm7a1WS8g6mB3QniPlTKbsm/vnhwK0zrsoKQH+PHtVxGiOgC3Ouvx
         ab2RGYAa3pf5PdsGUUruZo5B+fhbqRwvkenAcZFTjIgqHOfFRtcwYz1Hv98qykJlBX
         jR6NBWdaXKiMjN4VZureah2b2b2/wp4YkzrWk4eQ=
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        cluster-devel@redhat.com, linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org,
        syzbot+7bb81dfa9cda07d9cd9d@syzkaller.appspotmail.com
Subject: [PATCH v2 4.19/5.4/5.10 1/1] gfs2: Always check inode size of inline inodes
Date:   Fri, 24 Mar 2023 23:26:15 +0300
Message-Id: <20230324202615.330615-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230324201933.329885-2-pchelkin@ispras.ru>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

commit 70376c7ff31221f1d21db5611d8209e677781d3a upstream.

Check if the inode size of stuffed (inline) inodes is within the allowed
range when reading inodes from disk (gfs2_dinode_in()).  This prevents
us from on-disk corruption.

The two checks in stuffed_readpage() and gfs2_unstuffer_page() that just
truncate inline data to the maximum allowed size don't actually make
sense, and they can be removed now as well.

Reported-by: syzbot+7bb81dfa9cda07d9cd9d@syzkaller.appspotmail.com
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
[pchelkin@ispras.ru: adjust the inode variable inside gfs2_dinode_in with
the format used before upstream commit 7db354444ad8 ("gfs2: Cosmetic
gfs2_dinode_{in,out} cleanup")]
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
---
v2: add missed From: tag

 fs/gfs2/aops.c  | 2 --
 fs/gfs2/bmap.c  | 3 ---
 fs/gfs2/glops.c | 3 +++
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 530659554870..a0430da033b3 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -451,8 +451,6 @@ static int stuffed_readpage(struct gfs2_inode *ip, struct page *page)
 		return error;
 
 	kaddr = kmap_atomic(page);
-	if (dsize > gfs2_max_stuffed_size(ip))
-		dsize = gfs2_max_stuffed_size(ip);
 	memcpy(kaddr, dibh->b_data + sizeof(struct gfs2_dinode), dsize);
 	memset(kaddr + dsize, 0, PAGE_SIZE - dsize);
 	kunmap_atomic(kaddr);
diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index b4fde3a8eeb4..eaee95d2ad14 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -69,9 +69,6 @@ static int gfs2_unstuffer_page(struct gfs2_inode *ip, struct buffer_head *dibh,
 		void *kaddr = kmap(page);
 		u64 dsize = i_size_read(inode);
  
-		if (dsize > gfs2_max_stuffed_size(ip))
-			dsize = gfs2_max_stuffed_size(ip);
-
 		memcpy(kaddr, dibh->b_data + sizeof(struct gfs2_dinode), dsize);
 		memset(kaddr + dsize, 0, PAGE_SIZE - dsize);
 		kunmap(page);
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index bf539eab92c6..db28c240dae3 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -454,6 +454,9 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 	ip->i_depth = (u8)depth;
 	ip->i_entries = be32_to_cpu(str->di_entries);
 
+	if (gfs2_is_stuffed(ip) && ip->i_inode.i_size > gfs2_max_stuffed_size(ip))
+		goto corrupt;
+
 	if (S_ISREG(ip->i_inode.i_mode))
 		gfs2_set_aops(&ip->i_inode);
 
-- 
2.34.1

