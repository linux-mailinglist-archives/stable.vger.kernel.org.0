Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5809BAEB
	for <lists+stable@lfdr.de>; Sat, 24 Aug 2019 04:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725807AbfHXCjA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Aug 2019 22:39:00 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:45969 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725782AbfHXCjA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Aug 2019 22:39:00 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-111.corp.google.com [104.133.0.111] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x7O2cuv3014982
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Aug 2019 22:38:57 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 7984342049E; Fri, 23 Aug 2019 22:38:56 -0400 (EDT)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc:     "Theodore Ts'o" <tytso@mit.edu>, stable@vger.kernel.org
Subject: [PATCH] ext4: fix punch hole for inline_data file systems
Date:   Fri, 23 Aug 2019 22:38:51 -0400
Message-Id: <20190824023851.30991-1-tytso@mit.edu>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If a program attempts to punch a hole on an inline data file, we need
to convert it to a normal file first.

This was detected using ext4/032 using the adv configuration.  Simple
reproducer:

mke2fs -Fq -t ext4 -O inline_data /dev/vdc
mount /vdc
echo "" > /vdc/testfile
xfs_io -c 'truncate 33554432' /vdc/testfile
xfs_io -c 'fpunch 0 1048576' /vdc/testfile
umount /vdc
e2fsck -fy /dev/vdc

Cc: stable@vger.kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/inode.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 2b1c58da8d1e..e567f0229d4e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4236,6 +4236,15 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
 
 	trace_ext4_punch_hole(inode, offset, length, 0);
 
+	ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+	if (ext4_has_inline_data(inode)) {
+		down_write(&EXT4_I(inode)->i_mmap_sem);
+		ret = ext4_convert_inline_data(inode);
+		up_write(&EXT4_I(inode)->i_mmap_sem);
+		if (ret)
+			return ret;
+	}
+
 	/*
 	 * Write out all dirty pages to avoid race conditions
 	 * Then release them.
-- 
2.23.0

