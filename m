Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D26921078A4
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 20:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbfKVTv4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 14:51:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:50484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727705AbfKVTuD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 14:50:03 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B2D92075E;
        Fri, 22 Nov 2019 19:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574452203;
        bh=tawO3EiEOzoXBA5escWcgSKwcPu0Xc1V1YBXwfOTuws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uqKnAZZwkJvUW1XRJFgnC4FewJZjN4Bs/kPvfiZ2Kpu2kIn3A1zWlFjyJ1dSEeYmx
         zRW7/SiRr2hil8NZ/yt2bjRt+/b1ITJcTmp0ufk5eHJ1hcUDEpLnUd85DnREKMP21Z
         0lE4ou29pl3J7+TYH25fX+VD5DARU4hExSdVxhjc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Sasha Levin <sashal@kernel.org>,
        linux-audit@redhat.com
Subject: [PATCH AUTOSEL 4.9 04/13] audit_get_nd(): don't unlock parent too early
Date:   Fri, 22 Nov 2019 14:49:49 -0500
Message-Id: <20191122194958.24926-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122194958.24926-1-sashal@kernel.org>
References: <20191122194958.24926-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 69924b89687a2923e88cc42144aea27868913d0e ]

if the child has been negative and just went positive
under us, we want coherent d_is_positive() and ->d_inode.
Don't unlock the parent until we'd done that work...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/audit_watch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/audit_watch.c b/kernel/audit_watch.c
index f036b6ada6efc..712469a3103ac 100644
--- a/kernel/audit_watch.c
+++ b/kernel/audit_watch.c
@@ -365,12 +365,12 @@ static int audit_get_nd(struct audit_watch *watch, struct path *parent)
 	struct dentry *d = kern_path_locked(watch->path, parent);
 	if (IS_ERR(d))
 		return PTR_ERR(d);
-	inode_unlock(d_backing_inode(parent->dentry));
 	if (d_is_positive(d)) {
 		/* update watch filter fields */
 		watch->dev = d->d_sb->s_dev;
 		watch->ino = d_backing_inode(d)->i_ino;
 	}
+	inode_unlock(d_backing_inode(parent->dentry));
 	dput(d);
 	return 0;
 }
-- 
2.20.1

