Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34522348FBB
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231442AbhCYL3r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:29:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:35468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231469AbhCYL1X (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:27:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86C5861A4E;
        Thu, 25 Mar 2021 11:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671618;
        bh=QHdcJTezi9bvA14StpNy4bsRWJsJICWDl/4yxaAs0+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VCei0o4GR+gWeSj9he4fc41Mz+udEy5cF2dxh7HVShmwtmHNxO5yEskEzxPuIv9z7
         lzuI71RM+WPlHDHyx5u2xZp1mBD25VMKukL9FefYJeYcVhLnlpgAV+0slL/Nu/fl+W
         KfO+FzI+Hg9XmvrDR4NwWDtOPn+7F3d+Ivuosk5lM/q4icqORb2LbxyFsxP+hRL+I/
         TurY5m2/jrMmGCWP/CYoVDmdFFbbu1RtUruLQ+/tOgLACGUAhsqa6ZI3ycbyAGvPoy
         M8U+HKGjdhCfymvxkeerYQvYXbijWPY++3sVVaPrZi3HADe3gbdgyKgYmb6y4JOhuk
         ytfluLeaMcA7g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ritesh Harjani <riteshh@linux.ibm.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 05/24] iomap: Fix negative assignment to unsigned sis->pages in iomap_swapfile_activate
Date:   Thu, 25 Mar 2021 07:26:31 -0400
Message-Id: <20210325112651.1927828-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112651.1927828-1-sashal@kernel.org>
References: <20210325112651.1927828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ritesh Harjani <riteshh@linux.ibm.com>

[ Upstream commit 5808fecc572391867fcd929662b29c12e6d08d81 ]

In case if isi.nr_pages is 0, we are making sis->pages (which is
unsigned int) a huge value in iomap_swapfile_activate() by assigning -1.
This could cause a kernel crash in kernel v4.18 (with below signature).
Or could lead to unknown issues on latest kernel if the fake big swap gets
used.

Fix this issue by returning -EINVAL in case of nr_pages is 0, since it
is anyway a invalid swapfile. Looks like this issue will be hit when
we have pagesize < blocksize type of configuration.

I was able to hit the issue in case of a tiny swap file with below
test script.
https://raw.githubusercontent.com/riteshharjani/LinuxStudy/master/scripts/swap-issue.sh

kernel crash analysis on v4.18
==============================
On v4.18 kernel, it causes a kernel panic, since sis->pages becomes
a huge value and isi.nr_extents is 0. When 0 is returned it is
considered as a swapfile over NFS and SWP_FILE is set (sis->flags |= SWP_FILE).
Then when swapoff was getting called it was calling a_ops->swap_deactivate()
if (sis->flags & SWP_FILE) is true. Since a_ops->swap_deactivate() is
NULL in case of XFS, it causes below panic.

Panic signature on v4.18 kernel:
=======================================
root@qemu:/home/qemu# [ 8291.723351] XFS (loop2): Unmounting Filesystem
[ 8292.123104] XFS (loop2): Mounting V5 Filesystem
[ 8292.132451] XFS (loop2): Ending clean mount
[ 8292.263362] Adding 4294967232k swap on /mnt1/test/swapfile.  Priority:-2 extents:1 across:274877906880k
[ 8292.277834] Unable to handle kernel paging request for instruction fetch
[ 8292.278677] Faulting instruction address: 0x00000000
cpu 0x19: Vector: 400 (Instruction Access) at [c0000009dd5b7ad0]
    pc: 0000000000000000
    lr: c0000000003eb9dc: destroy_swap_extents+0xfc/0x120
    sp: c0000009dd5b7d50
   msr: 8000000040009033
  current = 0xc0000009b6710080
  paca    = 0xc00000003ffcb280   irqmask: 0x03   irq_happened: 0x01
    pid   = 5604, comm = swapoff
Linux version 4.18.0 (riteshh@xxxxxxx) (gcc version 8.4.0 (Ubuntu 8.4.0-1ubuntu1~18.04)) #57 SMP Wed Mar 3 01:33:04 CST 2021
enter ? for help
[link register   ] c0000000003eb9dc destroy_swap_extents+0xfc/0x120
[c0000009dd5b7d50] c0000000025a7058 proc_poll_event+0x0/0x4 (unreliable)
[c0000009dd5b7da0] c0000000003f0498 sys_swapoff+0x3f8/0x910
[c0000009dd5b7e30] c00000000000bbe4 system_call+0x5c/0x70
Exception: c01 (System Call) at 00007ffff7d208d8

Signed-off-by: Ritesh Harjani <riteshh@linux.ibm.com>
[djwong: rework the comment to provide more details]
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/swapfile.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/iomap/swapfile.c b/fs/iomap/swapfile.c
index 152a230f668d..bd0cc3dcc980 100644
--- a/fs/iomap/swapfile.c
+++ b/fs/iomap/swapfile.c
@@ -169,6 +169,16 @@ int iomap_swapfile_activate(struct swap_info_struct *sis,
 			return ret;
 	}
 
+	/*
+	 * If this swapfile doesn't contain even a single page-aligned
+	 * contiguous range of blocks, reject this useless swapfile to
+	 * prevent confusion later on.
+	 */
+	if (isi.nr_pages == 0) {
+		pr_warn("swapon: Cannot find a single usable page in file.\n");
+		return -EINVAL;
+	}
+
 	*pagespan = 1 + isi.highest_ppage - isi.lowest_ppage;
 	sis->max = isi.nr_pages;
 	sis->pages = isi.nr_pages - 1;
-- 
2.30.1

