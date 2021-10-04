Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 109BF420F2A
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237195AbhJDNbv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:31:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:43146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236200AbhJDN34 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:29:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A61C63211;
        Mon,  4 Oct 2021 13:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353209;
        bh=YVM1qJLkAz9m9lgpqMLFHMDwbkB1ObpkKKX7R05J5t4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2pC8h1taa6IappY+4MlavAkhvRG6FXApxJpbuVEw0x8hY6zZBZY6nG+lSKP/3yrTC
         it8DHe796jDLgZ/Ou9+RgSif36MjUdmPl/vGhhyp0s02+pyGSG1CieNgqS6pOsPOdR
         2DFMY49D1SoVaOC+WzTMDKuXjSyr8K9oqh7X9uQo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Boris Burkov <boris@bur.io>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH 5.14 039/172] fs-verity: fix signed integer overflow with i_size near S64_MAX
Date:   Mon,  4 Oct 2021 14:51:29 +0200
Message-Id: <20211004125046.248622745@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 80f6e3080bfcf865062a926817b3ca6c4a137a57 upstream.

If the file size is almost S64_MAX, the calculated number of Merkle tree
levels exceeds FS_VERITY_MAX_LEVELS, causing FS_IOC_ENABLE_VERITY to
fail.  This is unintentional, since as the comment above the definition
of FS_VERITY_MAX_LEVELS states, it is enough for over U64_MAX bytes of
data using SHA-256 and 4K blocks.  (Specifically, 4096*128**8 >= 2**64.)

The bug is actually that when the number of blocks in the first level is
calculated from i_size, there is a signed integer overflow due to i_size
being signed.  Fix this by treating i_size as unsigned.

This was found by the new test "generic: test fs-verity EFBIG scenarios"
(https://lkml.kernel.org/r/b1d116cd4d0ea74b9cd86f349c672021e005a75c.1631558495.git.boris@bur.io).

This didn't affect ext4 or f2fs since those have a smaller maximum file
size, but it did affect btrfs which allows files up to S64_MAX bytes.

Reported-by: Boris Burkov <boris@bur.io>
Fixes: 3fda4c617e84 ("fs-verity: implement FS_IOC_ENABLE_VERITY ioctl")
Fixes: fd2d1acfcadf ("fs-verity: add the hook for file ->open()")
Cc: <stable@vger.kernel.org> # v5.4+
Reviewed-by: Boris Burkov <boris@bur.io>
Link: https://lore.kernel.org/r/20210916203424.113376-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/verity/enable.c |    2 +-
 fs/verity/open.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/verity/enable.c
+++ b/fs/verity/enable.c
@@ -177,7 +177,7 @@ static int build_merkle_tree(struct file
 	 * (level 0) and ascending to the root node (level 'num_levels - 1').
 	 * Then at the end (level 'num_levels'), calculate the root hash.
 	 */
-	blocks = (inode->i_size + params->block_size - 1) >>
+	blocks = ((u64)inode->i_size + params->block_size - 1) >>
 		 params->log_blocksize;
 	for (level = 0; level <= params->num_levels; level++) {
 		err = build_merkle_tree_level(filp, level, blocks, params,
--- a/fs/verity/open.c
+++ b/fs/verity/open.c
@@ -89,7 +89,7 @@ int fsverity_init_merkle_tree_params(str
 	 */
 
 	/* Compute number of levels and the number of blocks in each level */
-	blocks = (inode->i_size + params->block_size - 1) >> log_blocksize;
+	blocks = ((u64)inode->i_size + params->block_size - 1) >> log_blocksize;
 	pr_debug("Data is %lld bytes (%llu blocks)\n", inode->i_size, blocks);
 	while (blocks > 1) {
 		if (params->num_levels >= FS_VERITY_MAX_LEVELS) {


