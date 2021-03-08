Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69A94330E7F
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbhCHMhb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:37:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:46878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232254AbhCHMg5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:36:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E41906521D;
        Mon,  8 Mar 2021 12:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615207016;
        bh=XBRRhxRCWP+YhBdSuGNquAEuhJ6J1cPFApMNHGJMqXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sFfInQw1ZyZMUQbk6c6e82+nDD8eARbNB6lPhT8RmlYRYXtHdU70Y6VCv+89bAVGl
         7usLVhuxDxeo6i910/A96Mf60vHZatIUBTAo9RhSJNRgnfy1NsS5N7WlSO3pNzGHxQ
         wH/ME+ugu+Fpdc3TbkMU0Q0H3JlTvE42BsuIQWao=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 42/44] btrfs: zoned: use sector_t for zone sectors
Date:   Mon,  8 Mar 2021 13:35:20 +0100
Message-Id: <20210308122720.605041919@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122718.586629218@linuxfoundation.org>
References: <20210308122718.586629218@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Naohiro Aota <naohiro.aota@wdc.com>

[ Upstream commit d734492a14a2da6e7bcce8cf66436a9cf4e51ddf ]

We need to use sector_t for zone_sectors, or it would set the zone size
to zero when the size >= 4GB (= 2^24 sectors) by shifting the
zone_sectors value by SECTOR_SHIFT. We're assuming zones sizes up to
8GiB.

Fixes: 5b316468983d ("btrfs: get zone information of zoned block devices")
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/zoned.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index c38846659019..2f80de440359 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -152,7 +152,7 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device)
 	sector_t sector = 0;
 	struct blk_zone *zones = NULL;
 	unsigned int i, nreported = 0, nr_zones;
-	unsigned int zone_sectors;
+	sector_t zone_sectors;
 	int ret;
 
 	if (!bdev_is_zoned(bdev))
@@ -485,7 +485,7 @@ int btrfs_sb_log_location_bdev(struct block_device *bdev, int mirror, int rw,
 			       u64 *bytenr_ret)
 {
 	struct blk_zone zones[BTRFS_NR_SB_LOG_ZONES];
-	unsigned int zone_sectors;
+	sector_t zone_sectors;
 	u32 sb_zone;
 	int ret;
 	u64 zone_size;
-- 
2.30.1



