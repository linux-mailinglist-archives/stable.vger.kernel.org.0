Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D33FE3AF0B8
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbhFUQvv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:51:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:41348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233384AbhFUQtn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:49:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A6BD61360;
        Mon, 21 Jun 2021 16:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293281;
        bh=LMB/EuOgP2l7rt4+DH9omDRGMomrcHldCdGNDTix6ts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ry/1vWZIsGcxj0QMAmzWV49Jsd99CEH0dcYPC/mrSDlr0x03L1NEr5nvuJxe0NDtO
         pDWxL+/RQTUb4nyYU2mNEV4touw4W/ftEvB1YGFx2p8zcH1zXFfA+dmfeI4PtNIMcs
         DNl2DlY+Jo/krnEVyVHSTvmag7zuEUjXlhqYIHmU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Naohiro Aota <naohiro.aota@wdc.com>
Subject: [PATCH 5.12 132/178] btrfs: zoned: fix negative space_info->bytes_readonly
Date:   Mon, 21 Jun 2021 18:15:46 +0200
Message-Id: <20210621154927.276671375@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naohiro Aota <naohiro.aota@wdc.com>

commit f9f28e5bd0baee9708c9011897196f06ae3a2733 upstream.

Consider we have a using block group on zoned btrfs.

|<- ZU ->|<- used ->|<---free--->|
                     `- Alloc offset
ZU: Zone unusable

Marking the block group read-only will migrate the zone unusable bytes
to the read-only bytes. So, we will have this.

|<- RO ->|<- used ->|<--- RO --->|

RO: Read only

When marking it back to read-write, btrfs_dec_block_group_ro()
subtracts the above "RO" bytes from the
space_info->bytes_readonly. And, it moves the zone unusable bytes back
and again subtracts those bytes from the space_info->bytes_readonly,
leading to negative bytes_readonly.

This can be observed in the output as eg.:

  Data, single: total=512.00MiB, used=165.21MiB, zone_unusable=16.00EiB
  Data, single: total=536870912, used=173256704, zone_unusable=18446744073603186688

This commit fixes the issue by reordering the operations.

Link: https://github.com/naota/linux/issues/37
Reported-by: David Sterba <dsterba@suse.com>
Fixes: 169e0da91a21 ("btrfs: zoned: track unusable bytes for zones")
CC: stable@vger.kernel.org # 5.12+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-group.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2347,16 +2347,16 @@ void btrfs_dec_block_group_ro(struct btr
 	spin_lock(&sinfo->lock);
 	spin_lock(&cache->lock);
 	if (!--cache->ro) {
-		num_bytes = cache->length - cache->reserved -
-			    cache->pinned - cache->bytes_super -
-			    cache->zone_unusable - cache->used;
-		sinfo->bytes_readonly -= num_bytes;
 		if (btrfs_is_zoned(cache->fs_info)) {
 			/* Migrate zone_unusable bytes back */
 			cache->zone_unusable = cache->alloc_offset - cache->used;
 			sinfo->bytes_zone_unusable += cache->zone_unusable;
 			sinfo->bytes_readonly -= cache->zone_unusable;
 		}
+		num_bytes = cache->length - cache->reserved -
+			    cache->pinned - cache->bytes_super -
+			    cache->zone_unusable - cache->used;
+		sinfo->bytes_readonly -= num_bytes;
 		list_del_init(&cache->ro_list);
 	}
 	spin_unlock(&cache->lock);


