Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 036C54A4271
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359685AbiAaLL4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:11:56 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57144 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377223AbiAaLJt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:09:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD382B82A4C;
        Mon, 31 Jan 2022 11:09:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFED7C340E8;
        Mon, 31 Jan 2022 11:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627387;
        bh=GRxFcrspBDZRFlASEt8oRRx66DaP085lVTs5yNE/Bvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aMhjUnZAyimGGAEzcEq4Wcs5Cym+Ruo6KsxNzDtVbq/AfKOZ5yefxzQGEu9lRdUuz
         Bhg6JehVkqF1XxaZRH0mOZ4dF5ucqI90hG6ATi+OzcdNXmQ/5Ypp/3n53A2IASCk3q
         dkyUBf8eYB8nmRJosAxZB1HYFvKNTOaeB5Y+L6nM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan van der Ster <dan@vanderster.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.15 024/171] ceph: set pool_ns in new inode layout for async creates
Date:   Mon, 31 Jan 2022 11:54:49 +0100
Message-Id: <20220131105230.842077669@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

commit 4584a768f22b7669cdebabc911543621ac661341 upstream.

Dan reported that he was unable to write to files that had been
asynchronously created when the client's OSD caps are restricted to a
particular namespace.

The issue is that the layout for the new inode is only partially being
filled. Ensure that we populate the pool_ns_data and pool_ns_len in the
iinfo before calling ceph_fill_inode.

Cc: stable@vger.kernel.org
URL: https://tracker.ceph.com/issues/54013
Fixes: 9a8d03ca2e2c ("ceph: attempt to do async create when possible")
Reported-by: Dan van der Ster <dan@vanderster.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/file.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -577,6 +577,7 @@ static int ceph_finish_async_create(stru
 	struct ceph_inode_info *ci = ceph_inode(dir);
 	struct inode *inode;
 	struct timespec64 now;
+	struct ceph_string *pool_ns;
 	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(dir->i_sb);
 	struct ceph_vino vino = { .ino = req->r_deleg_ino,
 				  .snap = CEPH_NOSNAP };
@@ -626,6 +627,12 @@ static int ceph_finish_async_create(stru
 	in.max_size = cpu_to_le64(lo->stripe_unit);
 
 	ceph_file_layout_to_legacy(lo, &in.layout);
+	/* lo is private, so pool_ns can't change */
+	pool_ns = rcu_dereference_raw(lo->pool_ns);
+	if (pool_ns) {
+		iinfo.pool_ns_len = pool_ns->len;
+		iinfo.pool_ns_data = pool_ns->str;
+	}
 
 	down_read(&mdsc->snap_rwsem);
 	ret = ceph_fill_inode(inode, NULL, &iinfo, NULL, req->r_session,


