Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 082221AC2AC
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896383AbgDPNbL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:31:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:41442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896350AbgDPNbG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:31:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED32E217D8;
        Thu, 16 Apr 2020 13:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587043866;
        bh=q6vOwUl1sXL/FGDjN4Jr98kzcb7jhnz4R1KTPTxdtq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qTkJ3wyOqScN96hRpiuzOevR3W4lv2IKWHOFxLRLV+jyXRw1r1VacyCaD9K1R7Jdt
         wixG4JZ3YQl8dKocgm6ooZc8LpmreZnGEqK6VVXpA2kSD6zvqEFQ3WiOrsKXxdd8pI
         dDa1+3XXFiZm/dtF2l8y3fZLRaEXUDUMJFbLo3+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Liu <bob.liu@oracle.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 133/146] dm zoned: remove duplicate nr_rnd_zones increase in dmz_init_zone()
Date:   Thu, 16 Apr 2020 15:24:34 +0200
Message-Id: <20200416131300.638366312@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131242.353444678@linuxfoundation.org>
References: <20200416131242.353444678@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Liu <bob.liu@oracle.com>

[ Upstream commit b8fdd090376a7a46d17db316638fe54b965c2fb0 ]

zmd->nr_rnd_zones was increased twice by mistake. The other place it
is increased in dmz_init_zone() is the only one needed:

1131                 zmd->nr_useable_zones++;
1132                 if (dmz_is_rnd(zone)) {
1133                         zmd->nr_rnd_zones++;
					^^^
Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target")
Cc: stable@vger.kernel.org
Signed-off-by: Bob Liu <bob.liu@oracle.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-zoned-metadata.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index 086a870087cff..53eb21343b11f 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -1105,7 +1105,6 @@ static int dmz_init_zone(struct dmz_metadata *zmd, struct dm_zone *zone,
 
 	if (blkz->type == BLK_ZONE_TYPE_CONVENTIONAL) {
 		set_bit(DMZ_RND, &zone->flags);
-		zmd->nr_rnd_zones++;
 	} else if (blkz->type == BLK_ZONE_TYPE_SEQWRITE_REQ ||
 		   blkz->type == BLK_ZONE_TYPE_SEQWRITE_PREF) {
 		set_bit(DMZ_SEQ, &zone->flags);
-- 
2.20.1



