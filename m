Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C70DE378529
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233473AbhEJK7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:59:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:52164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233777AbhEJKzL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:55:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D8B861976;
        Mon, 10 May 2021 10:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643347;
        bh=Et9ybeFG/T13ZeHpjvXLj3rtpFizC+VnvgdSddpH7b0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uJa4RpqNEORhnwEGBRLDlJLA5xFI6hn9nPi+jJAQlHHwveFO/Ct8l01/8uu3S82Db
         QO9JmQX0T/TAWVjiz0O6vr//WhJs62xODyzSB2YvnwEQxJIEql3VQX12yiHMJe9xwe
         rCOi0qRM4Bu9AEjBvVwMCPgQIJoHnM/nMOpQ57/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 271/299] ext4: allow the dax flag to be set and cleared on inline directories
Date:   Mon, 10 May 2021 12:21:08 +0200
Message-Id: <20210510102013.887101065@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

commit 4811d9929cdae4238baf5b2522247bd2f9fa7b50 upstream.

This is needed to allow generic/607 to pass for file systems with the
inline data_feature enabled, and it allows the use of file systems
where the directories use inline_data, while the files are accessed
via DAX.

Cc: stable@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ialloc.c |    3 ++-
 fs/ext4/ioctl.c  |    6 ++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1291,7 +1291,8 @@ got:
 
 	ei->i_extra_isize = sbi->s_want_extra_isize;
 	ei->i_inline_off = 0;
-	if (ext4_has_feature_inline_data(sb))
+	if (ext4_has_feature_inline_data(sb) &&
+	    (!(ei->i_flags & EXT4_DAX_FL) || S_ISDIR(mode)))
 		ext4_set_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
 	ret = inode;
 	err = dquot_alloc_inode(inode);
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -312,6 +312,12 @@ static void ext4_dax_dontcache(struct in
 static bool dax_compatible(struct inode *inode, unsigned int oldflags,
 			   unsigned int flags)
 {
+	/* Allow the DAX flag to be changed on inline directories */
+	if (S_ISDIR(inode->i_mode)) {
+		flags &= ~EXT4_INLINE_DATA_FL;
+		oldflags &= ~EXT4_INLINE_DATA_FL;
+	}
+
 	if (flags & EXT4_DAX_FL) {
 		if ((oldflags & EXT4_DAX_MUT_EXCL) ||
 		     ext4_test_inode_state(inode,


