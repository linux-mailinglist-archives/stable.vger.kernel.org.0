Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0FAD43A284
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237040AbhJYTtg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:49:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:38050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237965AbhJYTq6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:46:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F26786120E;
        Mon, 25 Oct 2021 19:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190806;
        bh=/YRoqzAEjhqmH41n4WgUHDjAzeCTyP7Vgj9LLACY508=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n5lZ+R7hDC8+e8SOQiTX4cq9M2UrtkauMzXLN+z7e8MXsl4yXzz4VkONvrZpcdrny
         hWv6QGDkK/W+9GxNOJ/ukHG859ecWF40ZxoDE/0ndCj5EPxHl+1lrhFcg1uM1IrBtV
         k/7tmh2mpMWtCZcHFDO2JiCLUzsULVLiPl29BRUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.14 075/169] ceph: skip existing superblocks that are blocklisted or shut down when mounting
Date:   Mon, 25 Oct 2021 21:14:16 +0200
Message-Id: <20211025191026.897533379@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

commit 98d0a6fb7303a6f4a120b8b8ed05b86ff5db53e8 upstream.

Currently when mounting, we may end up finding an existing superblock
that corresponds to a blocklisted MDS client. This means that the new
mount ends up being unusable.

If we've found an existing superblock with a client that is already
blocklisted, and the client is not configured to recover on its own,
fail the match. Ditto if the superblock has been forcibly unmounted.

While we're in here, also rename "other" to the more conventional "fsc".

Cc: stable@vger.kernel.org
URL: https://bugzilla.redhat.com/show_bug.cgi?id=1901499
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/super.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1002,16 +1002,16 @@ static int ceph_compare_super(struct sup
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
@@ -1019,6 +1019,17 @@ static int ceph_compare_super(struct sup
 		dout("flags differ\n");
 		return 0;
 	}
+
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
 


