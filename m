Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A76CA7285A
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 08:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbfGXGfE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 02:35:04 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35710 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbfGXGfE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 02:35:04 -0400
Received: by mail-pf1-f196.google.com with SMTP id u14so20416645pfn.2;
        Tue, 23 Jul 2019 23:35:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a7OLt6SdphJLC3KX11dh+vTe/UHV3hqBjBxVyeYogZA=;
        b=APHVxKqlIAdhDPeGpkOaYAGRl5YOtXZoYSZ+2wx/PjIRkZaRtFWSLzcXlLINDrbI7g
         pDu2/Zc9eoI+jr1VgWidIpkT/xg+IQpSW526ykQXdidjZ0Eiej3I0GTP6Vbge/2IWTaE
         1SzZfv66zmmhH3w7nhIuK0EPhFaY9R7VRIPYlPxiMBaL8lV9IQLVLQTkF1RsEBmenLly
         AgZuCKhDub4Xls4+lev5uLJZMUUasAucY1De7e+tsZ3GIAyk4TMHpx7wfjPhsdxY5sQz
         QoZpzMLgLOqfoB2BZA+Z2/m+8fKAhaYFn16VfB3K4lWw+1tfhqTGjMGy4Qqc3k0ZdjzW
         /UAA==
X-Gm-Message-State: APjAAAUlXZfxhWcl2/dkxI8dR6P2+tjYq3q9q8hy4d3Oh0PUo7JyKep+
        pcUjc/3VJGxvWhmldRXVpAs=
X-Google-Smtp-Source: APXvYqyMfBbsY0qMuOzQnukkC8JbNNZSTNhqcS/tLZymQuEBMz9SP5K7uICLyGGRaP6S9Lr5YhYjMg==
X-Received: by 2002:a65:6108:: with SMTP id z8mr48578959pgu.289.1563950103070;
        Tue, 23 Jul 2019 23:35:03 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id o130sm73757405pfg.171.2019.07.23.23.34.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 23:34:59 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 6FFA44012C; Wed, 24 Jul 2019 06:34:58 +0000 (UTC)
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     linux-xfs@vger.kernel.org, Alexander.Levin@microsoft.com
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        amir73il@gmail.com, Brian Foster <bfoster@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 1/6] xfs: don't trip over uninitialized buffer on extent read of corrupted inode
Date:   Wed, 24 Jul 2019 06:34:46 +0000
Message-Id: <20190724063451.26190-2-mcgrof@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190724063451.26190-1-mcgrof@kernel.org>
References: <20190724063451.26190-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit 6958d11f77d45db80f7e22a21a74d4d5f44dc667 upstream.

We've had rather rare reports of bmap btree block corruption where
the bmap root block has a level count of zero. The root cause of the
corruption is so far unknown. We do have verifier checks to detect
this form of on-disk corruption, but this doesn't cover a memory
corruption variant of the problem. The latter is a reasonable
possibility because the root block is part of the inode fork and can
reside in-core for some time before inode extents are read.

If this occurs, it leads to a system crash such as the following:

 BUG: unable to handle kernel paging request at ffffffff00000221
 PF error: [normal kernel read fault]
 ...
 RIP: 0010:xfs_trans_brelse+0xf/0x200 [xfs]
 ...
 Call Trace:
  xfs_iread_extents+0x379/0x540 [xfs]
  xfs_file_iomap_begin_delay+0x11a/0xb40 [xfs]
  ? xfs_attr_get+0xd1/0x120 [xfs]
  ? iomap_write_begin.constprop.40+0x2d0/0x2d0
  xfs_file_iomap_begin+0x4c4/0x6d0 [xfs]
  ? __vfs_getxattr+0x53/0x70
  ? iomap_write_begin.constprop.40+0x2d0/0x2d0
  iomap_apply+0x63/0x130
  ? iomap_write_begin.constprop.40+0x2d0/0x2d0
  iomap_file_buffered_write+0x62/0x90
  ? iomap_write_begin.constprop.40+0x2d0/0x2d0
  xfs_file_buffered_aio_write+0xe4/0x3b0 [xfs]
  __vfs_write+0x150/0x1b0
  vfs_write+0xba/0x1c0
  ksys_pwrite64+0x64/0xa0
  do_syscall_64+0x5a/0x1d0
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The crash occurs because xfs_iread_extents() attempts to release an
uninitialized buffer pointer as the level == 0 value prevented the
buffer from ever being allocated or read. Change the level > 0
assert to an explicit error check in xfs_iread_extents() to avoid
crashing the kernel in the event of localized, in-core inode
corruption.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 3a496ffe6551..ab2465bc413a 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1178,7 +1178,10 @@ xfs_iread_extents(
 	 * Root level must use BMAP_BROOT_PTR_ADDR macro to get ptr out.
 	 */
 	level = be16_to_cpu(block->bb_level);
-	ASSERT(level > 0);
+	if (unlikely(level == 0)) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
+		return -EFSCORRUPTED;
+	}
 	pp = XFS_BMAP_BROOT_PTR_ADDR(mp, block, 1, ifp->if_broot_bytes);
 	bno = be64_to_cpu(*pp);
 
-- 
2.18.0

