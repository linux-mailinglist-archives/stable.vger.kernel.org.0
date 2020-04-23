Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7CC1B69A2
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726161AbgDWXG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:06:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48146 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727877AbgDWXG1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:27 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvI-0004ZV-8N; Fri, 24 Apr 2020 00:06:24 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvH-00E6f4-Mx; Fri, 24 Apr 2020 00:06:23 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Eryu Guan" <guaneryu@gmail.com>,
        "Zirong Lang" <zorro.lang@gmail.com>,
        "Theodore Ts'o" <tytso@mit.edu>
Date:   Fri, 24 Apr 2020 00:03:59 +0100
Message-ID: <lsq.1587683028.634571530@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 012/245] ext4: update c/mtime on truncate up
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eryu Guan <guaneryu@gmail.com>

commit 911af577de4e444622d46500c1f9a37ab4335d3a upstream.

Commit 3da40c7b0898 ("ext4: only call ext4_truncate when size <= isize")
introduced a bug that c/mtime is not updated on truncate up.

Fix the issue by setting c/mtime explicitly in the truncate up case.

Note that ftruncate(2) is not affected, so you won't see this bug using
truncate(1) and xfs_io(1).

Signed-off-by: Zirong Lang <zorro.lang@gmail.com>
Signed-off-by: Eryu Guan <guaneryu@gmail.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4843,6 +4843,14 @@ int ext4_setattr(struct dentry *dentry,
 				error = ext4_orphan_add(handle, inode);
 				orphan = 1;
 			}
+			/*
+			 * Update c/mtime on truncate up, ext4_truncate() will
+			 * update c/mtime in shrink case below
+			 */
+			if (!shrink) {
+				inode->i_mtime = ext4_current_time(inode);
+				inode->i_ctime = inode->i_mtime;
+			}
 			down_write(&EXT4_I(inode)->i_data_sem);
 			EXT4_I(inode)->i_disksize = attr->ia_size;
 			rc = ext4_mark_inode_dirty(handle, inode);

