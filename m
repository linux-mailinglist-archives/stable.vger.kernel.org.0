Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1AE9CA742
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405693AbfJCQwS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:52:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:39856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405685AbfJCQwR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:52:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64DD220867;
        Thu,  3 Oct 2019 16:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121536;
        bh=aF9CpfdxUg0KgzY0DPJtD5O3gsmdeYqLg5p8jigGk1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uNO8mt5xlPahzAQkr+ykEP148sznszzOcvLpyrobc8mTThZVHzSc9pa2Nn3NlH1OA
         0dwDLYqwFadjXqXKFa9A7fwpkFPHRo42GDaBTV7dCCge+LYQ+N5PaS0N/0bSMAYuxo
         SUYM4Mnv6xRYAVd7JoPklJaLS7DVSLwRdr+ClfwU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Murphy <lists@colorremedies.com>,
        Anand Jain <anand.jain@oracle.com>, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.3 316/344] btrfs: Fix a regression which we cant convert to SINGLE profile
Date:   Thu,  3 Oct 2019 17:54:41 +0200
Message-Id: <20191003154610.279347902@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit fab273595507a9ec7035df6d5512a955d80a80ba upstream.

[BUG]
With v5.3 kernel, we can't convert to SINGLE profile:

  # btrfs balance start -f -dconvert=single $mnt
  ERROR: error during balancing '/mnt/btrfs': Invalid argument
  # dmesg -t | tail
  validate_convert_profile: data profile=0x1000000000000 allowed=0x20 is_valid=1 final=0x1000000000000 ret=1
  BTRFS error (device dm-3): balance: invalid convert data profile single

[CAUSE]
With the extra debug output added, it shows that the @allowed bit is
lacking the special in-memory only SINGLE profile bit.

Thus we fail at that (profile & ~allowed) check.

This regression is caused by commit 081db89b13cb ("btrfs: use raid_attr
to get allowed profiles for balance conversion") and the fact that we
don't use any bit to indicate SINGLE profile on-disk, but uses special
in-memory only bit to help distinguish different profiles.

[FIX]
Add that BTRFS_AVAIL_ALLOC_BIT_SINGLE to @allowed, so the code should be
the same as it was and fix the regression.

Reported-by: Chris Murphy <lists@colorremedies.com>
Fixes: 081db89b13cb ("btrfs: use raid_attr to get allowed profiles for balance conversion")
CC: stable@vger.kernel.org # 5.3+
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/volumes.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4072,7 +4072,13 @@ int btrfs_balance(struct btrfs_fs_info *
 	}
 
 	num_devices = btrfs_num_devices(fs_info);
-	allowed = 0;
+
+	/*
+	 * SINGLE profile on-disk has no profile bit, but in-memory we have a
+	 * special bit for it, to make it easier to distinguish.  Thus we need
+	 * to set it manually, or balance would refuse the profile.
+	 */
+	allowed = BTRFS_AVAIL_ALLOC_BIT_SINGLE;
 	for (i = 0; i < ARRAY_SIZE(btrfs_raid_array); i++)
 		if (num_devices >= btrfs_raid_array[i].devs_min)
 			allowed |= btrfs_raid_array[i].bg_flag;


