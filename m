Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96F6D499580
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442045AbiAXUwj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:52:39 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47716 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391493AbiAXUr7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:47:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1630CB8105C;
        Mon, 24 Jan 2022 20:47:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C90EC340E5;
        Mon, 24 Jan 2022 20:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057276;
        bh=IlfeoWM02awDHdswG5X2TjIBFG9nfZxCQnnGwfgarTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iUP206pD5fEKBB89YfmgIU65VfHAOO+bekWj+wtyBa52YBy1pwy5vPKqawKGhMB+H
         oR+NegdlyM8Eov8pPGWWgJYGholz2//yDePgMEOUSKz5781XWH2bxlllXLfnOwe45R
         XN6Z8alcZoo3YcfqsT4fhjRIboW1tRVT0srgIc+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 5.15 716/846] ext4: initialize err_blk before calling __ext4_get_inode_loc
Date:   Mon, 24 Jan 2022 19:43:53 +0100
Message-Id: <20220124184125.722082359@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harshad Shirwadkar <harshadshirwadkar@gmail.com>

commit c27c29c6af4f3f4ce925a2111c256733c5a5b430 upstream.

It is not guaranteed that __ext4_get_inode_loc will definitely set
err_blk pointer when it returns EIO. To avoid using uninitialized
variables, let's first set err_blk to 0.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Link: https://lore.kernel.org/r/20211201163421.2631661-1-harshads@google.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4371,7 +4371,7 @@ has_buffer:
 static int __ext4_get_inode_loc_noinmem(struct inode *inode,
 					struct ext4_iloc *iloc)
 {
-	ext4_fsblk_t err_blk;
+	ext4_fsblk_t err_blk = 0;
 	int ret;
 
 	ret = __ext4_get_inode_loc(inode->i_sb, inode->i_ino, iloc, 0,
@@ -4386,7 +4386,7 @@ static int __ext4_get_inode_loc_noinmem(
 
 int ext4_get_inode_loc(struct inode *inode, struct ext4_iloc *iloc)
 {
-	ext4_fsblk_t err_blk;
+	ext4_fsblk_t err_blk = 0;
 	int ret;
 
 	/* We have all inode data except xattrs in memory here. */


