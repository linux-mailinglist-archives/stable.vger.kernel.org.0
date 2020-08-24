Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75F2D24F84B
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729509AbgHXJ3M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 05:29:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:55446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729886AbgHXIvA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:51:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26AF2204FD;
        Mon, 24 Aug 2020 08:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598259059;
        bh=aGLp3zmK/pZ7U2zYcovkf1Te9IJe7NFiu1HuOT6reYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZOtTzZ/Dl7RPP4/wCDr34WSALD7GWuGEWsCVXPOvNG6ghEdMq64Bz7D4mWyixijlH
         fQoYyVlRpr4diUOSViV91JK6LpGbJc8MOlglY2j+fHG/S91O/13ilUXBDyIe58e/lZ
         uMe9fsneLDK9jnfCDifPUecAaCzTBUgI4qhgJsgA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 15/33] ext4: fix checking of directory entry validity for inline directories
Date:   Mon, 24 Aug 2020 10:31:11 +0200
Message-Id: <20200824082347.295184080@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082346.498653578@linuxfoundation.org>
References: <20200824082346.498653578@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit 7303cb5bfe845f7d43cd9b2dbd37dbb266efda9b ]

ext4_search_dir() and ext4_generic_delete_entry() can be called both for
standard director blocks and for inline directories stored inside inode
or inline xattr space. For the second case we didn't call
ext4_check_dir_entry() with proper constraints that could result in
accepting corrupted directory entry as well as false positive filesystem
errors like:

EXT4-fs error (device dm-0): ext4_search_dir:1395: inode #28320400:
block 113246792: comm dockerd: bad entry in directory: directory entry too
close to block end - offset=0, inode=28320403, rec_len=32, name_len=8,
size=4096

Fix the arguments passed to ext4_check_dir_entry().

Fixes: 109ba779d6cc ("ext4: check for directory entries too close to block end")
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20200731162135.8080-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/namei.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index eb41fb189d4b3..faf142a6fa8bb 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1279,8 +1279,8 @@ int ext4_search_dir(struct buffer_head *bh, char *search_buf, int buf_size,
 		    ext4_match(fname, de)) {
 			/* found a match - just to be sure, do
 			 * a full check */
-			if (ext4_check_dir_entry(dir, NULL, de, bh, bh->b_data,
-						 bh->b_size, offset))
+			if (ext4_check_dir_entry(dir, NULL, de, bh, search_buf,
+						 buf_size, offset))
 				return -1;
 			*res_dir = de;
 			return 1;
@@ -2312,7 +2312,7 @@ int ext4_generic_delete_entry(handle_t *handle,
 	de = (struct ext4_dir_entry_2 *)entry_buf;
 	while (i < buf_size - csum_size) {
 		if (ext4_check_dir_entry(dir, NULL, de, bh,
-					 bh->b_data, bh->b_size, i))
+					 entry_buf, buf_size, i))
 			return -EFSCORRUPTED;
 		if (de == de_del)  {
 			if (pde)
-- 
2.25.1



