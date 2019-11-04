Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C76C6EF098
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387850AbfKDW3G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:29:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:38140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729899AbfKDVsJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:48:09 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B347B21850;
        Mon,  4 Nov 2019 21:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904089;
        bh=1FToogkIY8Hsa4SVq/KUItZyuhUtpk68aHUfQPLdhjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DRaLP6Z5wV4Ddo0yxax2Ib3PlmP6+sy7TyqLD1YPP8afeiWSDLmWU2SywUiYr53b5
         evyExS05SU8jO9VTJYCNN6HKASq3xnJfhMMLCmcdYkfH1pZmCtBWiAEDOdqVYHaETA
         h/jSYR4Tg9lN/SFCGvJpdBTs2dUn8jTlNzJ5o6Kw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Changwei Ge <gechangwei@live.cn>, Gang He <ghe@suse.com>,
        Jun Piao <piaojun@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 18/46] fs: ocfs2: fix a possible null-pointer dereference in ocfs2_info_scan_inode_alloc()
Date:   Mon,  4 Nov 2019 22:44:49 +0100
Message-Id: <20191104211848.170365924@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104211830.912265604@linuxfoundation.org>
References: <20191104211830.912265604@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit 2abb7d3b12d007c30193f48bebed781009bebdd2 ]

In ocfs2_info_scan_inode_alloc(), there is an if statement on line 283
to check whether inode_alloc is NULL:

    if (inode_alloc)

When inode_alloc is NULL, it is used on line 287:

    ocfs2_inode_lock(inode_alloc, &bh, 0);
        ocfs2_inode_lock_full_nested(inode, ...)
            struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);

Thus, a possible null-pointer dereference may occur.

To fix this bug, inode_alloc is checked on line 286.

This bug is found by a static analysis tool STCheck written by us.

Link: http://lkml.kernel.org/r/20190726033717.32359-1-baijiaju1990@gmail.com
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
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
 fs/ocfs2/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index 3cb097ccce607..79232296b7d2b 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -289,7 +289,7 @@ static int ocfs2_info_scan_inode_alloc(struct ocfs2_super *osb,
 	if (inode_alloc)
 		mutex_lock(&inode_alloc->i_mutex);
 
-	if (o2info_coherent(&fi->ifi_req)) {
+	if (inode_alloc && o2info_coherent(&fi->ifi_req)) {
 		status = ocfs2_inode_lock(inode_alloc, &bh, 0);
 		if (status < 0) {
 			mlog_errno(status);
-- 
2.20.1



