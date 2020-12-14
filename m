Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64AE02D9D32
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 18:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502028AbgLNRGF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 12:06:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:56048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502024AbgLNRF6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:05:58 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Jones <davej@codemonkey.org.uk>,
        Mike Snitzer <snitzer@redhat.com>,
        Zdenek Kabelac <zkabelac@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.10 2/2] Revert "dm raid: fix discard limits for raid1 and raid10"
Date:   Mon, 14 Dec 2020 18:06:11 +0100
Message-Id: <20201214170452.896511308@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214170452.563016590@linuxfoundation.org>
References: <20201214170452.563016590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit e0910c8e4f87bb9f767e61a778b0d9271c4dc512.

It causes problems :(

Reported-by: Dave Jones <davej@codemonkey.org.uk>
Reported-by: Mike Snitzer <snitzer@redhat.com>
Cc: Zdenek Kabelac <zkabelac@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-raid.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3730,14 +3730,12 @@ static void raid_io_hints(struct dm_targ
 	blk_limits_io_opt(limits, chunk_size_bytes * mddev_data_stripes(rs));
 
 	/*
-	 * RAID10 personality requires bio splitting,
-	 * RAID0/1/4/5/6 don't and process large discard bios properly.
+	 * RAID1 and RAID10 personalities require bio splitting,
+	 * RAID0/4/5/6 don't and process large discard bios properly.
 	 */
-	if (rs_is_raid10(rs)) {
-		limits->discard_granularity = max(chunk_size_bytes,
-						  limits->discard_granularity);
-		limits->max_discard_sectors = min_not_zero(rs->md.chunk_sectors,
-							   limits->max_discard_sectors);
+	if (rs_is_raid1(rs) || rs_is_raid10(rs)) {
+		limits->discard_granularity = chunk_size_bytes;
+		limits->max_discard_sectors = rs->md.chunk_sectors;
 	}
 }
 


