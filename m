Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5858E37CE87
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344981AbhELRFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:05:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:42358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244436AbhELQqD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:46:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F06F61E72;
        Wed, 12 May 2021 16:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836089;
        bh=wldFpXk7J5dSO2jDrGOR0jFyaXmfUj1pKOG5pOMLCfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pueee3rXoouFBynRAhHaDyoQyRCNidqkSvWdEC9mYxg1bZUuC0VjIgCM2eAeOHorG
         tGng53ld9RrtqhvHFm8/Qs9LVB9LLiH5N76M4VQS3SXokUhPgF5zDblq90aBKM4ll2
         yBeIwMP7xbQwZGgIKoY3YUbdymTZoQDD3nsVFw7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@kernel.org>,
        Alessio Balsini <balsini@android.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 570/677] fuse: fix matching of FUSE_DEV_IOC_CLONE command
Date:   Wed, 12 May 2021 16:50:16 +0200
Message-Id: <20210512144856.333623127@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alessio Balsini <balsini@android.com>

[ Upstream commit 6076f5f341e612152879bfda99f0b76c1953bf0b ]

With commit f8425c939663 ("fuse: 32-bit user space ioctl compat for fuse
device") the matching constraints for the FUSE_DEV_IOC_CLONE ioctl command
are relaxed, limited to the testing of command type and number.  As Arnd
noticed, this is wrong as it wouldn't ensure the correctness of the data
size or direction for the received FUSE device ioctl.

Fix by bringing back the comparison of the ioctl received by the FUSE
device to the originally generated FUSE_DEV_IOC_CLONE.

Fixes: f8425c939663 ("fuse: 32-bit user space ioctl compat for fuse device")
Reported-by: Arnd Bergmann <arnd@kernel.org>
Signed-off-by: Alessio Balsini <balsini@android.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/dev.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index c0fee830a34e..a5ceccc5ef00 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -2233,11 +2233,8 @@ static long fuse_dev_ioctl(struct file *file, unsigned int cmd,
 	int oldfd;
 	struct fuse_dev *fud = NULL;
 
-	if (_IOC_TYPE(cmd) != FUSE_DEV_IOC_MAGIC)
-		return -ENOTTY;
-
-	switch (_IOC_NR(cmd)) {
-	case _IOC_NR(FUSE_DEV_IOC_CLONE):
+	switch (cmd) {
+	case FUSE_DEV_IOC_CLONE:
 		res = -EFAULT;
 		if (!get_user(oldfd, (__u32 __user *)arg)) {
 			struct file *old = fget(oldfd);
-- 
2.30.2



