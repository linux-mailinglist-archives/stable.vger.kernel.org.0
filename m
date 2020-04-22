Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D35A51B3D21
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729290AbgDVKMD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:12:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:44740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729286AbgDVKMC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:12:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A6782070B;
        Wed, 22 Apr 2020 10:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550322;
        bh=oo0YQqQ2h9LJQli6zfhSSJEsVYe6Lnd8Pdi+X7mDI9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P2IgJDVqXw27avO2cYhL49u3VJNnHadHBV/Yn/q5j0r9roGEHQmYA3WPkZ1MPawk2
         ZUZLi3ejC76dstCliNPyH6M2HK4RhnorXzQfbxZf3TDpp0Q3hOuSv1Xy0gm0Bwy+Nj
         NsljWffk0HzRmmtH4mIqSiw7XO/4P0iLv1WGhDKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Liu <bob.liu@oracle.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 097/199] dm zoned: remove duplicate nr_rnd_zones increase in dmz_init_zone()
Date:   Wed, 22 Apr 2020 11:57:03 +0200
Message-Id: <20200422095107.694755412@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095057.806111593@linuxfoundation.org>
References: <20200422095057.806111593@linuxfoundation.org>
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
index e3b67b145027b..4d658a0c60258 100644
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



