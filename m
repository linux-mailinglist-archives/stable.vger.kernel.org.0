Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D72D923491B
	for <lists+stable@lfdr.de>; Fri, 31 Jul 2020 18:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731222AbgGaQVr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jul 2020 12:21:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:49864 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730974AbgGaQVq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 31 Jul 2020 12:21:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 80264AC61;
        Fri, 31 Jul 2020 16:21:58 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id D66221E12CB; Fri, 31 Jul 2020 18:21:45 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH] ext4: Fix checking of entry validity
Date:   Fri, 31 Jul 2020 18:21:35 +0200
Message-Id: <20200731162135.8080-1-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 fs/ext4/namei.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 56738b538ddf..98b91f2314eb 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1396,8 +1396,8 @@ int ext4_search_dir(struct buffer_head *bh, char *search_buf, int buf_size,
 		    ext4_match(dir, fname, de)) {
 			/* found a match - just to be sure, do
 			 * a full check */
-			if (ext4_check_dir_entry(dir, NULL, de, bh, bh->b_data,
-						 bh->b_size, offset))
+			if (ext4_check_dir_entry(dir, NULL, de, bh, search_buf,
+						 buf_size, offset))
 				return -1;
 			*res_dir = de;
 			return 1;
@@ -2472,7 +2472,7 @@ int ext4_generic_delete_entry(handle_t *handle,
 	de = (struct ext4_dir_entry_2 *)entry_buf;
 	while (i < buf_size - csum_size) {
 		if (ext4_check_dir_entry(dir, NULL, de, bh,
-					 bh->b_data, bh->b_size, i))
+					 entry_buf, buf_size, i))
 			return -EFSCORRUPTED;
 		if (de == de_del)  {
 			if (pde)
-- 
2.16.4

