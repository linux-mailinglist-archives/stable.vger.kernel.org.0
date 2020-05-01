Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D15F1C16BC
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730979AbgEANw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:52:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:36902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730538AbgEANhn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:37:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0749B2173E;
        Fri,  1 May 2020 13:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340262;
        bh=QYf+C4nM/MoIhpuZUdyO8q0kRjg4YFz2TyZsJzE+QHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b91o6wGYCAO59bfwWKAxd0sxdh7PPzW9rXH44IJIlengFtceQULy9o37eu73Tb5xS
         wQ6zRYlh6DQOIxtCbuWefWRss7xSmd1g47zINhARPuFxscbUhcT+Bt4sF7iBIp6fS9
         9FtFKUxagFT8u91kdZOIPjbxhfPNIyojRFPtQyss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harish Sriram <harish@linux.ibm.com>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.19 46/46] ext4: check for non-zero journal inum in ext4_calculate_overhead
Date:   Fri,  1 May 2020 15:23:11 +0200
Message-Id: <20200501131514.540152633@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131457.023036302@linuxfoundation.org>
References: <20200501131457.023036302@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ritesh Harjani <riteshh@linux.ibm.com>

commit f1eec3b0d0a849996ebee733b053efa71803dad5 upstream.

While calculating overhead for internal journal, also check
that j_inum shouldn't be 0. Otherwise we get below error with
xfstests generic/050 with external journal (XXX_LOGDEV config) enabled.

It could be simply reproduced with loop device with an external journal
and marking blockdev as RO before mounting.

[ 3337.146838] EXT4-fs error (device pmem1p2): ext4_get_journal_inode:4634: comm mount: inode #0: comm mount: iget: illegal inode #
------------[ cut here ]------------
generic_make_request: Trying to write to read-only block-device pmem1p2 (partno 2)
WARNING: CPU: 107 PID: 115347 at block/blk-core.c:788 generic_make_request_checks+0x6b4/0x7d0
CPU: 107 PID: 115347 Comm: mount Tainted: G             L   --------- -t - 4.18.0-167.el8.ppc64le #1
NIP:  c0000000006f6d44 LR: c0000000006f6d40 CTR: 0000000030041dd4
<...>
NIP [c0000000006f6d44] generic_make_request_checks+0x6b4/0x7d0
LR [c0000000006f6d40] generic_make_request_checks+0x6b0/0x7d0
<...>
Call Trace:
generic_make_request_checks+0x6b0/0x7d0 (unreliable)
generic_make_request+0x3c/0x420
submit_bio+0xd8/0x200
submit_bh_wbc+0x1e8/0x250
__sync_dirty_buffer+0xd0/0x210
ext4_commit_super+0x310/0x420 [ext4]
__ext4_error+0xa4/0x1e0 [ext4]
__ext4_iget+0x388/0xe10 [ext4]
ext4_get_journal_inode+0x40/0x150 [ext4]
ext4_calculate_overhead+0x5a8/0x610 [ext4]
ext4_fill_super+0x3188/0x3260 [ext4]
mount_bdev+0x778/0x8f0
ext4_mount+0x28/0x50 [ext4]
mount_fs+0x74/0x230
vfs_kern_mount.part.6+0x6c/0x250
do_mount+0x2fc/0x1280
sys_mount+0x158/0x180
system_call+0x5c/0x70
EXT4-fs (pmem1p2): no journal found
EXT4-fs (pmem1p2): can't get journal size
EXT4-fs (pmem1p2): mounted filesystem without journal. Opts: dax,norecovery

Fixes: 3c816ded78bb ("ext4: use journal inode to determine journal overhead")
Reported-by: Harish Sriram <harish@linux.ibm.com>
Signed-off-by: Ritesh Harjani <riteshh@linux.ibm.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20200316093038.25485-1-riteshh@linux.ibm.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/super.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3524,7 +3524,8 @@ int ext4_calculate_overhead(struct super
 	 */
 	if (sbi->s_journal && !sbi->journal_bdev)
 		overhead += EXT4_NUM_B2C(sbi, sbi->s_journal->j_maxlen);
-	else if (ext4_has_feature_journal(sb) && !sbi->s_journal) {
+	else if (ext4_has_feature_journal(sb) && !sbi->s_journal && j_inum) {
+		/* j_inum for internal journal is non-zero */
 		j_inode = ext4_get_journal_inode(sb, j_inum);
 		if (j_inode) {
 			j_blocks = j_inode->i_size >> sb->s_blocksize_bits;


