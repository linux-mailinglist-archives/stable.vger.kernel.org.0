Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 784631F00A
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732573AbfEOL33 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:29:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:40740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732567AbfEOL32 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:29:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71333206BF;
        Wed, 15 May 2019 11:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919767;
        bh=bo2UtT2k7fWxaEc+u2jNhBaK8V60o38IELfNNJ/vodQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nw/g0+3Mc1dxFQ1rCSwOyAqro0Fx2h2C2Ukc6mrgjf1PX5KhF3UZFDM4ubONUfCm4
         EXI6VhWQNIJKwO2eC5QT4jwW2WM+VKtEmBwoYOnAuZ9BbpQ6EpyXunl7fclHQFDKgb
         T4wQSxkmmF/M8xU6qkD6lsh42lCk9N+JLKCD9uVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        "Yan, Zheng" <zyan@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 087/137] ceph: handle the case where a dentry has been renamed on outstanding req
Date:   Wed, 15 May 2019 12:56:08 +0200
Message-Id: <20190515090659.839349474@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 4b8222870032715f9d995f3eb7c7acd8379a275d ]

It's possible for us to issue a lookup to revalidate a dentry
concurrently with a rename. If done in the right order, then we could
end up processing dentry info in the reply that no longer reflects the
state of the dentry.

If req->r_dentry->d_name differs from the one in the trace, then just
ignore the trace in the reply. We only need to do this however if the
parent's i_rwsem is not held.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: "Yan, Zheng" <zyan@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/inode.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index f7f9e305aaf87..fd3db2e112d6e 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1152,6 +1152,19 @@ static int splice_dentry(struct dentry **pdn, struct inode *in)
 	return 0;
 }
 
+static int d_name_cmp(struct dentry *dentry, const char *name, size_t len)
+{
+	int ret;
+
+	/* take d_lock to ensure dentry->d_name stability */
+	spin_lock(&dentry->d_lock);
+	ret = dentry->d_name.len - len;
+	if (!ret)
+		ret = memcmp(dentry->d_name.name, name, len);
+	spin_unlock(&dentry->d_lock);
+	return ret;
+}
+
 /*
  * Incorporate results into the local cache.  This is either just
  * one inode, or a directory, dentry, and possibly linked-to inode (e.g.,
@@ -1401,7 +1414,8 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 		err = splice_dentry(&req->r_dentry, in);
 		if (err < 0)
 			goto done;
-	} else if (rinfo->head->is_dentry) {
+	} else if (rinfo->head->is_dentry &&
+		   !d_name_cmp(req->r_dentry, rinfo->dname, rinfo->dname_len)) {
 		struct ceph_vino *ptvino = NULL;
 
 		if ((le32_to_cpu(rinfo->diri.in->cap.caps) & CEPH_CAP_FILE_SHARED) ||
-- 
2.20.1



