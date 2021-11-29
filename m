Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48669461F61
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379294AbhK2Sqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:46:39 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:57366 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380220AbhK2Soh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:44:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 33EDECE13E1;
        Mon, 29 Nov 2021 18:41:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D74D3C53FCD;
        Mon, 29 Nov 2021 18:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211273;
        bh=VxFlGMY1AF1Ci7KMB+BcjGhAZ8n6HWvrxLtzP0CF9XA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MsT8/r2FCwh1d4rukH3MOG1UmfIkV30VI04a/irs/HXksYaN71/NOWmDlMaWUSd7Z
         tGmao6+3imSS0Ton/9WozMI0AvsIELNC+IxiSFSKjyL5/LTpRcfRlExxD5QSxKcifE
         wquD+KbcSXDDtzmVBwSG2ElFTl69kUrQHOcZ0Ux0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sachin Prabhu <sprabhu@redhat.com>,
        Jeff Layton <jlayton@kernel.org>, Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 165/179] ceph: properly handle statfs on multifs setups
Date:   Mon, 29 Nov 2021 19:19:19 +0100
Message-Id: <20211129181724.365520329@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 8cfc0c7ed34f7929ce7e5d7c6eecf4d01ba89a84 ]

ceph_statfs currently stuffs the cluster fsid into the f_fsid field.
This was fine when we only had a single filesystem per cluster, but now
that we have multiples we need to use something that will vary between
them.

Change ceph_statfs to xor each 32-bit chunk of the fsid (aka cluster id)
into the lower bits of the statfs->f_fsid. Change the lower bits to hold
the fscid (filesystem ID within the cluster).

That should give us a value that is guaranteed to be unique between
filesystems within a cluster, and should minimize the chance of
collisions between mounts of different clusters.

URL: https://tracker.ceph.com/issues/52812
Reported-by: Sachin Prabhu <sprabhu@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/super.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index fd8742bae8471..202ddde3d62ad 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -52,8 +52,7 @@ static int ceph_statfs(struct dentry *dentry, struct kstatfs *buf)
 	struct ceph_fs_client *fsc = ceph_inode_to_client(d_inode(dentry));
 	struct ceph_mon_client *monc = &fsc->client->monc;
 	struct ceph_statfs st;
-	u64 fsid;
-	int err;
+	int i, err;
 	u64 data_pool;
 
 	if (fsc->mdsc->mdsmap->m_num_data_pg_pools == 1) {
@@ -99,12 +98,14 @@ static int ceph_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_namelen = NAME_MAX;
 
 	/* Must convert the fsid, for consistent values across arches */
+	buf->f_fsid.val[0] = 0;
 	mutex_lock(&monc->mutex);
-	fsid = le64_to_cpu(*(__le64 *)(&monc->monmap->fsid)) ^
-	       le64_to_cpu(*((__le64 *)&monc->monmap->fsid + 1));
+	for (i = 0 ; i < sizeof(monc->monmap->fsid) / sizeof(__le32) ; ++i)
+		buf->f_fsid.val[0] ^= le32_to_cpu(((__le32 *)&monc->monmap->fsid)[i]);
 	mutex_unlock(&monc->mutex);
 
-	buf->f_fsid = u64_to_fsid(fsid);
+	/* fold the fs_cluster_id into the upper bits */
+	buf->f_fsid.val[1] = monc->fs_cluster_id;
 
 	return 0;
 }
-- 
2.33.0



