Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95E37171F8B
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732483AbgB0N6g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:58:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:59782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732478AbgB0N6f (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:58:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC8E420578;
        Thu, 27 Feb 2020 13:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811915;
        bh=M5ag27vgaXE6PPGIrbvGYM2pabD/lISu0sr/LYU9ZL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gzKwBi2nANEogWYtT+X/7d2agkJVrKnBIlxwIWsoG0flPQA8adTilNvas4XlXptSA
         kgDesGItwY/SkCiRNsp4XXceGW03Dlj0NVUUFHj5K5QTSpSt0+PTOdOIU6+E6EmlUR
         bxIsShh9I6Q3TlGNo664X8QTZ4Z437Yr2jjYvTt8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiubo Li <xiubli@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 149/237] ceph: check availability of mds cluster on mount after wait timeout
Date:   Thu, 27 Feb 2020 14:36:03 +0100
Message-Id: <20200227132307.561774108@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index b968334f841e8..f36ddfea4997e 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2261,8 +2261,7 @@ static int __do_request(struct ceph_mds_client *mdsc,
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
index 088c4488b4492..6b10b20bfe32b 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1055,6 +1055,11 @@ static struct dentry *ceph_mount(struct file_system_type *fs_type,
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



