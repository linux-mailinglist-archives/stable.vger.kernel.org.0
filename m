Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC49D24B843
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 13:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730760AbgHTKI5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:08:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:41952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730753AbgHTKIy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:08:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 328F62067C;
        Thu, 20 Aug 2020 10:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918133;
        bh=ViljuQSUBMMS87DdQO2cmP6a8sHOqnJUa5dXv1gAFO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RFHnc4Ybp3MriCXObnJM0Pb8528F6nDDHSPTS6ZETAFcMzV8ocgwDcZBZsQMKbhVa
         s9yYcoMPiFcyBurPTXBDxGJ9jKp4dIthzdsjpuFxR3g39aLt/3TPu+hNXSIvlXjV3b
         Jo2LoeUad5QKqdNn7tLNveMG+/mvC/pVTgSpW1aA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhao Heming <heming.zhao@suse.com>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 065/228] md-cluster: fix wild pointer of unlock_all_bitmaps()
Date:   Thu, 20 Aug 2020 11:20:40 +0200
Message-Id: <20200820091610.857681420@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
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
index 10057ac85476e..035d5ec8e677f 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -1423,6 +1423,7 @@ static void unlock_all_bitmaps(struct mddev *mddev)
 			}
 		}
 		kfree(cinfo->other_bitmap_lockres);
+		cinfo->other_bitmap_lockres = NULL;
 	}
 }
 
-- 
2.25.1



