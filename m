Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBE14190F05
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728513AbgCXNQx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:16:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:36496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728506AbgCXNQx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:16:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F453208D6;
        Tue, 24 Mar 2020 13:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585055812;
        bh=oEOJMqvdsCj6GYOHbmui3Nl1PCCd6blChJqMhhQrgQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hrRsUCIrNsKWkWSLG+p/+GnS48qOPfhsNf3gu90Ez+I/TSrJP21qfoFWRclS4pMDN
         USUsZ+4KYi7b2k9jYY5xshawrJa7nSS37QvTfGl76XQ7vgmBGQKfZia7Yw/ENSVRws
         YS0mVf4G7NQIyd7LYkZfRjwp6jX6hsLfedKn8WNU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naresh Kamboju <naresh.kamboju@linaro.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Todd Kjos <tkjos@google.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 035/102] binderfs: use refcount for binder control devices too
Date:   Tue, 24 Mar 2020 14:10:27 +0100
Message-Id: <20200324130810.412840965@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130806.544601211@linuxfoundation.org>
References: <20200324130806.544601211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

[ Upstream commit 211b64e4b5b6bd5fdc19cd525c2cc9a90e6b0ec9 ]

Binderfs binder-control devices are cleaned up via binderfs_evict_inode
too() which will use refcount_dec_and_test(). However, we missed to set
the refcount for binderfs binder-control devices and so we underflowed
when the binderfs instance got unmounted. Pretty obvious oversight and
should have been part of the more general UAF fix. The good news is that
having test cases (suprisingly) helps.

Technically, we could detect that we're about to cleanup the
binder-control dentry in binderfs_evict_inode() and then simply clean it
up. But that makes the assumption that the binder driver itself will
never make use of a binderfs binder-control device after the binderfs
instance it belongs to has been unmounted and the superblock for it been
destroyed. While it is unlikely to ever come to this let's be on the
safe side. Performance-wise this also really doesn't matter since the
binder-control device is only every really when creating the binderfs
filesystem or creating additional binder devices. Both operations are
pretty rare.

Fixes: f0fe2c0f050d ("binder: prevent UAF for binderfs devices II")
Link: https://lore.kernel.org/r/CA+G9fYusdfg7PMfC9Xce-xLT7NiyKSbgojpK35GOm=Pf9jXXrA@mail.gmail.com
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Acked-by: Todd Kjos <tkjos@google.com>
Link: https://lore.kernel.org/r/20200311105309.1742827-1-christian.brauner@ubuntu.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/android/binderfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/android/binderfs.c b/drivers/android/binderfs.c
index 110e41f920c27..f303106b3362b 100644
--- a/drivers/android/binderfs.c
+++ b/drivers/android/binderfs.c
@@ -448,6 +448,7 @@ static int binderfs_binder_ctl_create(struct super_block *sb)
 	inode->i_uid = info->root_uid;
 	inode->i_gid = info->root_gid;
 
+	refcount_set(&device->ref, 1);
 	device->binderfs_inode = inode;
 	device->miscdev.minor = minor;
 
-- 
2.20.1



