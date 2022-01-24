Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00D89499B1D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574575AbiAXVts (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:49:48 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54650 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456098AbiAXVht (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:37:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8872861510;
        Mon, 24 Jan 2022 21:37:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BFCEC340E4;
        Mon, 24 Jan 2022 21:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060265;
        bh=OLpI67k/l5+6Nfl6y5XUeykp7wBmqWj5duco+nik+zA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=doSjkcahvqQOPe8RDHA0Mb7Is1CQ49RP5R16Ywj+ATl9MECvluCiQxxH4M8rplJIy
         vf72SBpkrw4zPA7+Oy/V1c3WhQqqRdSI22oBBVKK+pVVw1VfcCDRDBp1fE0TO5PsNF
         cpQHucQhKNeiDzDXAh9ccBBa/0dIMUC8IekdC/yg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 5.16 0892/1039] ext4: initialize err_blk before calling __ext4_get_inode_loc
Date:   Mon, 24 Jan 2022 19:44:41 +0100
Message-Id: <20220124184155.269572866@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
@@ -4523,7 +4523,7 @@ has_buffer:
 static int __ext4_get_inode_loc_noinmem(struct inode *inode,
 					struct ext4_iloc *iloc)
 {
-	ext4_fsblk_t err_blk;
+	ext4_fsblk_t err_blk = 0;
 	int ret;
 
 	ret = __ext4_get_inode_loc(inode->i_sb, inode->i_ino, NULL, iloc,
@@ -4538,7 +4538,7 @@ static int __ext4_get_inode_loc_noinmem(
 
 int ext4_get_inode_loc(struct inode *inode, struct ext4_iloc *iloc)
 {
-	ext4_fsblk_t err_blk;
+	ext4_fsblk_t err_blk = 0;
 	int ret;
 
 	ret = __ext4_get_inode_loc(inode->i_sb, inode->i_ino, inode, iloc,


