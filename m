Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B274DE5AE8
	for <lists+stable@lfdr.de>; Sat, 26 Oct 2019 15:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbfJZNSv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Oct 2019 09:18:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:40702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726686AbfJZNSv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Oct 2019 09:18:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23B04222CB;
        Sat, 26 Oct 2019 13:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095930;
        bh=y43nwI/bGuodC3G6AlXNE1BJKSQq1wvTW5sPpddt0Js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YBChgFMgHOd7GFyby1d6JrkNNh3vGQX6Xgq/nOCy9W7X4ivIFDJZKc2tXBfKPrx1e
         0aYCEKF73OW2adzZ2KhkaYkQfed+xSLh7yf+8r7aG7RhQw3+UXP/6B4ojFjF11Dd/j
         FzU7d0lph4wp4s1jdaaaIphoDKU57YI7/j2Z+z3Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Changwei Ge <gechangwei@live.cn>, Gang He <ghe@suse.com>,
        Jun Piao <piaojun@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 95/99] ocfs2: fix error handling in ocfs2_setattr()
Date:   Sat, 26 Oct 2019 09:15:56 -0400
Message-Id: <20191026131600.2507-95-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131600.2507-1-sashal@kernel.org>
References: <20191026131600.2507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chengguang Xu <cgxu519@mykernel.net>

[ Upstream commit ce750f43f5790de74c1644c39d78f684071658d1 ]

Should set transfer_to[USRQUOTA/GRPQUOTA] to NULL on error case before
jumping to do dqput().

Link: http://lkml.kernel.org/r/20191010082349.1134-1-cgxu519@mykernel.net
Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 4435df3e5adb9..39c1d85f50904 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1226,6 +1226,7 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 			transfer_to[USRQUOTA] = dqget(sb, make_kqid_uid(attr->ia_uid));
 			if (IS_ERR(transfer_to[USRQUOTA])) {
 				status = PTR_ERR(transfer_to[USRQUOTA]);
+				transfer_to[USRQUOTA] = NULL;
 				goto bail_unlock;
 			}
 		}
@@ -1235,6 +1236,7 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 			transfer_to[GRPQUOTA] = dqget(sb, make_kqid_gid(attr->ia_gid));
 			if (IS_ERR(transfer_to[GRPQUOTA])) {
 				status = PTR_ERR(transfer_to[GRPQUOTA]);
+				transfer_to[GRPQUOTA] = NULL;
 				goto bail_unlock;
 			}
 		}
-- 
2.20.1

