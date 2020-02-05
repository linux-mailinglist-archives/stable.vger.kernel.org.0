Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB2415291D
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 11:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbgBEK2t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 05:28:49 -0500
Received: from mx2.suse.de ([195.135.220.15]:37754 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727341AbgBEK2t (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Feb 2020 05:28:49 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 53CD1B00D;
        Wed,  5 Feb 2020 10:28:47 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.com>
To:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        "Yan, Zheng" <zyan@redhat.com>, Gregory Farnum <gfarnum@redhat.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Henriques <lhenriques@suse.com>, stable@vger.kernel.org
Subject: [PATCH] ceph: fix copy_file_range error path in short copies
Date:   Wed,  5 Feb 2020 10:28:52 +0000
Message-Id: <20200205102852.12236-1-lhenriques@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When there's an error in the copying loop but some bytes have already been
copied into the destination file, it is necessary to dirty the caps and
eventually update the MDS with the file metadata (timestamps, size).  This
patch fixes this error path.

Cc: stable@vger.kernel.org
Signed-off-by: Luis Henriques <lhenriques@suse.com>
---
 fs/ceph/file.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 11929d2bb594..7be47d24edb1 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -2104,9 +2104,16 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
 			CEPH_OSD_OP_FLAG_FADVISE_DONTNEED, 0);
 		if (err) {
 			dout("ceph_osdc_copy_from returned %d\n", err);
-			if (!ret)
+			/*
+			 * If we haven't done any copy yet, just exit with the
+			 * error code; otherwise, return the number of bytes
+			 * already copied, update metadata and dirty caps.
+			 */
+			if (!ret) {
 				ret = err;
-			goto out_caps;
+				goto out_caps;
+			}
+			goto out_early;
 		}
 		len -= object_size;
 		src_off += object_size;
@@ -2118,6 +2125,7 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
 		/* We still need one final local copy */
 		do_final_copy = true;
 
+out_early:
 	file_update_time(dst_file);
 	inode_inc_iversion_raw(dst_inode);
 
