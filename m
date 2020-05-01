Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 712EE1C1410
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730753AbgEANfU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:35:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:33516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730747AbgEANfR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:35:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FF0F24953;
        Fri,  1 May 2020 13:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340116;
        bh=RnHZ55ZQd+oFxIjGZK85Q+Q5EPPSaa4vig9BLZFgBww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CQOVd1xL2/iyHHMpugEYNQnTIort+BwF40JlSPHs7h3yVvDWADee3oWFS26dB/CfX
         B1ROaF7R6WjRXWVKlMSBSZcRMLN0guTyAnsWotLWG9cqle4CgUOUxPsxmPtF2wf20r
         PpX0e+qSlcWnaAmT+X+4bKOWJEzEOhJXccb6yzK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Rue <dan.rue@linaro.org>,
        Theodore Tso <tytso@mit.edu>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Ashwin H <ashwinh@vmware.com>
Subject: [PATCH 4.14 113/117] ext4: dont perform block validity checks on the journal inode
Date:   Fri,  1 May 2020 15:22:29 +0200
Message-Id: <20200501131558.445362488@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131544.291247695@linuxfoundation.org>
References: <20200501131544.291247695@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

commit 0a944e8a6c66ca04c7afbaa17e22bf208a8b37f0 upstream.

Since the journal inode is already checked when we added it to the
block validity's system zone, if we check it again, we'll just trigger
a failure.

This was causing failures like this:

[   53.897001] EXT4-fs error (device sda): ext4_find_extent:909: inode
#8: comm jbd2/sda-8: pblk 121667583 bad header/extent: invalid extent entries - magic f30a, entries 8, max 340(340), depth 0(0)
[   53.931430] jbd2_journal_bmap: journal block not found at offset 49 on sda-8
[   53.938480] Aborting journal on device sda-8.

... but only if the system was under enough memory pressure that
logical->physical mapping for the journal inode gets pushed out of the
extent cache.  (This is why it wasn't noticed earlier.)

Fixes: 345c0dbf3a30 ("ext4: protect journal inode's blocks using block_validity")
Reported-by: Dan Rue <dan.rue@linaro.org>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Ashwin H <ashwinh@vmware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/extents.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -554,10 +554,14 @@ __read_extent_tree_block(const char *fun
 	}
 	if (buffer_verified(bh) && !(flags & EXT4_EX_FORCE_CACHE))
 		return bh;
-	err = __ext4_ext_check(function, line, inode,
-			       ext_block_hdr(bh), depth, pblk);
-	if (err)
-		goto errout;
+	if (!ext4_has_feature_journal(inode->i_sb) ||
+	    (inode->i_ino !=
+	     le32_to_cpu(EXT4_SB(inode->i_sb)->s_es->s_journal_inum))) {
+		err = __ext4_ext_check(function, line, inode,
+				       ext_block_hdr(bh), depth, pblk);
+		if (err)
+			goto errout;
+	}
 	set_buffer_verified(bh);
 	/*
 	 * If this is a leaf block, cache all of its entries


