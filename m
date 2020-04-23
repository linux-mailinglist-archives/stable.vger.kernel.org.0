Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A15D1B69A8
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729348AbgDWXZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:25:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48192 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728083AbgDWXG2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:28 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvI-0004ZW-7j; Fri, 24 Apr 2020 00:06:24 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvH-00E6f9-OA; Fri, 24 Apr 2020 00:06:23 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Chao Yu" <yuchao0@huawei.com>, "Jan Kara" <jack@suse.cz>
Date:   Fri, 24 Apr 2020 00:04:00 +0100
Message-ID: <lsq.1587683028.17394596@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 013/245] quota: fix wrong condition in
 is_quota_modification()
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

From: Chao Yu <yuchao0@huawei.com>

commit 6565c182094f69e4ffdece337d395eb7ec760efc upstream.

Quoted from
commit 3da40c7b0898 ("ext4: only call ext4_truncate when size <= isize")

" At LSF we decided that if we truncate up from isize we shouldn't trim
  fallocated blocks that were fallocated with KEEP_SIZE and are past the
 new i_size.  This patch fixes ext4 to do this. "

And generic/092 of fstest have covered this case for long time, however
is_quota_modification() didn't adjust based on that rule, so that in
below condition, we will lose to quota block change:
- fallocate blocks beyond EOF
- remount
- truncate(file_path, file_size)

Fix it.

Link: https://lore.kernel.org/r/20190911093650.35329-1-yuchao0@huawei.com
Fixes: 3da40c7b0898 ("ext4: only call ext4_truncate when size <= isize")
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/quotaops.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -21,7 +21,7 @@ static inline struct quota_info *sb_dqop
 /* i_mutex must being held */
 static inline bool is_quota_modification(struct inode *inode, struct iattr *ia)
 {
-	return (ia->ia_valid & ATTR_SIZE && ia->ia_size != inode->i_size) ||
+	return (ia->ia_valid & ATTR_SIZE) ||
 		(ia->ia_valid & ATTR_UID && !uid_eq(ia->ia_uid, inode->i_uid)) ||
 		(ia->ia_valid & ATTR_GID && !gid_eq(ia->ia_gid, inode->i_gid));
 }

