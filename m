Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC7D51B6942
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729392AbgDWXVg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:21:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48498 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728186AbgDWXGc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:32 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvL-0004be-DS; Fri, 24 Apr 2020 00:06:27 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvK-00E6iV-0C; Fri, 24 Apr 2020 00:06:26 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David Sterba" <dsterba@suse.com>,
        "Johannes Thumshirn" <jthumshirn@suse.de>,
        "Nikolay Borisov" <nborisov@suse.com>, "Qu Wenruo" <wqu@suse.com>
Date:   Fri, 24 Apr 2020 00:04:42 +0100
Message-ID: <lsq.1587683028.968863929@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 055/245] btrfs: ensure that a DUP or RAID1 block
 group has exactly two stripes
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Thumshirn <jthumshirn@suse.de>

commit 349ae63f40638a28c6fce52e8447c2d14b84cc0c upstream.

We recently had a customer issue with a corrupted filesystem. When
trying to mount this image btrfs panicked with a division by zero in
calc_stripe_length().

The corrupt chunk had a 'num_stripes' value of 1. calc_stripe_length()
takes this value and divides it by the number of copies the RAID profile
is expected to have to calculate the amount of data stripes. As a DUP
profile is expected to have 2 copies this division resulted in 1/2 = 0.
Later then the 'data_stripes' variable is used as a divisor in the
stripe length calculation which results in a division by 0 and thus a
kernel panic.

When encountering a filesystem with a DUP block group and a
'num_stripes' value unequal to 2, refuse mounting as the image is
corrupted and will lead to unexpected behaviour.

Code inspection showed a RAID1 block group has the same issues.

Fixes: e06cd3dd7cea ("Btrfs: add validadtion checks for chunk loading")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/volumes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5884,10 +5884,10 @@ static int btrfs_check_chunk_valid(struc
 	}
 
 	if ((type & BTRFS_BLOCK_GROUP_RAID10 && sub_stripes != 2) ||
-	    (type & BTRFS_BLOCK_GROUP_RAID1 && num_stripes < 1) ||
+	    (type & BTRFS_BLOCK_GROUP_RAID1 && num_stripes != 2) ||
 	    (type & BTRFS_BLOCK_GROUP_RAID5 && num_stripes < 2) ||
 	    (type & BTRFS_BLOCK_GROUP_RAID6 && num_stripes < 3) ||
-	    (type & BTRFS_BLOCK_GROUP_DUP && num_stripes > 2) ||
+	    (type & BTRFS_BLOCK_GROUP_DUP && num_stripes != 2) ||
 	    ((type & BTRFS_BLOCK_GROUP_PROFILE_MASK) == 0 &&
 	     num_stripes != 1)) {
 		btrfs_err(root->fs_info,

