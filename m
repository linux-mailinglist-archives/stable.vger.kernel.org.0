Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2A03CAB34
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244771AbhGOTSM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:18:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244664AbhGOTQh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:16:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACA29613E6;
        Thu, 15 Jul 2021 19:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376365;
        bh=Q8tCaovNO/yY6nnNDbQcWGAtMidmnvcjFfhUOh6C8ys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y9vPZcSMC4eje52tJE1oXNsW5oO0VUYP08vZwkcYrT9q3AtpSS8VdTJYU402CY8+s
         NoZeq72k7iOiBYwO2Xpi47AyvUiMJOP9ZYBA3CcPw0v7EyojUzH8nBM/I8e2/YPBtd
         HGgr4DOToGK06q74hQxA0JawNYYYkSyfBmO6OwUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.13 239/266] dm zoned: check zone capacity
Date:   Thu, 15 Jul 2021 20:39:54 +0200
Message-Id: <20210715182650.898977679@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

commit bab68499428ed934f0493ac74197ed6f36204260 upstream.

The dm-zoned target cannot support zoned block devices with zones that
have a capacity smaller than the zone size (e.g. NVMe zoned namespaces)
due to the current chunk zone mapping implementation as it is assumed
that zones and chunks have the same size with all blocks usable.
If a zoned drive is found to have zones with a capacity different from
the zone size, fail the target initialization.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Cc: stable@vger.kernel.org # v5.9+
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-zoned-metadata.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -1390,6 +1390,13 @@ static int dmz_init_zone(struct blk_zone
 		return -ENXIO;
 	}
 
+	/*
+	 * Devices that have zones with a capacity smaller than the zone size
+	 * (e.g. NVMe zoned namespaces) are not supported.
+	 */
+	if (blkz->capacity != blkz->len)
+		return -ENXIO;
+
 	switch (blkz->type) {
 	case BLK_ZONE_TYPE_CONVENTIONAL:
 		set_bit(DMZ_RND, &zone->flags);


