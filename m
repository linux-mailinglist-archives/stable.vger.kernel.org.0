Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F38C96EB1F
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 21:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730259AbfGSTah (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 15:30:37 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40993 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728502AbfGSTah (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jul 2019 15:30:37 -0400
Received: by mail-pg1-f193.google.com with SMTP id x15so4539704pgg.8;
        Fri, 19 Jul 2019 12:30:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w7yvD+lTz2Rik1M6UM23psyCzKUtq59fP+VK4gnGKZc=;
        b=re1CQE68v6gVOQtijsROR6B9lXtU4K4btjVXVz4wXeix0nsP03pz4i2MWuIkyLGE3B
         Iiy4VNg4UgtSgBp9GA6EXoGEiW8KsuPoXbaVyri2CS8L1b3Rs5sq+EbINtHg7yqLk3OH
         01iz+TUOwXyhtzGa9N3uj/ZEDXwxQM6fh7dDuJZttOLYP8WvOAJu1RSSizrgxxqEab+h
         QbQYEiaX2ZMVnjqtA63Pwy/37dQu39WJ4hrkTYnxLht/aifYQrxQ1luXGL3oaLYfC/B9
         q8/aGkOumRJRy06W26AHzah/XZ+OLKzZw0nZTwDYwPXidMdwiBaWZwWAsDmZbfsDRJ7i
         HPmQ==
X-Gm-Message-State: APjAAAV2lnKvAW4/OZCFXRG7eMhoG98OIx3nBPGzuShKVEpbcbo2fmtF
        afrUFld++QIiSZC+iU1j0qw=
X-Google-Smtp-Source: APXvYqzFLxEYyoZk7LJgYCiJsT+xnKlgJn77SNJtRodirTX0SDAcyS4kNw+TCmmDIGUDib4xIRi9vw==
X-Received: by 2002:a63:b46:: with SMTP id a6mr45640148pgl.235.1563564635966;
        Fri, 19 Jul 2019 12:30:35 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id t9sm31950471pji.18.2019.07.19.12.30.34
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 19 Jul 2019 12:30:34 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 13822402A1; Fri, 19 Jul 2019 19:30:34 +0000 (UTC)
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org,
        Alexander.Levin@microsoft.com
Cc:     stable@vger.kernel.org, amir73il@gmail.com, hch@infradead.org,
        zlang@redhat.com, Brian Foster <bfoster@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH] xfs: don't trip over uninitialized buffer on extent read of corrupted inode
Date:   Fri, 19 Jul 2019 19:30:32 +0000
Message-Id: <20190719193032.11096-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190718230617.7439-1-mcgrof>
References: <20190718230617.7439-1-mcgrof>
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
[mcgrof: fixes kz#204223 ]
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

