Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD54724A74B
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 21:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbgHST5C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 15:57:02 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:22860 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726435AbgHST5B (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 15:57:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597867019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=JDGvX0s3CfGuroZ3WjQYFXy/cRxyJCVnz+Pf0p7uSV8=;
        b=X814kFKuMN/Z0/kGf6MCndWN5lwbbTPHI2MpZR9bbDVq+H7MNjVrBjG/WGaYni+He9REL6
        jvgc+cZVmF7UsFDjwGJx29AupLz1iInno4cbnEq9azF5uS8X5BKtkwcCuUSquG3cQWK0bj
        7gUyLcD5GRRu4asl9rri90NfvTI2h8s=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-I2fBgEa9O2CpmQl3CLnDlg-1; Wed, 19 Aug 2020 15:56:58 -0400
X-MC-Unique: I2fBgEa9O2CpmQl3CLnDlg-1
Received: by mail-pg1-f199.google.com with SMTP id k32so14799978pgm.15
        for <stable@vger.kernel.org>; Wed, 19 Aug 2020 12:56:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=JDGvX0s3CfGuroZ3WjQYFXy/cRxyJCVnz+Pf0p7uSV8=;
        b=c2PPLF0Kz5/acCLmxeZk6KvwecqXj1dI9p7t0fj37NI+zSqkQr9zm1LB2wm7xZnes6
         hSq0yyE+kU28pmYtuDYvNfk1vWxLpHQiYyowJYoR4qfbwOEDRWZz+86BCxNgURQUGW9e
         VRQBXqUdijTgDj8L830hRGJwWXIRP+wYmSIsHw5zLHjFqqJkfIRP0ZN46isW53grCKi7
         8L210ivIOdofB0gNR22ohB6G8xorb6GW0psoItJFWaUa41EqhUnJitjE85swUo4FT/ps
         XdFbdUnr1R2qko2qrOEbMe+K8QB/n61/7p3k0zt7KbUs9IxyKy3LbYT8r2fTbODnQsjf
         du3w==
X-Gm-Message-State: AOAM533cYVHAbx2VS3PYkHATCsG2F96JulFAtTlHf18Zof2oUxiNzVHd
        eWjut+u8PTdCTnvdvhtfh2Pb1zRVhJ+MBdLdBa79yy/b0jBngL+zVRNfjCSKFbw21rOGz887Z+F
        fVV+Fy9gDDYJv84OE
X-Received: by 2002:a63:7d3:: with SMTP id 202mr32011pgh.230.1597867017032;
        Wed, 19 Aug 2020 12:56:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz+3Pl230CH6ILGZIOeiNaXL82ndPKRgPsgS1lrqvcaMUejchfEYQFco8vhnakaJtiE2tTzPw==
X-Received: by 2002:a63:7d3:: with SMTP id 202mr31995pgh.230.1597867016665;
        Wed, 19 Aug 2020 12:56:56 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i39sm3906880pje.8.2020.08.19.12.56.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 12:56:56 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Rafael Aquini <aquini@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Eric Sandeen <esandeen@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        stable <stable@vger.kernel.org>
Subject: [PATCH] mm, THP, swap: fix allocating cluster for swapfile by mistake
Date:   Thu, 20 Aug 2020 03:56:13 +0800
Message-Id: <20200819195613.24269-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SWP_FS doesn't mean the device is file-backed swap device,
which just means each writeback request should go through fs
by DIO. Or it'll just use extents added by .swap_activate(),
but it also works as file-backed swap device.

So in order to achieve the goal of the original patch,
SWP_BLKDEV should be used instead.

FS corruption can be observed with SSD device + XFS +
fragmented swapfile due to CONFIG_THP_SWAP=y.

Fixes: f0eea189e8e9 ("mm, THP, swap: Don't allocate huge cluster for file backed swap device")
Fixes: 38d8b4e6bdc8 ("mm, THP, swap: delay splitting THP during swap out")
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---

I reproduced the issue with the following details:

Environment:
QEMU + upstream kernel + buildroot + NVMe (2 GB)

Kernel config:
CONFIG_BLK_DEV_NVME=y
CONFIG_THP_SWAP=y

Some reproducable steps:
mkfs.xfs -f /dev/nvme0n1
mkdir /tmp/mnt
mount /dev/nvme0n1 /tmp/mnt
bs="32k"
sz="1024m"    # doesn't matter too much, I also tried 16m
xfs_io -f -c "pwrite -R -b $bs 0 $sz" -c "fdatasync" /tmp/mnt/sw
xfs_io -f -c "pwrite -R -b $bs 0 $sz" -c "fdatasync" /tmp/mnt/sw
xfs_io -f -c "pwrite -R -b $bs 0 $sz" -c "fdatasync" /tmp/mnt/sw
xfs_io -f -c "pwrite -F -S 0 -b $bs 0 $sz" -c "fdatasync" /tmp/mnt/sw
xfs_io -f -c "pwrite -R -b $bs 0 $sz" -c "fsync" /tmp/mnt/sw

mkswap /tmp/mnt/sw
swapon /tmp/mnt/sw

stress --vm 2 --vm-bytes 600M   # doesn't matter too much as well

Symptoms:
 - FS corruption (e.g. checksum failure)
 - memory corruption at: 0xd2808010
 - segfault
 ... 

 mm/swapfile.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 6c26916e95fd..2937daf3ca02 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1074,7 +1074,7 @@ int get_swap_pages(int n_goal, swp_entry_t swp_entries[], int entry_size)
 			goto nextsi;
 		}
 		if (size == SWAPFILE_CLUSTER) {
-			if (!(si->flags & SWP_FS))
+			if (si->flags & SWP_BLKDEV)
 				n_ret = swap_alloc_cluster(si, swp_entries);
 		} else
 			n_ret = scan_swap_map_slots(si, SWAP_HAS_CACHE,
-- 
2.18.1

