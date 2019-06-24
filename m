Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07486506E0
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729192AbfFXKCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:02:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:33472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729323AbfFXKCU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:02:20 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D879205ED;
        Mon, 24 Jun 2019 10:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370539;
        bh=4Zi5ayb+WA2bZIyp+jOi5idTye1Efj6rfvQauYuZFos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z9wAxgnYrYlYuwwM4a+MRGOjMPypfnxzSm5zUTHVvOZKxRN1bq+yIzDuP6gaIVh6E
         aUbIcsQWvbqTrlKdFaSiSGqPM2kAqoC3NIJYWakjZJJsDTFw0C4leWBkzsCnqTHeeg
         XWpApT+7hnJvvIhI5O3U6OBj58cd2VGHPPB39Dx8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 04/90] ovl: support the FS_IOC_FS[SG]ETXATTR ioctls
Date:   Mon, 24 Jun 2019 17:55:54 +0800
Message-Id: <20190624092314.225510275@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092313.788773607@linuxfoundation.org>
References: <20190624092313.788773607@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b21d9c435f935014d3e3fa6914f2e4fbabb0e94d ]

They are the extended version of FS_IOC_FS[SG]ETFLAGS ioctls.
xfs_io -c "chattr <flags>" uses the new ioctls for setting flags.

This used to work in kernel pre v4.19, before stacked file ops
introduced the ovl_ioctl whitelist.

Reported-by: Dave Chinner <david@fromorbit.com>
Fixes: d1d04ef8572b ("ovl: stack file ops")
Cc: <stable@vger.kernel.org> # v4.19
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/file.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 00338b828f76..749532fd51d7 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -426,7 +426,8 @@ static unsigned int ovl_get_inode_flags(struct inode *inode)
 	return ovl_iflags;
 }
 
-static long ovl_ioctl_set_flags(struct file *file, unsigned long arg)
+static long ovl_ioctl_set_flags(struct file *file, unsigned int cmd,
+				unsigned long arg)
 {
 	long ret;
 	struct inode *inode = file_inode(file);
@@ -456,7 +457,7 @@ static long ovl_ioctl_set_flags(struct file *file, unsigned long arg)
 	if (ret)
 		goto unlock;
 
-	ret = ovl_real_ioctl(file, FS_IOC_SETFLAGS, arg);
+	ret = ovl_real_ioctl(file, cmd, arg);
 
 	ovl_copyflags(ovl_inode_real(inode), inode);
 unlock:
@@ -474,11 +475,13 @@ static long ovl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 	switch (cmd) {
 	case FS_IOC_GETFLAGS:
+	case FS_IOC_FSGETXATTR:
 		ret = ovl_real_ioctl(file, cmd, arg);
 		break;
 
 	case FS_IOC_SETFLAGS:
-		ret = ovl_ioctl_set_flags(file, arg);
+	case FS_IOC_FSSETXATTR:
+		ret = ovl_ioctl_set_flags(file, cmd, arg);
 		break;
 
 	default:
-- 
2.20.1



