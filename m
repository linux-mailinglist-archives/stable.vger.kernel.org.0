Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5A844043
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731354AbfFMQEh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:04:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:35236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731351AbfFMIqu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:46:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6AF12147A;
        Thu, 13 Jun 2019 08:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415609;
        bh=+f5Qo9PDRYZX5uTDxbpOtMvtOK+wPUi0yp778V82wJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wz2OcUWHdx6A+xYl41iqoSx+VYPNaiAZK/Kg+QrOmIEkN0ivF4wecQ0NB744tBOcU
         QonyYPCTyUMttVjheG7dR13pQ+7uFPPii/8KFi5r4alGJZr9r/l8a6qwmr2gRD9FZ7
         QUvSPaXQTJJ2sHdDykN9JXD4my7OjwSKS2Zupj0E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Murphy Zhou <jencce.kernel@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 062/155] ovl: do not generate duplicate fsnotify events for "fake" path
Date:   Thu, 13 Jun 2019 10:32:54 +0200
Message-Id: <20190613075656.522287198@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
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
index 50e4407398d8..7129dcd78b6b 100644
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



