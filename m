Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04852797F3
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730011AbfG2UEU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 16:04:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:34684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389981AbfG2Tpk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:45:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D98020C01;
        Mon, 29 Jul 2019 19:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429539;
        bh=nsfP82QPrsH9+pwdLvCOq51KQy4SE8oz+B42GGwG1Go=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=smNvxCz8QkqNjMvfzirnrL+3NqEwuUxy/i/pL12jAylDbKe0N6ksTw77zwusMDMnc
         EBPLJxA+OdCxOSYVsFp1SpqU25lF1JbU5UShZKtT9jAoda02QrvtwaULkZk3RTWSD+
         A9Y0FvJ93/ajco/8Cl5nWKt7ILm+AzSu5+Qs+/l0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Park Ju Hyung <qkrwngud825@gmail.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 017/215] f2fs: fix to check layout on last valid checkpoint park
Date:   Mon, 29 Jul 2019 21:20:13 +0200
Message-Id: <20190729190742.519767411@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5dae2d39074dde941cc3150dcbb7840d88179743 ]

As Ju Hyung reported:

"
I was semi-forced today to use the new kernel and test f2fs.

My Ubuntu initramfs got a bit wonky and I had to boot into live CD and
fix some stuffs. The live CD was using 4.15 kernel, and just mounting
the f2fs partition there corrupted f2fs and my 4.19(with 5.1-rc1-4.19
f2fs-stable merged) refused to mount with "SIT is corrupted node"
message.

I used the latest f2fs-tools sent by Chao including "fsck.f2fs: fix to
repair cp_loads blocks at correct position"

It spit out 140M worth of output, but at least I didn't have to run it
twice. Everything returned "Ok" in the 2nd run.
The new log is at
http://arter97.com/f2fs/final

After fixing the image, I used my 4.19 kernel with 5.2-rc1-4.19
f2fs-stable merged and it mounted.

But, I got this:
[    1.047791] F2FS-fs (nvme0n1p3): layout of large_nat_bitmap is
deprecated, run fsck to repair, chksum_offset: 4092
[    1.081307] F2FS-fs (nvme0n1p3): Found nat_bits in checkpoint
[    1.161520] F2FS-fs (nvme0n1p3): recover fsync data on readonly fs
[    1.162418] F2FS-fs (nvme0n1p3): Mounted with checkpoint version = 761c7e00

But after doing a reboot, the message is gone:
[    1.098423] F2FS-fs (nvme0n1p3): Found nat_bits in checkpoint
[    1.177771] F2FS-fs (nvme0n1p3): recover fsync data on readonly fs
[    1.178365] F2FS-fs (nvme0n1p3): Mounted with checkpoint version = 761c7eda

I'm not exactly sure why the kernel detected that I'm still using the
old layout on the first boot. Maybe fsck didn't fix it properly, or
the check from the kernel is improper.
"

Although we have rebuild the old deprecated checkpoint with new layout
during repair, we only repair last checkpoint park, the other old one is
remained.

Once the image was mounted, we will 1) sanity check layout and 2) decide
which checkpoint park to use according to cp_ver. So that we will print
reported message unnecessarily at step 1), to avoid it, we simply move
layout check into f2fs_sanity_check_ckpt() after step 2).

Reported-by: Park Ju Hyung <qkrwngud825@gmail.com>
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/checkpoint.c | 11 -----------
 fs/f2fs/super.c      |  9 +++++++++
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index ed70b68b2b38..d0539ddad6e2 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -832,17 +832,6 @@ static int get_checkpoint_version(struct f2fs_sb_info *sbi, block_t cp_addr,
 		return -EINVAL;
 	}
 
-	if (__is_set_ckpt_flags(*cp_block, CP_LARGE_NAT_BITMAP_FLAG)) {
-		if (crc_offset != CP_MIN_CHKSUM_OFFSET) {
-			f2fs_put_page(*cp_page, 1);
-			f2fs_msg(sbi->sb, KERN_WARNING,
-				"layout of large_nat_bitmap is deprecated, "
-				"run fsck to repair, chksum_offset: %zu",
-				crc_offset);
-			return -EINVAL;
-		}
-	}
-
 	crc = f2fs_checkpoint_chksum(sbi, *cp_block);
 	if (crc != cur_cp_crc(*cp_block)) {
 		f2fs_put_page(*cp_page, 1);
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 6b959bbb336a..856f9081c599 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2718,6 +2718,15 @@ int f2fs_sanity_check_ckpt(struct f2fs_sb_info *sbi)
 		return 1;
 	}
 
+	if (__is_set_ckpt_flags(ckpt, CP_LARGE_NAT_BITMAP_FLAG) &&
+		le32_to_cpu(ckpt->checksum_offset) != CP_MIN_CHKSUM_OFFSET) {
+		f2fs_msg(sbi->sb, KERN_WARNING,
+			"layout of large_nat_bitmap is deprecated, "
+			"run fsck to repair, chksum_offset: %u",
+			le32_to_cpu(ckpt->checksum_offset));
+		return 1;
+	}
+
 	if (unlikely(f2fs_cp_error(sbi))) {
 		f2fs_msg(sbi->sb, KERN_ERR, "A bug case: need to run fsck");
 		return 1;
-- 
2.20.1



