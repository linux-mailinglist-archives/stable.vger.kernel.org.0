Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 096AB20EC4C
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 06:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725440AbgF3EAt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 00:00:49 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:61199 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgF3EAt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 00:00:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593489649; x=1625025649;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xIgovHvh0nO1UGa2xRPs+juS/+Rs3ulULKMqNlBDubg=;
  b=rrGHSpH6H048dIcvVUchtgBJAlg/IJl7P4Jt587BldBN38FirmX5c1Ch
   AA7sFMJ0sLHFplxlFxmmBLQxSqN0J+xTCtgVK09TR3t8om/tu88r2A9Jl
   FO28cHVs7IpZermNs51J/dQRYInnN6D2lkey4VfbPlRd7JojOWqMRv33+
   O0/sEGgeKMOwsabq48CgmqC1KN4AtirHa+p+78/9C9XRiWCy1Re1MFZ5k
   I73TbyEuTyWfhzeGEM6I3ObVw0mL8ROXY+wNZRHEQN3u5eDqaRP2jHU1q
   /ZOA4Jee8arstiGwxyojVyNQbD7gSN2Ik9lYCM4ygIL2lqfS8l+OEidMU
   g==;
IronPort-SDR: Pbhwh+OxORTMTam8etdCkqi37AeSKrxN1rCXq3wK0iu/MpmY4jV54jz9hA67eAKUSpHztxZLmW
 ykBwWLKH+NhdKHExll60xfwIWZjlo9mVKHgMLcCDv5EXfA7hpu8KfJSS6lO7muVkWmCBR7tOO4
 BtS/NxGIXxsBctAmsEjWxwtOulhn/incgWYa5/8XKmpNvPKTYwXjupvDbEZ7qQi/Zfm+Rjn/Xs
 4lfzlB5bE2CDPWEo65mmYxStZcS+IgtImH2o9pvZq3pxDnahXozM6sC2F4yP4W9RUWvr78M0SO
 VAs=
X-IronPort-AV: E=Sophos;i="5.75,296,1589212800"; 
   d="scan'208";a="141450716"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 30 Jun 2020 12:00:49 +0800
IronPort-SDR: SmenhHApucuLXjbpDsct8866YW2CHX+xyoWLXP/pgY0j4j8kK+gXmrK93vDyeeTlwgD3PIT23T
 7V96bCfrD0aMkwqO1ptad0cUBFKeiEI9Q=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 20:49:07 -0700
IronPort-SDR: 0BciZAhnjXMJk2WTwBwEa55bIH/baJbCuQ/dIBeVs2lhgXpCPN+NNN1iaRTaY93Caw0AY0jgau
 SpoHPTsoCUVg==
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 29 Jun 2020 21:00:48 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm zoned: assign max_io_len correctly
Date:   Tue, 30 Jun 2020 13:00:47 +0900
Message-Id: <20200630040047.231197-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Tao <houtao1@huawei.com>

commit 7b2377486767503d47265e4d487a63c651f6b55d upstream.

The unit of max_io_len is sector instead of byte (spotted through
code review), so fix it.

Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target")
Cc: stable@vger.kernel.org
Signed-off-by: Hou Tao <houtao1@huawei.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-zoned-target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
index f4f83d39b3dc..29881fea6acb 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -790,7 +790,7 @@ static int dmz_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	}
 
 	/* Set target (no write same support) */
-	ti->max_io_len = dev->zone_nr_sectors << 9;
+	ti->max_io_len = dev->zone_nr_sectors;
 	ti->num_flush_bios = 1;
 	ti->num_discard_bios = 1;
 	ti->num_write_zeroes_bios = 1;
-- 
2.26.2

