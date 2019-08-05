Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1E9781D1E
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730512AbfHENVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:21:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:57562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728851AbfHENVX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:21:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0DB1216F4;
        Mon,  5 Aug 2019 13:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011282;
        bh=FuBGDNNK8p8tYaQ8YF4Q3siKw/WfvD2wT8BfowIaAVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kbYhn8VW0+oxmiY53kR2Zlyj9Ueen1iNfog1zO1z7kgsSluatYK9W2nswEy0nBQDS
         jB4f1m5+69oDWNmcXRE7s/jb2jDPby05LjHRq2t399w6Ak52J33TCToPzvYr5bLZuq
         pxh6Oe6PGl2G1xsIQ53ZVz/qwvwHOEWklDW4Afpk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Yan, Zheng" <zyan@redhat.com>,
        Jeff Layton <jlayton@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 033/131] ceph: fix dir_lease_is_valid()
Date:   Mon,  5 Aug 2019 15:02:00 +0200
Message-Id: <20190805124953.649120015@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit feab6ac25dbfe3ab96299cb741925dc8d2da0caf ]

It should call __ceph_dentry_dir_lease_touch() under dentry->d_lock.
Besides, ceph_dentry(dentry) can be NULL when called by LOOKUP_RCU
d_revalidate()

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
Reviewed-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/dir.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 0637149fb9f9a..1271024a3797a 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1512,18 +1512,26 @@ static int __dir_lease_try_check(const struct dentry *dentry)
 static int dir_lease_is_valid(struct inode *dir, struct dentry *dentry)
 {
 	struct ceph_inode_info *ci = ceph_inode(dir);
-	struct ceph_dentry_info *di = ceph_dentry(dentry);
-	int valid = 0;
+	int valid;
+	int shared_gen;
 
 	spin_lock(&ci->i_ceph_lock);
-	if (atomic_read(&ci->i_shared_gen) == di->lease_shared_gen)
-		valid = __ceph_caps_issued_mask(ci, CEPH_CAP_FILE_SHARED, 1);
+	valid = __ceph_caps_issued_mask(ci, CEPH_CAP_FILE_SHARED, 1);
+	shared_gen = atomic_read(&ci->i_shared_gen);
 	spin_unlock(&ci->i_ceph_lock);
-	if (valid)
-		__ceph_dentry_dir_lease_touch(di);
-	dout("dir_lease_is_valid dir %p v%u dentry %p v%u = %d\n",
-	     dir, (unsigned)atomic_read(&ci->i_shared_gen),
-	     dentry, (unsigned)di->lease_shared_gen, valid);
+	if (valid) {
+		struct ceph_dentry_info *di;
+		spin_lock(&dentry->d_lock);
+		di = ceph_dentry(dentry);
+		if (dir == d_inode(dentry->d_parent) &&
+		    di && di->lease_shared_gen == shared_gen)
+			__ceph_dentry_dir_lease_touch(di);
+		else
+			valid = 0;
+		spin_unlock(&dentry->d_lock);
+	}
+	dout("dir_lease_is_valid dir %p v%u dentry %p = %d\n",
+	     dir, (unsigned)atomic_read(&ci->i_shared_gen), dentry, valid);
 	return valid;
 }
 
-- 
2.20.1



