Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 630923788D0
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235011AbhEJLYE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:24:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237326AbhEJLLu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 911A661090;
        Mon, 10 May 2021 11:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644947;
        bh=AoaY9D4d5DiejkuK4ZR7IsJTe2zz79jVdftiA/c3n2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sHixzjAbmpLlgsbEdpGTp2S+eoXq/TjlrgWDOSSVCrritjeA182qbUrWtOuRXnnWQ
         bU29+QnZdLo5VY8ggW6ZmYJ0oRxxpZMNJQ+Jg2y8RIzxKsaLHBnzzByit7mAx/MbbZ
         CQvOyllEEsh+Rjox+o41Hm39/DfPH5UJsxuJ+pvM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.12 288/384] fs: fix reporting supported extra file attributes for statx()
Date:   Mon, 10 May 2021 12:21:17 +0200
Message-Id: <20210510102024.302780283@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

commit 5afa7e8b70d65819245fece61a65fd753b4aae33 upstream.

statx(2) notes that any attribute that is not indicated as supported
by stx_attributes_mask has no usable value.  Commits 801e523796004
("fs: move generic stat response attr handling to vfs_getattr_nosec")
and 712b2698e4c02 ("fs/stat: Define DAX statx attribute") sets
STATX_ATTR_AUTOMOUNT and STATX_ATTR_DAX, respectively, without setting
stx_attributes_mask, which can cause xfstests generic/532 to fail.

Fix this in the same way as commit 1b9598c8fb99 ("xfs: fix reporting
supported extra file attributes for statx()")

Fixes: 801e523796004 ("fs: move generic stat response attr handling to vfs_getattr_nosec")
Fixes: 712b2698e4c02 ("fs/stat: Define DAX statx attribute")
Cc: stable@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/stat.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/stat.c
+++ b/fs/stat.c
@@ -86,12 +86,20 @@ int vfs_getattr_nosec(const struct path
 	/* SB_NOATIME means filesystem supplies dummy atime value */
 	if (inode->i_sb->s_flags & SB_NOATIME)
 		stat->result_mask &= ~STATX_ATIME;
+
+	/*
+	 * Note: If you add another clause to set an attribute flag, please
+	 * update attributes_mask below.
+	 */
 	if (IS_AUTOMOUNT(inode))
 		stat->attributes |= STATX_ATTR_AUTOMOUNT;
 
 	if (IS_DAX(inode))
 		stat->attributes |= STATX_ATTR_DAX;
 
+	stat->attributes_mask |= (STATX_ATTR_AUTOMOUNT |
+				  STATX_ATTR_DAX);
+
 	mnt_userns = mnt_user_ns(path->mnt);
 	if (inode->i_op->getattr)
 		return inode->i_op->getattr(mnt_userns, path, stat,


