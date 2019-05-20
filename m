Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C43AC234C9
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390159AbfETMap (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:30:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:47104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390155AbfETMap (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:30:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C1B720645;
        Mon, 20 May 2019 12:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355445;
        bh=5zCdNk6o7TvfEzmsRexz2WXo2rRTLCTto/KnK33XGaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aHg4YIdgeurI9ZTHmiLdsRzJE/B4DQQ7MDOwLIIFPVjKBn78g+Ja16T9kLwhLsJxd
         y5vOZzQxkcGLaZM35FimHo8ejZwTZacPfTtL4gOfre6F8WsKezYPd4xssxYt4suul3
         Ef/9hM3ddFKWiKNXKm5ZVo5E//1An62pTLVgb1Yo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Arthur Marsh <arthur.marsh@internode.on.net>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.0 121/123] ext4: fix block validity checks for journal inodes using indirect blocks
Date:   Mon, 20 May 2019 14:15:01 +0200
Message-Id: <20190520115253.210756135@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115245.439864225@linuxfoundation.org>
References: <20190520115245.439864225@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/block_validity.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/ext4/block_validity.c
+++ b/fs/ext4/block_validity.c
@@ -276,6 +276,11 @@ int ext4_check_blockref(const char *func
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


