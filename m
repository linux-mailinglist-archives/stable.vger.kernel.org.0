Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D6242103E
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238293AbhJDNmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:42:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:51850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238356AbhJDNkU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:40:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D55F861501;
        Mon,  4 Oct 2021 13:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353504;
        bh=2qsfbws95ldWgWaAEjuk+CYl+0H/cNEXWLareyVg+tw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=taRXdU/jVnJmxmgmg4YDey2rD/Z2nsKbe9od7NmQXBg+LN7C5MiQHD+HMA12pgUPl
         YDq7Bhu7fPbkv/5OX0TbvoPMIWPXccK/Uig7zrnSrx3NTdEq3Zr5TtnwmE5IX46A/u
         6x+RqO8biO5+7LBKqfbfsF+6ZbdcGnx6Jza5Z6ws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Hou Tao <houtao1@huawei.com>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.14 154/172] ext4: limit the number of blocks in one ADD_RANGE TLV
Date:   Mon,  4 Oct 2021 14:53:24 +0200
Message-Id: <20211004125049.944161646@linuxfoundation.org>
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

From: Hou Tao <houtao1@huawei.com>

commit a2c2f0826e2b75560b31daf1cd9a755ab93cf4c6 upstream.

Now EXT4_FC_TAG_ADD_RANGE uses ext4_extent to track the
newly-added blocks, but the limit on the max value of
ee_len field is ignored, and it can lead to BUG_ON as
shown below when running command "fallocate -l 128M file"
on a fast_commit-enabled fs:

  kernel BUG at fs/ext4/ext4_extents.h:199!
  invalid opcode: 0000 [#1] SMP PTI
  CPU: 3 PID: 624 Comm: fallocate Not tainted 5.14.0-rc6+ #1
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
  RIP: 0010:ext4_fc_write_inode_data+0x1f3/0x200
  Call Trace:
   ? ext4_fc_write_inode+0xf2/0x150
   ext4_fc_commit+0x93b/0xa00
   ? ext4_fallocate+0x1ad/0x10d0
   ext4_sync_file+0x157/0x340
   ? ext4_sync_file+0x157/0x340
   vfs_fsync_range+0x49/0x80
   do_fsync+0x3d/0x70
   __x64_sys_fsync+0x14/0x20
   do_syscall_64+0x3b/0xc0
   entry_SYSCALL_64_after_hwframe+0x44/0xae

Simply fixing it by limiting the number of blocks
in one EXT4_FC_TAG_ADD_RANGE TLV.

Fixes: aa75f4d3daae ("ext4: main fast-commit commit path")
Cc: stable@kernel.org
Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Link: https://lore.kernel.org/r/20210820044505.474318-1-houtao1@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/fast_commit.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -893,6 +893,12 @@ static int ext4_fc_write_inode_data(stru
 					    sizeof(lrange), (u8 *)&lrange, crc))
 				return -ENOSPC;
 		} else {
+			unsigned int max = (map.m_flags & EXT4_MAP_UNWRITTEN) ?
+				EXT_UNWRITTEN_MAX_LEN : EXT_INIT_MAX_LEN;
+
+			/* Limit the number of blocks in one extent */
+			map.m_len = min(max, map.m_len);
+
 			fc_ext.fc_ino = cpu_to_le32(inode->i_ino);
 			ex = (struct ext4_extent *)&fc_ext.fc_ex;
 			ex->ee_block = cpu_to_le32(map.m_lblk);


