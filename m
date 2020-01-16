Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 542FD13FF58
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389541AbgAPX0j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:26:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:57432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389521AbgAPX0i (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:26:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 314C72072B;
        Thu, 16 Jan 2020 23:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217197;
        bh=SVJmoXEarOoz5TtLX6oxSO0j1YGh+KQ936Pf8K3ZsFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nxm0riow8nzwN5DGMDqoj+vb/dc5/leX4lBhFERzbwDL1v2roru+JTIxBni2jf0xK
         looqw+MGqPR99jiWvvfaALkJEK/OfCKbWxbYIRo5zaKyYOPzkAKLs7+vr+by9eHwgd
         6j1fKHq3+8v0duWNFcuyZW70eEJ7wINWbJOx91NM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Dooks <ben.dooks@codethink.co.uk>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.4 163/203] ubifs: Fixed missed le64_to_cpu() in journal
Date:   Fri, 17 Jan 2020 00:18:00 +0100
Message-Id: <20200116231758.943679715@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Dooks (Codethink) <ben.dooks@codethink.co.uk>

commit df22b5b3ecc6233e33bd27f67f14c0cd1b5a5897 upstream.

In the ubifs_jnl_write_inode() functon, it calls ubifs_iget()
with xent->inum. The xent->inum is __le64, but the ubifs_iget()
takes native cpu endian.

I think that this should be changed to passing le64_to_cpu(xent->inum)
to fix the following sparse warning:

fs/ubifs/journal.c:902:58: warning: incorrect type in argument 2 (different base types)
fs/ubifs/journal.c:902:58:    expected unsigned long inum
fs/ubifs/journal.c:902:58:    got restricted __le64 [usertype] inum

Fixes: 7959cf3a7506 ("ubifs: journal: Handle xattrs like files")
Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ubifs/journal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ubifs/journal.c
+++ b/fs/ubifs/journal.c
@@ -899,7 +899,7 @@ int ubifs_jnl_write_inode(struct ubifs_i
 			fname_name(&nm) = xent->name;
 			fname_len(&nm) = le16_to_cpu(xent->nlen);
 
-			xino = ubifs_iget(c->vfs_sb, xent->inum);
+			xino = ubifs_iget(c->vfs_sb, le64_to_cpu(xent->inum));
 			if (IS_ERR(xino)) {
 				err = PTR_ERR(xino);
 				ubifs_err(c, "dead directory entry '%s', error %d",


