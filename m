Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDAA831E34
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbfFANep (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:34:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:53510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728697AbfFANXc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:23:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A64027358;
        Sat,  1 Jun 2019 13:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395412;
        bh=Fv9uytBOgNYpDhXFGzwaeV2PNsUrMGxcqV1c9hs8yv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F64slh9Z3XKynOEGWGOyYq9Eq2TnrQ3D5QJ1yKacHBIjDpNheSy9k+LPPEWGYUSoE
         fQNYxu8wbzyMcLjMXtH2fl8FPydE3FpSDU5jPFt8L1+EJU7t/3w19aUFjSHrXLxOYj
         420F/+gHYquKpMtD/zzyvMRfFsT2UYJ6yC2HoqEE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Murphy Zhou <jencce.kernel@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-unionfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 049/141] ovl: do not generate duplicate fsnotify events for "fake" path
Date:   Sat,  1 Jun 2019 09:20:25 -0400
Message-Id: <20190601132158.25821-49-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601132158.25821-1-sashal@kernel.org>
References: <20190601132158.25821-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

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
index 986313da0c889..dbf39e715e6aa 100644
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

