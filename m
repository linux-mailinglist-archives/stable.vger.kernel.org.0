Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 646B412EE9C
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728893AbgABWkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:40:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:53080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731328AbgABWik (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:38:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2378D21835;
        Thu,  2 Jan 2020 22:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004719;
        bh=YQaGtvdPkCyGlkVgJ0R45zBbXZGNYd7ph6U3pDQ7TXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uoV43hYjcoLNN9X9k+ojHTeHYD6ZHZrXiu61YhdMPVtD1lJYpjhQkKFpa50xIaMWl
         jx7qZspOEnP6ztRKcGMnnoQnwSsUtectqxOEq9Nk9yRnHnVuAyymToMyGNhl5AwSvs
         8YEBglH/jm0NzSN58y2pfcduW0lrE+aosnzFUz1c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ding Xiang <dingxiang@cmss.chinamobile.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Changwei Ge <gechangwei@live.cn>, Gang He <ghe@suse.com>,
        Jun Piao <piaojun@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 125/137] ocfs2: fix passing zero to PTR_ERR warning
Date:   Thu,  2 Jan 2020 23:08:18 +0100
Message-Id: <20200102220604.007998694@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.618583146@linuxfoundation.org>
References: <20200102220546.618583146@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ding Xiang <dingxiang@cmss.chinamobile.com>

[ Upstream commit 188c523e1c271d537f3c9f55b6b65bf4476de32f ]

Fix a static code checker warning:
fs/ocfs2/acl.c:331
	ocfs2_acl_chmod() warn: passing zero to 'PTR_ERR'

Link: http://lkml.kernel.org/r/1dee278b-6c96-eec2-ce76-fe6e07c6e20f@linux.alibaba.com
Fixes: 5ee0fbd50fd ("ocfs2: revert using ocfs2_acl_chmod to avoid inode cluster lock hang")
Signed-off-by: Ding Xiang <dingxiang@cmss.chinamobile.com>
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
 fs/ocfs2/acl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
index 1e0d8da0d3cd..80b92120c812 100644
--- a/fs/ocfs2/acl.c
+++ b/fs/ocfs2/acl.c
@@ -338,8 +338,8 @@ int ocfs2_acl_chmod(struct inode *inode, struct buffer_head *bh)
 	down_read(&OCFS2_I(inode)->ip_xattr_sem);
 	acl = ocfs2_get_acl_nolock(inode, ACL_TYPE_ACCESS, bh);
 	up_read(&OCFS2_I(inode)->ip_xattr_sem);
-	if (IS_ERR(acl) || !acl)
-		return PTR_ERR(acl);
+	if (IS_ERR_OR_NULL(acl))
+		return PTR_ERR_OR_ZERO(acl);
 	ret = __posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
 	if (ret)
 		return ret;
-- 
2.20.1



