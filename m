Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 081A310EDA8
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 18:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727569AbfLBRCR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 12:02:17 -0500
Received: from mx2.suse.de ([195.135.220.15]:53814 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727460AbfLBRCR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Dec 2019 12:02:17 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7F94FBD29;
        Mon,  2 Dec 2019 17:02:15 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 498241E0B7E; Mon,  2 Dec 2019 18:02:15 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 2/2] ext4: Check for directory entries too close to block end
Date:   Mon,  2 Dec 2019 18:02:13 +0100
Message-Id: <20191202170213.4761-3-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191202170213.4761-1-jack@suse.cz>
References: <20191202170213.4761-1-jack@suse.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ext4_check_dir_entry() currently does not catch a case when a directory
entry ends so close to the block end that the header of the next
directory entry would not fit in the remaining space. This can lead to
directory iteration code trying to access address beyond end of current
buffer head leading to oops.

CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/dir.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 9fdd2b269d61..6305d5ec25af 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -81,6 +81,11 @@ int __ext4_check_dir_entry(const char *function, unsigned int line,
 		error_msg = "rec_len is too small for name_len";
 	else if (unlikely(((char *) de - buf) + rlen > size))
 		error_msg = "directory entry overrun";
+	else if (unlikely(((char *) de - buf) + rlen >
+			  size - EXT4_DIR_REC_LEN(1) &&
+			  ((char *) de - buf) + rlen != size)) {
+		error_msg = "directory entry too close to block end";
+	}
 	else if (unlikely(le32_to_cpu(de->inode) >
 			le32_to_cpu(EXT4_SB(dir->i_sb)->s_es->s_inodes_count)))
 		error_msg = "inode out of bounds";
-- 
2.16.4

