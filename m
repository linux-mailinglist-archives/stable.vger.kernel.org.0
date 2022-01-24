Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C8F49A9CC
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1323560AbiAYD2v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:28:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353277AbiAXVFL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:05:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5259C068096;
        Mon, 24 Jan 2022 12:04:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7538F6131F;
        Mon, 24 Jan 2022 20:04:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1BBC340E5;
        Mon, 24 Jan 2022 20:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054698;
        bh=9eZ9Mv8v14jvy7gY6J9fTqWGXGy5n8+bAcU7ppON4YQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EMMgGAmXsth3PYc29O0U2WxswzUEIevB10IuTBl5cxqev+v7MTHZQPGTLupZNINBV
         53tc389HaKFQ42Hyzx2/hS7zgPk2RsecGAxceBUENoyzm7/9DEST+kT1rY0FvJjpIK
         ZNRi14T78zh1GAkhvrfFiQZQaxhIDf/LzJRUqFMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 5.10 475/563] ext4: initialize err_blk before calling __ext4_get_inode_loc
Date:   Mon, 24 Jan 2022 19:44:00 +0100
Message-Id: <20220124184040.900353306@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
@@ -4445,7 +4445,7 @@ has_buffer:
 static int __ext4_get_inode_loc_noinmem(struct inode *inode,
 					struct ext4_iloc *iloc)
 {
-	ext4_fsblk_t err_blk;
+	ext4_fsblk_t err_blk = 0;
 	int ret;
 
 	ret = __ext4_get_inode_loc(inode->i_sb, inode->i_ino, iloc, 0,
@@ -4460,7 +4460,7 @@ static int __ext4_get_inode_loc_noinmem(
 
 int ext4_get_inode_loc(struct inode *inode, struct ext4_iloc *iloc)
 {
-	ext4_fsblk_t err_blk;
+	ext4_fsblk_t err_blk = 0;
 	int ret;
 
 	/* We have all inode data except xattrs in memory here. */


