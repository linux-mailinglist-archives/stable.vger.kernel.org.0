Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27D1515E87C
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389128AbgBNRA3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:00:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:47474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404293AbgBNQQg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:16:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 492A5206D7;
        Fri, 14 Feb 2020 16:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696996;
        bh=A7mtqHMBRXmpZws71RLcV6YiKcGVfMgqWoLgobCuYsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XhZo+lJ2hmP/ZnMbgJBo9RRWHYKP+SswfIu1r8M6N22DMvNge7WeisAa4HYO8s7bq
         dHSbYFaSLVVyUwIhzP1sETvoWGgmf4oEB8uxfkptMCVwEnUaIPTOf6wkCky9Sh0GEM
         7GOaATm6uB6W/fwOq+xpz8fOzeYrhIDWKrEb/4qk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiubo Li <xiubli@redhat.com>, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 229/252] ceph: check availability of mds cluster on mount after wait timeout
Date:   Fri, 14 Feb 2020 11:11:24 -0500
Message-Id: <20200214161147.15842-229-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

[ Upstream commit 97820058fb2831a4b203981fa2566ceaaa396103 ]

If all the MDS daemons are down for some reason, then the first mount
attempt will fail with EIO after the mount request times out.  A mount
attempt will also fail with EIO if all of the MDS's are laggy.

This patch changes the code to return -EHOSTUNREACH in these situations
and adds a pr_info error message to help the admin determine the cause.

URL: https://tracker.ceph.com/issues/4386
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mds_client.c | 3 +--
 fs/ceph/super.c      | 5 +++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 09db6d08614d2..a2e903203bf9f 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2343,8 +2343,7 @@ static void __do_request(struct ceph_mds_client *mdsc,
 		if (!(mdsc->fsc->mount_options->flags &
 		      CEPH_MOUNT_OPT_MOUNTWAIT) &&
 		    !ceph_mdsmap_is_cluster_available(mdsc->mdsmap)) {
-			err = -ENOENT;
-			pr_info("probably no mds server is up\n");
+			err = -EHOSTUNREACH;
 			goto finish;
 		}
 	}
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 2bd0b1ed9708e..c4314f4492401 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1106,6 +1106,11 @@ static struct dentry *ceph_mount(struct file_system_type *fs_type,
 	return res;
 
 out_splat:
+	if (!ceph_mdsmap_is_cluster_available(fsc->mdsc->mdsmap)) {
+		pr_info("No mds server is up or the cluster is laggy\n");
+		err = -EHOSTUNREACH;
+	}
+
 	ceph_mdsc_close_sessions(fsc->mdsc);
 	deactivate_locked_super(sb);
 	goto out_final;
-- 
2.20.1

