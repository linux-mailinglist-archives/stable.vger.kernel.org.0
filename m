Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA392CA27C
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730857AbfJCQFp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:05:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:52564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732585AbfJCQFn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:05:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA68C215EA;
        Thu,  3 Oct 2019 16:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118742;
        bh=kEUcyf9ce6ZSDzVBodKAh4owIQCPHcgVn4yCbQNmwCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fSIIcZSWtl5i9KDff6jHHx74AcrcDwu2TfStvHOSsdWIc55mCop/BmPs3lm7VW3rd
         ktzviS2SheGRi0RcWfdkmePPlIoOLqjqfgxag93YEks5cwFAa7FgErS05LaJFbChmA
         fQ9QMeUDfrTB5pbvK7eRAyG9hfC8vULi+pzX8K3Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 4.9 123/129] quota: fix wrong condition in is_quota_modification()
Date:   Thu,  3 Oct 2019 17:54:06 +0200
Message-Id: <20191003154415.939074938@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154318.081116689@linuxfoundation.org>
References: <20191003154318.081116689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
CC: stable@vger.kernel.org
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/quotaops.h |    2 +-
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


