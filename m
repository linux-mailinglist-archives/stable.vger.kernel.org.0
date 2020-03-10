Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0EC717FDD9
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728873AbgCJMvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:51:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728337AbgCJMvR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:51:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36B0820674;
        Tue, 10 Mar 2020 12:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844676;
        bh=ynRe312WszRx85XR+tsK9DlAu8ik3gqbPyT1ZCXbYgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lQrointjOMSsN94UnlHp0RzFglPXtj0CjVFndflOtWPTVdfsCWQ23d0tkiTVFSY4X
         Db+NJhyFtfGb8z2Ko4DppSFxAeR3OX9pG3wehWD30oFdLIVj3hkDa/hqIos1viJ7p5
         NGAcAZEfFkNe7nmn2vrVyhayrgtZKIB9NJrbPMdo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Omar Sandoval <osandov@fb.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 079/168] btrfs: fix RAID direct I/O reads with alternate csums
Date:   Tue, 10 Mar 2020 13:38:45 +0100
Message-Id: <20200310123643.301496512@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

commit e7a04894c766daa4248cb736efee93550f2d5872 upstream.

btrfs_lookup_and_bind_dio_csum() does pointer arithmetic which assumes
32-bit checksums. If using a larger checksum, this leads to spurious
failures when a direct I/O read crosses a stripe. This is easy
to reproduce:

  # mkfs.btrfs -f --checksum blake2 -d raid0 /dev/vdc /dev/vdd
  ...
  # mount /dev/vdc /mnt
  # cd /mnt
  # dd if=/dev/urandom of=foo bs=1M count=1 status=none
  # dd if=foo of=/dev/null bs=1M iflag=direct status=none
  dd: error reading 'foo': Input/output error
  # dmesg | tail -1
  [  135.821568] BTRFS warning (device vdc): csum failed root 5 ino 257 off 421888 ...

Fix it by using the actual checksum size.

Fixes: 1e25a2e3ca0d ("btrfs: don't assume ordered sums to be 4 bytes")
CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Omar Sandoval <osandov@fb.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/inode.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8426,6 +8426,7 @@ static inline blk_status_t btrfs_lookup_
 {
 	struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
 	struct btrfs_io_bio *orig_io_bio = btrfs_io_bio(dip->orig_bio);
+	u16 csum_size;
 	blk_status_t ret;
 
 	/*
@@ -8445,7 +8446,8 @@ static inline blk_status_t btrfs_lookup_
 
 	file_offset -= dip->logical_offset;
 	file_offset >>= inode->i_sb->s_blocksize_bits;
-	io_bio->csum = (u8 *)(((u32 *)orig_io_bio->csum) + file_offset);
+	csum_size = btrfs_super_csum_size(btrfs_sb(inode->i_sb)->super_copy);
+	io_bio->csum = orig_io_bio->csum + csum_size * file_offset;
 
 	return 0;
 }


