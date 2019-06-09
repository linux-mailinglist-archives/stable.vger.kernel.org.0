Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF1F3A856
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387642AbfFIQ7V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:59:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733142AbfFIQ7S (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:59:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48FA6204EC;
        Sun,  9 Jun 2019 16:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099557;
        bh=cdyIRM3x/svyww37C6tdtQMMEPvU/u4nbt84BvYnhxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hnOZLBAQeZ2D2YUSmGhAoJ7sxYLqr1ATwuF5zTerwSA0RSjnX77sshlP3IgAgxjku
         HPFSAknvCF/CW7yVCG+ZGteaCrTEQIT7HHGFCzs7RVjfI9p9q9W7miME5unrFs40qA
         r1/ILAP/ANB0ch+zCQpbJt+t8Lip4p8yD/BGPCuw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Bo <bo.liu@linux.alibaba.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 4.4 046/241] fuse: honor RLIMIT_FSIZE in fuse_file_fallocate
Date:   Sun,  9 Jun 2019 18:39:48 +0200
Message-Id: <20190609164149.100367661@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Bo <bo.liu@linux.alibaba.com>

commit 0cbade024ba501313da3b7e5dd2a188a6bc491b5 upstream.

fstests generic/228 reported this failure that fuse fallocate does not
honor what 'ulimit -f' has set.

This adds the necessary inode_newsize_ok() check.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
Fixes: 05ba1f082300 ("fuse: add FALLOCATE operation")
Cc: <stable@vger.kernel.org> # v3.5
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/file.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2947,6 +2947,13 @@ static long fuse_file_fallocate(struct f
 		}
 	}
 
+	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
+	    offset + length > i_size_read(inode)) {
+		err = inode_newsize_ok(inode, offset + length);
+		if (err)
+			return err;
+	}
+
 	if (!(mode & FALLOC_FL_KEEP_SIZE))
 		set_bit(FUSE_I_SIZE_UNSTABLE, &fi->state);
 


