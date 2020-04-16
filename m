Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E71461AC3F1
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408779AbgDPNvz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:51:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:38070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408772AbgDPNvw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:51:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77537221F7;
        Thu, 16 Apr 2020 13:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045111;
        bh=JQdnDdhYv6d4tDD+A98SpEPRKFhhAozHc0eClzQz76w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0+Tx1t1Mvdd+BCeuTf8tjgnE7ujSfF89hQbypw406ZaCBx1DMI7t7e3SS4SN8+70C
         qgGAld7PN4l7YDEMpgKFywNowrvKQY+Q5bRzU/lHO7JMw2HFsVWqqdpzHDM8tZ2ahZ
         +0l2Mg+YKbUW/frcQmWA8jBWqdjxQlSezOzcQmXQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikos Tsironis <ntsironis@arrikto.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 221/232] dm clone: Add missing casts to prevent overflows and data corruption
Date:   Thu, 16 Apr 2020 15:25:15 +0200
Message-Id: <20200416131343.129739576@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikos Tsironis <ntsironis@arrikto.com>

[ Upstream commit 9fc06ff56845cc5ccafec52f545fc2e08d22f849 ]

Add missing casts when converting from regions to sectors.

In case BITS_PER_LONG == 32, the lack of the appropriate casts can lead
to overflows and miscalculation of the device sector.

As a result, we could end up discarding and/or copying the wrong parts
of the device, thus corrupting the device's data.

Fixes: 7431b7835f55 ("dm: add clone target")
Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-clone-target.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-clone-target.c b/drivers/md/dm-clone-target.c
index 315d3bca59792..eb7a5d3ba81a2 100644
--- a/drivers/md/dm-clone-target.c
+++ b/drivers/md/dm-clone-target.c
@@ -282,7 +282,7 @@ static bool bio_triggers_commit(struct clone *clone, struct bio *bio)
 /* Get the address of the region in sectors */
 static inline sector_t region_to_sector(struct clone *clone, unsigned long region_nr)
 {
-	return (region_nr << clone->region_shift);
+	return ((sector_t)region_nr << clone->region_shift);
 }
 
 /* Get the region number of the bio */
@@ -471,7 +471,7 @@ static void complete_discard_bio(struct clone *clone, struct bio *bio, bool succ
 	if (test_bit(DM_CLONE_DISCARD_PASSDOWN, &clone->flags) && success) {
 		remap_to_dest(clone, bio);
 		bio_region_range(clone, bio, &rs, &nr_regions);
-		trim_bio(bio, rs << clone->region_shift,
+		trim_bio(bio, region_to_sector(clone, rs),
 			 nr_regions << clone->region_shift);
 		generic_make_request(bio);
 	} else
@@ -798,11 +798,14 @@ static void hydration_copy(struct dm_clone_region_hydration *hd, unsigned int nr
 	struct dm_io_region from, to;
 	struct clone *clone = hd->clone;
 
+	if (WARN_ON(!nr_regions))
+		return;
+
 	region_size = clone->region_size;
 	region_start = hd->region_nr;
 	region_end = region_start + nr_regions - 1;
 
-	total_size = (nr_regions - 1) << clone->region_shift;
+	total_size = region_to_sector(clone, nr_regions - 1);
 
 	if (region_end == clone->nr_regions - 1) {
 		/*
-- 
2.20.1



