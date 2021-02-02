Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC2E630C113
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 15:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234197AbhBBONE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 09:13:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:49708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234044AbhBBOMB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:12:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F53064FA8;
        Tue,  2 Feb 2021 13:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273913;
        bh=CMrb3hlGv1X8l+Hvg6BWb5nq1w28MXsGDNOYB3OKsXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Q+FIuSudnwpzM+qM7xWYLHwX2e12IHy9rXLYVaE9wZkRyWX9VLqC1Q10+n7IKSLN
         OQCf2WoE4wZ46a8u2ghV96u1jaYZJaKeHsSHdICtXRG/Jg3mIuqcpJo5nLFf/HuuPd
         RMBEgykKb6BRNne+ujIxKIDHjdcw3GWGpd0dniyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arthur Borsboom <arthurborsboom@gmail.com>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 4.14 14/30] xen-blkfront: allow discard-* nodes to be optional
Date:   Tue,  2 Feb 2021 14:38:55 +0100
Message-Id: <20210202132942.728340331@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132942.138623851@linuxfoundation.org>
References: <20210202132942.138623851@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roger Pau Monne <roger.pau@citrix.com>

commit 0549cd67b01016b579047bce045b386202a8bcfc upstream.

This is inline with the specification described in blkif.h:

 * discard-granularity: should be set to the physical block size if
   node is not present.
 * discard-alignment, discard-secure: should be set to 0 if node not
   present.

This was detected as QEMU would only create the discard-granularity
node but not discard-alignment, and thus the setup done in
blkfront_setup_discard would fail.

Fix blkfront_setup_discard to not fail on missing nodes, and also fix
blkif_set_queue_limits to set the discard granularity to the physical
block size if none is specified in xenbus.

Fixes: ed30bf317c5ce ('xen-blkfront: Handle discard requests.')
Reported-by: Arthur Borsboom <arthurborsboom@gmail.com>
Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Tested-By: Arthur Borsboom <arthurborsboom@gmail.com>
Link: https://lore.kernel.org/r/20210119105727.95173-1-roger.pau@citrix.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/xen-blkfront.c |   20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -937,7 +937,8 @@ static void blkif_set_queue_limits(struc
 	if (info->feature_discard) {
 		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, rq);
 		blk_queue_max_discard_sectors(rq, get_capacity(gd));
-		rq->limits.discard_granularity = info->discard_granularity;
+		rq->limits.discard_granularity = info->discard_granularity ?:
+						 info->physical_sector_size;
 		rq->limits.discard_alignment = info->discard_alignment;
 		if (info->feature_secdiscard)
 			queue_flag_set_unlocked(QUEUE_FLAG_SECERASE, rq);
@@ -2155,19 +2156,12 @@ static void blkfront_closing(struct blkf
 
 static void blkfront_setup_discard(struct blkfront_info *info)
 {
-	int err;
-	unsigned int discard_granularity;
-	unsigned int discard_alignment;
-
 	info->feature_discard = 1;
-	err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
-		"discard-granularity", "%u", &discard_granularity,
-		"discard-alignment", "%u", &discard_alignment,
-		NULL);
-	if (!err) {
-		info->discard_granularity = discard_granularity;
-		info->discard_alignment = discard_alignment;
-	}
+	info->discard_granularity = xenbus_read_unsigned(info->xbdev->otherend,
+							 "discard-granularity",
+							 0);
+	info->discard_alignment = xenbus_read_unsigned(info->xbdev->otherend,
+						       "discard-alignment", 0);
 	info->feature_secdiscard =
 		!!xenbus_read_unsigned(info->xbdev->otherend, "discard-secure",
 				       0);


