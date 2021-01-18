Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 999BE2F9E91
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 12:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390828AbhARLnc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 06:43:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:37770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390820AbhARLnT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:43:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03A48229CA;
        Mon, 18 Jan 2021 11:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970182;
        bh=pmkYNRIjRXRI4sPS1CgRUyOj5sGYkiqZOgAC2Bs6kwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QzbQ9evRRHlQDAaCjrTYoOLPRir0frvijIRTRKIo33UoiYvg/Bkmu+lPgHHZFl6PJ
         9pwkOkpRMeIsbeCGQW4FXplnBfA+IlhUEnbAU4HoM+nojDS1fjmjz69RGDpoVP2r3t
         vfz3gkFPf7Jwx3DnUL/LL9Mlq4TmmzUXczg3v1ME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zdenek Kabelac <zkabelac@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        =?UTF-8?q?Stephan=20B=C3=A4rwolf?= <stephan@matrixstorm.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.10 041/152] dm raid: fix discard limits for raid1
Date:   Mon, 18 Jan 2021 12:33:36 +0100
Message-Id: <20210118113354.753644638@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Snitzer <snitzer@redhat.com>

commit cc07d72bf350b77faeffee1c37bc52197171473f upstream.

Block core warned that discard_granularity was 0 for dm-raid with
personality of raid1.  Reason is that raid_io_hints() was incorrectly
special-casing raid1 rather than raid0.

Fix raid_io_hints() by removing discard limits settings for
raid1. Check for raid0 instead.

Fixes: 61697a6abd24a ("dm: eliminate 'split_discard_bios' flag from DM target interface")
Cc: stable@vger.kernel.org
Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Stephan Bärwolf <stephan@matrixstorm.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-raid.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3730,10 +3730,10 @@ static void raid_io_hints(struct dm_targ
 	blk_limits_io_opt(limits, chunk_size_bytes * mddev_data_stripes(rs));
 
 	/*
-	 * RAID1 and RAID10 personalities require bio splitting,
-	 * RAID0/4/5/6 don't and process large discard bios properly.
+	 * RAID0 and RAID10 personalities require bio splitting,
+	 * RAID1/4/5/6 don't and process large discard bios properly.
 	 */
-	if (rs_is_raid1(rs) || rs_is_raid10(rs)) {
+	if (rs_is_raid0(rs) || rs_is_raid10(rs)) {
 		limits->discard_granularity = chunk_size_bytes;
 		limits->max_discard_sectors = rs->md.chunk_sectors;
 	}


