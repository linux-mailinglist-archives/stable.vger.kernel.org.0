Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 871BB3CA7F5
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241347AbhGOS5Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:57:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:33630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242086AbhGOS4s (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:56:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF754613D7;
        Thu, 15 Jul 2021 18:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375235;
        bh=Q8tCaovNO/yY6nnNDbQcWGAtMidmnvcjFfhUOh6C8ys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LQhzO0H9yl/utouMa5xnjXMSKaAnG+l/QeaGaXoEqCs2fJNGdeyD41XnbdiG1lnU2
         GxcGEjCkp1bKcRuKKs8EPX/foiJeCcbNh9171Oep7AABaSucAhQGI50xRqWwk0Mpq8
         nk5FQYSOZtPn6nzEr1zGuWHgMRREddfdERtm0ziE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.10 195/215] dm zoned: check zone capacity
Date:   Thu, 15 Jul 2021 20:39:27 +0200
Message-Id: <20210715182633.618817941@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
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


