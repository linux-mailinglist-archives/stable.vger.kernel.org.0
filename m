Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9678137892C
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238774AbhEJLZz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:25:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:59196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238189AbhEJLRN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:17:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6455616E8;
        Mon, 10 May 2021 11:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620645165;
        bh=pfSywBd7sprNI/8dGoZiL56l+FLVKmM4a6KPeom7Dow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YjVh/DAB2ocv6Jp0KKPuOVTjbh57Gjpv56D2tvOKuOmh8pDX5kCSWbtP4W1+9Shir
         i/XPB4pT4TMgYZEEw8xrgkLzoVH8Hhnqu7mDLdsm1LB5hyk3fBwFpRXw7mwiN192jI
         M2a7eAYC1JINVRnWRhlH+X52ZMd/bqCyCbxLAh2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.12 344/384] ext4: allow the dax flag to be set and cleared on inline directories
Date:   Mon, 10 May 2021 12:22:13 +0200
Message-Id: <20210510102026.112563683@linuxfoundation.org>
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
@@ -1292,7 +1292,8 @@ got:
 
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
@@ -315,6 +315,12 @@ static void ext4_dax_dontcache(struct in
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


