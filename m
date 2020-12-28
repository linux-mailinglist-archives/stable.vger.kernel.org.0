Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE49F2E429A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407701AbgL1N6d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:58:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:60216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407614AbgL1N6Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:58:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5509720715;
        Mon, 28 Dec 2020 13:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163865;
        bh=gapKfBfc2IF1iGVN+5v/e8Y6wtEepDcVcgf7zdyZoFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NpYJLiu4ZTU2zkaK2fI1ZQW+SycIzDfKM7Izcs+O1WlC0pJLTCBdzThZ7awFtujCa
         kk+z2PCc1m3b1C3qN/R3YrF1EAgOWwwu29xCDu3CcjLAp7J8ImFA6ttcZg3M9Wbgrx
         W8+lxRDk6LkDdyYPXZQ87Fmly7BojKPEbdhhMzb4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhao Heming <heming.zhao@suse.com>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH 5.4 434/453] md/cluster: block reshape with remote resync job
Date:   Mon, 28 Dec 2020 13:51:10 +0100
Message-Id: <20201228124958.113543374@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhao Heming <heming.zhao@suse.com>

commit a8da01f79c89755fad55ed0ea96e8d2103242a72 upstream.

Reshape request should be blocked with ongoing resync job. In cluster
env, a node can start resync job even if the resync cmd isn't executed
on it, e.g., user executes "mdadm --grow" on node A, sometimes node B
will start resync job. However, current update_raid_disks() only check
local recovery status, which is incomplete. As a result, we see user will
execute "mdadm --grow" successfully on local, while the remote node deny
to do reshape job when it doing resync job. The inconsistent handling
cause array enter unexpected status. If user doesn't observe this issue
and continue executing mdadm cmd, the array doesn't work at last.

Fix this issue by blocking reshape request. When node executes "--grow"
and detects ongoing resync, it should stop and report error to user.

The following script reproduces the issue with ~100% probability.
(two nodes share 3 iSCSI luns: sdg/sdh/sdi. Each lun size is 1GB)
```
 # on node1, node2 is the remote node.
ssh root@node2 "mdadm -S --scan"
mdadm -S --scan
for i in {g,h,i};do dd if=/dev/zero of=/dev/sd$i oflag=direct bs=1M \
count=20; done

mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sdg /dev/sdh
ssh root@node2 "mdadm -A /dev/md0 /dev/sdg /dev/sdh"

sleep 5

mdadm --manage --add /dev/md0 /dev/sdi
mdadm --wait /dev/md0
mdadm --grow --raid-devices=3 /dev/md0

mdadm /dev/md0 --fail /dev/sdg
mdadm /dev/md0 --remove /dev/sdg
mdadm --grow --raid-devices=2 /dev/md0
```

Cc: stable@vger.kernel.org
Signed-off-by: Zhao Heming <heming.zhao@suse.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/md.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7052,6 +7052,7 @@ static int update_raid_disks(struct mdde
 		return -EINVAL;
 	if (mddev->sync_thread ||
 	    test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
+	    test_bit(MD_RESYNCING_REMOTE, &mddev->recovery) ||
 	    mddev->reshape_position != MaxSector)
 		return -EBUSY;
 
@@ -9423,8 +9424,11 @@ static void check_sb_changes(struct mdde
 		}
 	}
 
-	if (mddev->raid_disks != le32_to_cpu(sb->raid_disks))
-		update_raid_disks(mddev, le32_to_cpu(sb->raid_disks));
+	if (mddev->raid_disks != le32_to_cpu(sb->raid_disks)) {
+		ret = update_raid_disks(mddev, le32_to_cpu(sb->raid_disks));
+		if (ret)
+			pr_warn("md: updating array disks failed. %d\n", ret);
+	}
 
 	/*
 	 * Since mddev->delta_disks has already updated in update_raid_disks,


