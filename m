Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E18AF2476D9
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729559AbgHQPXx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:23:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:52008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729557AbgHQPXp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:23:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68B4E233EA;
        Mon, 17 Aug 2020 15:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677825;
        bh=OXG6lde0xlK5QBw+e52bLhB7Zjqw0VD/6DAOhjeBn3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QhR/u0fd6y7f+fDSu1IdwWLeMHq2tAD7OhYiugTQnoie7mIdMvMLkpFWvEVP2t9xX
         c7As91EwbfTkSsHx2s9pVzi+GkHZoPqVY3Wu7odo8RR5m/QWuHbQ4DDyD881XqvWX2
         CvhrGoLBLoiRyU8NvagdvIqTqyL68xQgE6qKu8Dg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhao Heming <heming.zhao@suse.com>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 091/464] md-cluster: fix wild pointer of unlock_all_bitmaps()
Date:   Mon, 17 Aug 2020 17:10:44 +0200
Message-Id: <20200817143838.148739285@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhao Heming <heming.zhao@suse.com>

[ Upstream commit 60f80d6f2d07a6d8aee485a1d1252327eeee0c81 ]

reproduction steps:
```
node1 # mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sda
/dev/sdb
node2 # mdadm -A /dev/md0 /dev/sda /dev/sdb
node1 # mdadm -G /dev/md0 -b none
mdadm: failed to remove clustered bitmap.
node1 # mdadm -S --scan
^C  <==== mdadm hung & kernel crash
```

kernel stack:
```
[  335.230657] general protection fault: 0000 [#1] SMP NOPTI
[...]
[  335.230848] Call Trace:
[  335.230873]  ? unlock_all_bitmaps+0x5/0x70 [md_cluster]
[  335.230886]  unlock_all_bitmaps+0x3d/0x70 [md_cluster]
[  335.230899]  leave+0x10f/0x190 [md_cluster]
[  335.230932]  ? md_super_wait+0x93/0xa0 [md_mod]
[  335.230947]  ? leave+0x5/0x190 [md_cluster]
[  335.230973]  md_cluster_stop+0x1a/0x30 [md_mod]
[  335.230999]  md_bitmap_free+0x142/0x150 [md_mod]
[  335.231013]  ? _cond_resched+0x15/0x40
[  335.231025]  ? mutex_lock+0xe/0x30
[  335.231056]  __md_stop+0x1c/0xa0 [md_mod]
[  335.231083]  do_md_stop+0x160/0x580 [md_mod]
[  335.231119]  ? 0xffffffffc05fb078
[  335.231148]  md_ioctl+0xa04/0x1930 [md_mod]
[  335.231165]  ? filename_lookup+0xf2/0x190
[  335.231179]  blkdev_ioctl+0x93c/0xa10
[  335.231205]  ? _cond_resched+0x15/0x40
[  335.231214]  ? __check_object_size+0xd4/0x1a0
[  335.231224]  block_ioctl+0x39/0x40
[  335.231243]  do_vfs_ioctl+0xa0/0x680
[  335.231253]  ksys_ioctl+0x70/0x80
[  335.231261]  __x64_sys_ioctl+0x16/0x20
[  335.231271]  do_syscall_64+0x65/0x1f0
[  335.231278]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
```

Signed-off-by: Zhao Heming <heming.zhao@suse.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md-cluster.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 813a99ffa86f8..73fd50e779754 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -1518,6 +1518,7 @@ static void unlock_all_bitmaps(struct mddev *mddev)
 			}
 		}
 		kfree(cinfo->other_bitmap_lockres);
+		cinfo->other_bitmap_lockres = NULL;
 	}
 }
 
-- 
2.25.1



