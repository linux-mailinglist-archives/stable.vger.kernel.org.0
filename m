Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 219B0167249
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731309AbgBUICJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:02:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:34532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730723AbgBUICI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:02:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 673FF206ED;
        Fri, 21 Feb 2020 08:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272127;
        bh=MkrSzaUpyiXGWZsDILQOUpHYbqHimewf164Sb99xzcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d7GBsQmUcVvFnyxJmBTKZ3w9AGD/Rx4iwiQhgopRr36gOJfNrXqUPlEkgvTp6xLd2
         Mzb+5XxiOhCmbAyMsoYmW/wNvSy1ZBAYyKlkVEI1gjkUHf7irA9en6ril2R0/kJf/F
         czcgYpD6PBOemsqu3pU9PFAY5lPAxvoXraXYiw+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Matthew Bobrowski <mbobrowski@mbobrowski.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 026/344] ext4: fix ext4_dax_read/write inode locking sequence for IOCB_NOWAIT
Date:   Fri, 21 Feb 2020 08:37:05 +0100
Message-Id: <20200221072351.551193850@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ritesh Harjani <riteshh@linux.ibm.com>

[ Upstream commit f629afe3369e9885fd6e9cc7a4f514b6a65cf9e9 ]

Apparently our current rwsem code doesn't like doing the trylock, then
lock for real scheme.  So change our dax read/write methods to just do the
trylock for the RWF_NOWAIT case.
This seems to fix AIM7 regression in some scalable filesystems upto ~25%
in some cases. Claimed in commit 942491c9e6d6 ("xfs: fix AIM7 regression")

Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Matthew Bobrowski <mbobrowski@mbobrowski.org>
Tested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Ritesh Harjani <riteshh@linux.ibm.com>
Link: https://lore.kernel.org/r/20191212055557.11151-2-riteshh@linux.ibm.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/file.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 8d2bbcc2d8133..fd7ce3573a00a 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -40,9 +40,10 @@ static ssize_t ext4_dax_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	struct inode *inode = file_inode(iocb->ki_filp);
 	ssize_t ret;
 
-	if (!inode_trylock_shared(inode)) {
-		if (iocb->ki_flags & IOCB_NOWAIT)
+	if (iocb->ki_flags & IOCB_NOWAIT) {
+		if (!inode_trylock_shared(inode))
 			return -EAGAIN;
+	} else {
 		inode_lock_shared(inode);
 	}
 	/*
@@ -190,9 +191,10 @@ ext4_dax_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	struct inode *inode = file_inode(iocb->ki_filp);
 	ssize_t ret;
 
-	if (!inode_trylock(inode)) {
-		if (iocb->ki_flags & IOCB_NOWAIT)
+	if (iocb->ki_flags & IOCB_NOWAIT) {
+		if (!inode_trylock(inode))
 			return -EAGAIN;
+	} else {
 		inode_lock(inode);
 	}
 	ret = ext4_write_checks(iocb, from);
-- 
2.20.1



