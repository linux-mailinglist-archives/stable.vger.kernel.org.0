Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2F691C1724
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729795AbgEAN6X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:58:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:54642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729481AbgEANac (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:30:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1AAD20757;
        Fri,  1 May 2020 13:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339832;
        bh=0bmmoobu5JO6/P+JWnOrpzSDyd+b/gmKezvE5yBlgME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J2cXFu5C14nqwQjuEgp98LYViXiU3pRpUToCyd+Zv+WEgzlEPxo/gUmsDl+8SYZhx
         qFRjSRx+uQVGds59DxYX2iEFe32nOpJtNf+n5hLLhk1odsb3iyVIOU/0y6R4SkAene
         xQGKYbMi6DzS/lCrjxK+ebNqUhIP7bNRk3XCHzDE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Arthur Marsh <arthur.marsh@internode.on.net>,
        Theodore Tso <tytso@mit.edu>, Ashwin H <ashwinh@vmware.com>
Subject: [PATCH 4.9 78/80] ext4: fix block validity checks for journal inodes using indirect blocks
Date:   Fri,  1 May 2020 15:22:12 +0200
Message-Id: <20200501131537.532578814@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131513.810761598@linuxfoundation.org>
References: <20200501131513.810761598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

commit 170417c8c7bb2cbbdd949bf5c443c0c8f24a203b upstream.

Commit 345c0dbf3a30 ("ext4: protect journal inode's blocks using
block_validity") failed to add an exception for the journal inode in
ext4_check_blockref(), which is the function used by ext4_get_branch()
for indirect blocks.  This caused attempts to read from the ext3-style
journals to fail with:

[  848.968550] EXT4-fs error (device sdb7): ext4_get_branch:171: inode #8: block 30343695: comm jbd2/sdb7-8: invalid block

Fix this by adding the missing exception check.

Fixes: 345c0dbf3a30 ("ext4: protect journal inode's blocks using block_validity")
Reported-by: Arthur Marsh <arthur.marsh@internode.on.net>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Ashwin H <ashwinh@vmware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/block_validity.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/ext4/block_validity.c
+++ b/fs/ext4/block_validity.c
@@ -274,6 +274,11 @@ int ext4_check_blockref(const char *func
 	__le32 *bref = p;
 	unsigned int blk;
 
+	if (ext4_has_feature_journal(inode->i_sb) &&
+	    (inode->i_ino ==
+	     le32_to_cpu(EXT4_SB(inode->i_sb)->s_es->s_journal_inum)))
+		return 0;
+
 	while (bref < p+max) {
 		blk = le32_to_cpu(*bref++);
 		if (blk &&


