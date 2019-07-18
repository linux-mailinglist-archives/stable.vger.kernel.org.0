Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99CBB6D711
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 01:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391612AbfGRXG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 19:06:26 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42985 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728524AbfGRXGZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 19:06:25 -0400
Received: by mail-pf1-f196.google.com with SMTP id q10so13276011pff.9;
        Thu, 18 Jul 2019 16:06:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CDu5Kn4QFjEkN6S2Xi1spwhgFAxF5TT+4s/SdRvC5So=;
        b=d+kMhlchlK+IwnmxF+LJD6miI6/PJ0pybbjjWICwRUILKsyu7RtojUd0wkxkxMy8WK
         j6cPU1kB4wCtRjLl+DBzK/HPANbychfiaNdgu+kDPrjHUeA5jdqzmAJ//YT0fseOC5HL
         5u+ZjCaET3giS5fmnZ4Ewv8zeX4pkcjbcbtjwsq11Xs0bO2LTCMsPvOIy1OXQlO8ZGQC
         LJnv6vn1T9DGSOd4VLOJIr5BLBeyWBY5VBLDin+bB63EE7qW5ciKShMmE/ZLgRPNGQUC
         ruhbubEg0gPNa1nyoK3U8TC/aNhmHsXFaf/DKEBT7Mv+78WO+OgiYBwP6DJS6ceaJU7N
         WEUw==
X-Gm-Message-State: APjAAAVUZ2MfkvVMR9Kt+itOeF2JAFZM+9Ieaf+cfMC2wk2UZAvh8Yre
        /dNoLwPo7BZ8/SFIojgSCTs=
X-Google-Smtp-Source: APXvYqzTE+H408VupO91D8wV4QPH7oeH5wb749VlasrHjqp6Jfh7DA1tBWVa9i20GbITeiMa4nm8dA==
X-Received: by 2002:a17:90a:c20e:: with SMTP id e14mr11177928pjt.0.1563491184681;
        Thu, 18 Jul 2019 16:06:24 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id g62sm27651586pje.11.2019.07.18.16.06.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 18 Jul 2019 16:06:19 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 176CB403B8; Thu, 18 Jul 2019 23:06:19 +0000 (UTC)
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org,
        Alexander.Levin@microsoft.com
Cc:     stable@vger.kernel.org, amir73il@gmail.com, hch@infradead.org,
        zlang@redhat.com, Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 0/9] xfs: stable fixes for v4.19.y - circa ~ v4.19.58
Date:   Thu, 18 Jul 2019 23:06:08 +0000
Message-Id: <20190718230617.7439-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

"Oyez Oyez..." its time for a stable update of fixes for XFS. 4 out of the
9 fixes here were recommended by Amir, and tested by both Amir and Sasha.
I've found a few other fixes, and have tested all these changes with
fstests against the following configurations in fstests sections as per
oscheck [0] and found no regressions in comparsin to v4.19.58 and by
running the full set of tests 3 times completely:

  * xfs
  * xfs_nocrc
  * xfs_nocrc_512
  * xfs_reflink
  * xfs_reflink_1024
  * xfs_logdev
  * xfs_realtimedev

Known issues are listed on the expunges files, but its no different than
the current baseline.

Worth noting is a now known generic/388 crash on xfs_nocrc, xfs_reflink,
and what may be a new section we should consider to track:
"xfs_reflink_normapbt" with the following resulting filesystem:

# xfs_info /dev/loop5
meta-data=/dev/loop5             isize=512    agcount=4, agsize=1310720 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1
data     =                       bsize=4096   blocks=5242880, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

Do we want to create a baseline and track this configuration for stable
as well?

There is a stable bug tracking this, kz#204223 [1], and a respective bug
also present on upstream via kz#204049 [2] which Zorro reported. But,
again, nothing changes from the baseline.

I'd appreciate further reviews from the patches.

I have some other fixes in mind as well, but I'd rather not delay this
set and think this is a first good batch.

This also goes out as the first set of stable fixes using oscheck's
new devops infrastructure built on ansible / vagrant / terraform [3].
For this release I've used vagrant with KVM, perhaps the next one
I'll try terraform on whatever cloud solution someone is willing
to let me use.

You can also find these changes on my 20190718-linux-xfs-4.19.y-v1
branch on kernel.org [4].

Lemme know if you see any issues or have any questions.

[0] https://gitlab.com/mcgrof/oscheck/blob/master/fstests-configs/xfs.config
[1] https://bugzilla.kernel.org/show_bug.cgi?id=204223
[2] https://bugzilla.kernel.org/show_bug.cgi?id=204049
[3] https://gitlab.com/mcgrof/kdevops
[4] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux-stable.git/log/?h=20190718-linux-xfs-4.19.y-v1

Brian Foster (1):
  xfs: serialize unaligned dio writes against all other dio writes

Darrick J. Wong (6):
  xfs: fix pagecache truncation prior to reflink
  xfs: don't overflow xattr listent buffer
  xfs: rename m_inotbt_nores to m_finobt_nores
  xfs: don't ever put nlink > 0 inodes on the unlinked list
  xfs: reserve blocks for ifree transaction during log recovery
  xfs: abort unaligned nowait directio early

Dave Chinner (1):
  xfs: flush removing page cache in xfs_reflink_remap_prep

Luis R. Rodriguez (1):
  xfs: fix reporting supported extra file attributes for statx()

 fs/xfs/libxfs/xfs_ag_resv.c      |  2 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c |  4 ++--
 fs/xfs/xfs_attr_list.c           |  1 +
 fs/xfs/xfs_bmap_util.c           |  2 +-
 fs/xfs/xfs_bmap_util.h           |  2 ++
 fs/xfs/xfs_file.c                | 27 +++++++++++++++++----------
 fs/xfs/xfs_fsops.c               |  1 +
 fs/xfs/xfs_inode.c               | 18 +++++++-----------
 fs/xfs/xfs_iops.c                | 21 +++++++++++++++++++--
 fs/xfs/xfs_mount.h               |  2 +-
 fs/xfs/xfs_reflink.c             | 16 +++++++++++++---
 fs/xfs/xfs_super.c               |  7 +++++++
 fs/xfs/xfs_xattr.c               |  3 +++
 13 files changed, 75 insertions(+), 31 deletions(-)

-- 
2.20.1

