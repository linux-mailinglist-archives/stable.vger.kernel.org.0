Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89120441FC
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390820AbfFMQS0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:18:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731098AbfFMIkU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:40:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 605AA21479;
        Thu, 13 Jun 2019 08:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415219;
        bh=IGrnBpsP0i33l3t2cgMK4/7giRbzSp4stV1/BxbUVvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iuPtQk8XG5JP+Eyv5pTZJ/FscAZcmpxLYzCvPZJbEJ2OWvZ8URqTXsehazsHnzSTX
         Z1T6QE0k2Qqql2gSWkS90QAqv9FnwIdqUM57sFZtN6YteyfVEypun82u8DsrslAElP
         03DfgLU4ez6kqN42/TUifNUlTE8RfZVtm+kXISFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Murphy Zhou <jencce.kernel@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 047/118] ovl: do not generate duplicate fsnotify events for "fake" path
Date:   Thu, 13 Jun 2019 10:33:05 +0200
Message-Id: <20190613075646.551213163@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075643.642092651@linuxfoundation.org>
References: <20190613075643.642092651@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d989903058a83e8536cc7aadf9256a47d5c173fe ]

Overlayfs "fake" path is used for stacked file operations on underlying
files.  Operations on files with "fake" path must not generate fsnotify
events with path data, because those events have already been generated at
overlayfs layer and because the reported event->fd for fanotify marks on
underlying inode/filesystem will have the wrong path (the overlayfs path).

Link: https://lore.kernel.org/linux-fsdevel/20190423065024.12695-1-jencce.kernel@gmail.com/
Reported-by: Murphy Zhou <jencce.kernel@gmail.com>
Fixes: d1d04ef8572b ("ovl: stack file ops")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/file.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 0c810f20f778..2c993937b784 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -29,10 +29,11 @@ static struct file *ovl_open_realfile(const struct file *file,
 	struct inode *inode = file_inode(file);
 	struct file *realfile;
 	const struct cred *old_cred;
+	int flags = file->f_flags | O_NOATIME | FMODE_NONOTIFY;
 
 	old_cred = ovl_override_creds(inode->i_sb);
-	realfile = open_with_fake_path(&file->f_path, file->f_flags | O_NOATIME,
-				       realinode, current_cred());
+	realfile = open_with_fake_path(&file->f_path, flags, realinode,
+				       current_cred());
 	revert_creds(old_cred);
 
 	pr_debug("open(%p[%pD2/%c], 0%o) -> (%p, 0%o)\n",
@@ -50,7 +51,7 @@ static int ovl_change_flags(struct file *file, unsigned int flags)
 	int err;
 
 	/* No atime modificaton on underlying */
-	flags |= O_NOATIME;
+	flags |= O_NOATIME | FMODE_NONOTIFY;
 
 	/* If some flag changed that cannot be changed then something's amiss */
 	if (WARN_ON((file->f_flags ^ flags) & ~OVL_SETFL_MASK))
-- 
2.20.1



