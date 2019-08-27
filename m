Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16FC69DFE9
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 09:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730403AbfH0H6j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:58:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:51548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730990AbfH0H6i (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:58:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 250CB20828;
        Tue, 27 Aug 2019 07:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892717;
        bh=9139bLgvZNJhVU+/KuehRZ88uo1vuy8PX04vIiAa+M4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=furoQnrJqtEGfAVj39TRqa82AQi2nndI6rVE2qRIv+C0fT1pHzQ93HPCBSJe80+Vi
         k+Og+w36gsqsQ55BPZ6wQWpgbHjl/u1T+AFxvdC5IrDD4mUhWhn1lImjXsqCjgvzmC
         bkDcDwh2kWGlB56QYMNIB092dqznbjdrSN04wZd4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, benjamin.moody@gmail.com,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 4.19 88/98] xfs: fix missing ILOCK unlock when xfs_setattr_nonsize fails due to EDQUOT
Date:   Tue, 27 Aug 2019 09:51:07 +0200
Message-Id: <20190827072722.653604904@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072718.142728620@linuxfoundation.org>
References: <20190827072718.142728620@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

commit 1fb254aa983bf190cfd685d40c64a480a9bafaee upstream.

Benjamin Moody reported to Debian that XFS partially wedges when a chgrp
fails on account of being out of disk quota.  I ran his reproducer
script:

# adduser dummy
# adduser dummy plugdev

# dd if=/dev/zero bs=1M count=100 of=test.img
# mkfs.xfs test.img
# mount -t xfs -o gquota test.img /mnt
# mkdir -p /mnt/dummy
# chown -c dummy /mnt/dummy
# xfs_quota -xc 'limit -g bsoft=100k bhard=100k plugdev' /mnt

(and then as user dummy)

$ dd if=/dev/urandom bs=1M count=50 of=/mnt/dummy/foo
$ chgrp plugdev /mnt/dummy/foo

and saw:

================================================
WARNING: lock held when returning to user space!
5.3.0-rc5 #rc5 Tainted: G        W
------------------------------------------------
chgrp/47006 is leaving the kernel with locks still held!
1 lock held by chgrp/47006:
 #0: 000000006664ea2d (&xfs_nondir_ilock_class){++++}, at: xfs_ilock+0xd2/0x290 [xfs]

...which is clearly caused by xfs_setattr_nonsize failing to unlock the
ILOCK after the xfs_qm_vop_chown_reserve call fails.  Add the missing
unlock.

Reported-by: benjamin.moody@gmail.com
Fixes: 253f4911f297 ("xfs: better xfs_trans_alloc interface")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Tested-by: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/xfs/xfs_iops.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -803,6 +803,7 @@ xfs_setattr_nonsize(
 
 out_cancel:
 	xfs_trans_cancel(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 out_dqrele:
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);


