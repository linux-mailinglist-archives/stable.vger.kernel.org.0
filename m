Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34A15462639
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbhK2WtB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:49:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234682AbhK2WsO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:48:14 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D45EBC144FDD;
        Mon, 29 Nov 2021 10:33:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5905ACE13DE;
        Mon, 29 Nov 2021 18:33:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050D4C53FC7;
        Mon, 29 Nov 2021 18:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210821;
        bh=3C/rKkiptL+Jw3Rga40jDqWCcCfnE9hvLpo2X7VYOwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QmVcmxxHt/mSnON8AV1NkkeFf9kLPMn8e8xBTnEsTujXWN7M5YlkxoQ7YRl69st+6
         fFedR+t36OeHjnm0vGKdl2I3IVo5ewFDaCOm0L7wjExD82Bpx2TUTUjM8HWda4M0xa
         hzTuoAk+Un6TfS9pz96/nI/taWWJjECdvrWSt5rI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sachin Prabhu <sprabhu@redhat.com>,
        Jeff Layton <jlayton@kernel.org>, Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 104/121] ceph: properly handle statfs on multifs setups
Date:   Mon, 29 Nov 2021 19:18:55 +0100
Message-Id: <20211129181715.158995214@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
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
index f33bfb255db8f..08c8d34c98091 100644
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



