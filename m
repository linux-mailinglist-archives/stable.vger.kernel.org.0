Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24B82286E2
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388334AbfEWTOC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:14:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:47974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388393AbfEWTOC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:14:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8DF620863;
        Thu, 23 May 2019 19:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558638841;
        bh=2ptE7vIvQyhsyXR24RemViMRC03B+p8ztYdpEcbI6Q8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xxbaxBP+RDej9ari1YbSODmxwpT/hYTrXHcmTIDqsImi2SlNVzGld8SdxbW8OAa3X
         liVN7nGpCVgLf+/B1iJ6SK7pGDcAZplLJwdpSAO9u92hKT+sXX42Lx66g5TG7Ftxn+
         x4+k1Q4/OVLExL3i8WDK84XHfYkZMIsKrMrI0AVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
        Shaun Tancheff <shaun@tancheff.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.14 54/77] dm zoned: Fix zone report handling
Date:   Thu, 23 May 2019 21:06:12 +0200
Message-Id: <20190523181727.481354761@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181719.982121681@linuxfoundation.org>
References: <20190523181719.982121681@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

commit 7aedf75ff740a98f3683439449cd91c8662d03b2 upstream.

The function blkdev_report_zones() returns success even if no zone
information is reported (empty report). Empty zone reports can only
happen if the report start sector passed exceeds the device capacity.
The conditions for this to happen are either a bug in the caller code,
or, a change in the device that forced the low level driver to change
the device capacity to a value that is lower than the report start
sector. This situation includes a failed disk revalidation resulting in
the disk capacity being changed to 0.

If this change happens while dm-zoned is in its initialization phase
executing dmz_init_zones(), this function may enter an infinite loop
and hang the system. To avoid this, add a check to disallow empty zone
reports and bail out early. Also fix the function dmz_update_zone() to
make sure that the report for the requested zone was correctly obtained.

Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Shaun Tancheff <shaun@tancheff.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-zoned-metadata.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -1169,6 +1169,9 @@ static int dmz_init_zones(struct dmz_met
 			goto out;
 		}
 
+		if (!nr_blkz)
+			break;
+
 		/* Process report */
 		for (i = 0; i < nr_blkz; i++) {
 			ret = dmz_init_zone(zmd, zone, &blkz[i]);
@@ -1204,6 +1207,8 @@ static int dmz_update_zone(struct dmz_me
 	/* Get zone information from disk */
 	ret = blkdev_report_zones(zmd->dev->bdev, dmz_start_sect(zmd, zone),
 				  &blkz, &nr_blkz, GFP_NOIO);
+	if (!nr_blkz)
+		ret = -EIO;
 	if (ret) {
 		dmz_dev_err(zmd->dev, "Get zone %u report failed",
 			    dmz_id(zmd, zone));


