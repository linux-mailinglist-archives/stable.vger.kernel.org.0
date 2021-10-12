Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA36242A66B
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 15:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236983AbhJLNvT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 09:51:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:37596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236678AbhJLNvS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Oct 2021 09:51:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A9D560E94;
        Tue, 12 Oct 2021 13:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634046557;
        bh=9Rof50k2Sv02JNsI7ZJJR3+5T9qYRDelDKQP/S/zH/o=;
        h=From:To:Cc:Subject:Date:From;
        b=N7khJdh2SD8SIFM31pTXxRaPkvWkLgO9qBRqcQYgdhVQRk7r2WDjFS0rS/cIjWP6W
         lEsckCCNWn0ztyCT90EYe64Z/w8AddmbYOnbLudmzvCaAG44lvNFpjMH2SeZVct/iO
         nZSLJJD4qotDkrvmQLm4+ImTKmlZpj/c71OAGxJwg33axG9RbF7ot4Cfq/94NooJxG
         HNzs+6TJnSl5KHfCMao3WboN3BdyfUPO000P6imPzOodWFNNxggK5C0SmuvCm45JjQ
         IlEimGGIOtkQjaXl3tU9j05suuYCtgEdnOUXArB1imPTp93li+pq0g1JnjTN2cTJwa
         TGT4swk8RZg/g==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, Patrick Donnelly <pdonnell@redhat.com>,
        Niels de Vos <ndevos@redhat.com>,
        "Yan, Zheng" <ukernel@gmail.com>, stable@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3] ceph: skip existing superblocks that are blocklisted or shut down when mounting
Date:   Tue, 12 Oct 2021 09:49:15 -0400
Message-Id: <20211012134915.38994-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently when mounting, we may end up finding an existing superblock
that corresponds to a blocklisted MDS client. This means that the new
mount ends up being unusable.

If we've found an existing superblock with a client that is already
blocklisted, and the client is not configured to recover on its own,
fail the match. Ditto if the superblock has been forcibly unmounted.

While we're in here, also rename "other" to the more conventional "fsc".

Cc: Patrick Donnelly <pdonnell@redhat.com>
Cc: Niels de Vos <ndevos@redhat.com>
Cc: "Yan, Zheng" <ukernel@gmail.com>
Cc: stable@vger.kernel.org
URL: https://bugzilla.redhat.com/show_bug.cgi?id=1901499
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>

ceph: when comparing superblocks, skip ones that have been forcibly unmounted

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/super.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

v3: also handle the case where we have a forcibly unmounted superblock
    that is detached but still extant

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index f517ad9eeb26..b9ba50c9dc95 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1123,16 +1123,16 @@ static int ceph_compare_super(struct super_block *sb, struct fs_context *fc)
 	struct ceph_fs_client *new = fc->s_fs_info;
 	struct ceph_mount_options *fsopt = new->mount_options;
 	struct ceph_options *opt = new->client->options;
-	struct ceph_fs_client *other = ceph_sb_to_client(sb);
+	struct ceph_fs_client *fsc = ceph_sb_to_client(sb);
 
 	dout("ceph_compare_super %p\n", sb);
 
-	if (compare_mount_options(fsopt, opt, other)) {
+	if (compare_mount_options(fsopt, opt, fsc)) {
 		dout("monitor(s)/mount options don't match\n");
 		return 0;
 	}
 	if ((opt->flags & CEPH_OPT_FSID) &&
-	    ceph_fsid_compare(&opt->fsid, &other->client->fsid)) {
+	    ceph_fsid_compare(&opt->fsid, &fsc->client->fsid)) {
 		dout("fsid doesn't match\n");
 		return 0;
 	}
@@ -1140,6 +1140,17 @@ static int ceph_compare_super(struct super_block *sb, struct fs_context *fc)
 		dout("flags differ\n");
 		return 0;
 	}
+	/* Exclude any blocklisted superblocks */
+	if (fsc->blocklisted && !ceph_test_mount_opt(fsc, CLEANRECOVER)) {
+		dout("client is blocklisted (and CLEANRECOVER is not set)\n");
+		return 0;
+	}
+
+	if (fsc->mount_state == CEPH_MOUNT_SHUTDOWN) {
+		dout("client has been forcibly unmounted\n");
+		return 0;
+	}
+
 	return 1;
 }
 
-- 
2.31.1

