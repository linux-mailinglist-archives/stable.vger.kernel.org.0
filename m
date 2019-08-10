Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5761E88E71
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbfHJUyf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:54:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53758 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726427AbfHJUns (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:48 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDI-00052z-VZ; Sat, 10 Aug 2019 21:43:45 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDI-0003Y9-J5; Sat, 10 Aug 2019 21:43:44 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Lukas Czerner" <lczerner@redhat.com>,
        "Theodore Ts'o" <tytso@mit.edu>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.133828826@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 009/157] ext4: add missing brelse() in
 add_new_gdb_meta_bg()
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Czerner <lczerner@redhat.com>

commit d64264d6218e6892edd832dc3a5a5857c2856c53 upstream.

Currently in add_new_gdb_meta_bg() there is a missing brelse of gdb_bh
in case ext4_journal_get_write_access() fails.
Additionally kvfree() is missing in the same error path. Fix it by
moving the ext4_journal_get_write_access() before the ext4 sb update as
Ted suggested and release n_group_desc and gdb_bh in case it fails.

Fixes: 61a9c11e5e7a ("ext4: add missing brelse() add_new_gdb_meta_bg()'s error path")
Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/resize.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -908,11 +908,18 @@ static int add_new_gdb_meta_bg(struct su
 	memcpy(n_group_desc, o_group_desc,
 	       EXT4_SB(sb)->s_gdb_count * sizeof(struct buffer_head *));
 	n_group_desc[gdb_num] = gdb_bh;
+
+	BUFFER_TRACE(gdb_bh, "get_write_access");
+	err = ext4_journal_get_write_access(handle, gdb_bh);
+	if (err) {
+		kvfree(n_group_desc);
+		brelse(gdb_bh);
+		return err;
+	}
+
 	EXT4_SB(sb)->s_group_desc = n_group_desc;
 	EXT4_SB(sb)->s_gdb_count++;
 	ext4_kvfree(o_group_desc);
-	BUFFER_TRACE(gdb_bh, "get_write_access");
-	err = ext4_journal_get_write_access(handle, gdb_bh);
 	return err;
 }
 

