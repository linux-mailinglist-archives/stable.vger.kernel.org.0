Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E44073786F3
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233868AbhEJLMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:12:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:39736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235737AbhEJLF6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:05:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EDD561490;
        Mon, 10 May 2021 10:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644159;
        bh=Et9ybeFG/T13ZeHpjvXLj3rtpFizC+VnvgdSddpH7b0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pZm69vjNdAH14uwLHkCUEn4m7mP4JeYukNRahXF2KxNaENwg1WydwqCU9PW5j8Vt0
         Kefm0LeetfQXOBiCDml92k8NOKq5IrohRjfDj7fCpnhhC1w7vqv0ZoNhLanzTzIyhU
         2Cv8Xo+rpP67HRx0uulgvEfhdqSMi4j/SmrDqfis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.11 311/342] ext4: allow the dax flag to be set and cleared on inline directories
Date:   Mon, 10 May 2021 12:21:41 +0200
Message-Id: <20210510102020.379721452@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
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


