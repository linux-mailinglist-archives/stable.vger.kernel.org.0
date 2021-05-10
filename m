Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 517F837875B
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237475AbhEJLPN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:15:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:45870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236317AbhEJLHv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:07:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D9F861964;
        Mon, 10 May 2021 10:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644390;
        bh=oNEkuB1crDCj52S8PqF3My2ygtpN99A3+nwuI+eQwro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FOuitlWvl+qViPQi6NXQjNuqTPTYIox08HbUncBIKM8K1TOYEGlHs2Hab0qXdrZSi
         SInW3TZp+Fh8RG+Dv02qGcFGTKylTwiIh41uvHphCP9Pda3Ez1PIE/yaGaYqMkKVOe
         bfsCimNkaLI+GQsIp1IkwqxhY81BDuoe2mcrtrgw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.12 063/384] btrfs: zoned: fail mount if the device does not support zone append
Date:   Mon, 10 May 2021 12:17:32 +0200
Message-Id: <20210510102016.964787694@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

commit 1d68128c107a0b8c0c9125cb05d4771ddc438369 upstream.

For zoned btrfs, zone append is mandatory to write to a sequential write
only zone, otherwise parallel writes to the same zone could result in
unaligned write errors.

If a zoned block device does not support zone append (e.g. a dm-crypt
zoned device using a non-NULL IV cypher), fail to mount.

CC: stable@vger.kernel.org # 5.12
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/zoned.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -342,6 +342,13 @@ int btrfs_get_dev_zone_info(struct btrfs
 	if (!IS_ALIGNED(nr_sectors, zone_sectors))
 		zone_info->nr_zones++;
 
+	if (bdev_is_zoned(bdev) && zone_info->max_zone_append_size == 0) {
+		btrfs_err(fs_info, "zoned: device %pg does not support zone append",
+			  bdev);
+		ret = -EINVAL;
+		goto out;
+	}
+
 	zone_info->seq_zones = bitmap_zalloc(zone_info->nr_zones, GFP_KERNEL);
 	if (!zone_info->seq_zones) {
 		ret = -ENOMEM;


