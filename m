Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2991E5B84
	for <lists+stable@lfdr.de>; Sat, 26 Oct 2019 15:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbfJZNXj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Oct 2019 09:23:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729941AbfJZNXi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Oct 2019 09:23:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75B092245A;
        Sat, 26 Oct 2019 13:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572096217;
        bh=1jFzCE2rgwVj3btr28TIQMsoAtoaTMpvLSm+D6DXni4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JRTc9zA3KBdqnR8Fr/j35Jiw19bSlDM2Xb+Owc+FNuQN9XKUuD2NvU2cr1I1SGgX5
         8Q9oe0IlP370mPMmgV0DkoV1aQJ5k8iIyK/j9CuChjz4Phf31qqmhbltu3g89bwVa5
         L85xnDymQ5LMMW9FW6jHM/sd2tLPj9t7iBff4hlY=
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
Subject: [PATCH AUTOSEL 4.4 16/17] ocfs2: fix error handling in ocfs2_setattr()
Date:   Sat, 26 Oct 2019 09:23:00 -0400
Message-Id: <20191026132302.4622-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026132302.4622-1-sashal@kernel.org>
References: <20191026132302.4622-1-sashal@kernel.org>
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
index 1d738723a41ad..0d09fe7b7c81f 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1219,6 +1219,7 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 			transfer_to[USRQUOTA] = dqget(sb, make_kqid_uid(attr->ia_uid));
 			if (IS_ERR(transfer_to[USRQUOTA])) {
 				status = PTR_ERR(transfer_to[USRQUOTA]);
+				transfer_to[USRQUOTA] = NULL;
 				goto bail_unlock;
 			}
 		}
@@ -1228,6 +1229,7 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 			transfer_to[GRPQUOTA] = dqget(sb, make_kqid_gid(attr->ia_gid));
 			if (IS_ERR(transfer_to[GRPQUOTA])) {
 				status = PTR_ERR(transfer_to[GRPQUOTA]);
+				transfer_to[GRPQUOTA] = NULL;
 				goto bail_unlock;
 			}
 		}
-- 
2.20.1

