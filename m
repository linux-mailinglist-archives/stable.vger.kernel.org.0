Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE1C2F9E65
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 12:39:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390479AbhARLif (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 06:38:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:33366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390459AbhARLiZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:38:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95FFD22571;
        Mon, 18 Jan 2021 11:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969864;
        bh=fDcmRewYY45QhZR1SsyvSl3BaLmXgP5QHjio6wrtFbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RRS8FG/7IYXRuA2+g6FXPeJ9MNcLm5erbHDYSbgBv3hP28f8r6BLWWoWsZ2shKvI9
         8Gxg50yhOFqlxkAEk60SUvDRRH10MoAgfhD+h3fucI4YWkn+csPsGumQMw9uMhR15r
         l9UHoMfYGWDOac7zpectwP48G+GhEX3+yGlWQ4F8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zdenek Kabelac <zkabelac@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        =?UTF-8?q?Stephan=20B=C3=A4rwolf?= <stephan@matrixstorm.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.4 14/76] dm raid: fix discard limits for raid1
Date:   Mon, 18 Jan 2021 12:34:14 +0100
Message-Id: <20210118113341.672098414@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113340.984217512@linuxfoundation.org>
References: <20210118113340.984217512@linuxfoundation.org>
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
@@ -3744,10 +3744,10 @@ static void raid_io_hints(struct dm_targ
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


