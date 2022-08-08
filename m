Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA6158C188
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 04:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242577AbiHHCYp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 22:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231852AbiHHCYc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 22:24:32 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DEBF1180D;
        Sun,  7 Aug 2022 19:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1659924149; x=1691460149;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4iRH2Heg/YztVNHuPLG+Pi5cN1PMuYAJr1dtblZ5aQE=;
  b=Gi48c5uxcBUeqhVpSVDlnPb8IPojweKkTk81KPUHSoKTM1ru0XorPnNL
   FUr7l5OPSZPbv5621PsHRHbF7/wRhstvmBzXt0ME5TliFavums8DPdVwv
   H7t6WTtAlGzsBiIShzuXdx+KypZFEKtDrQeSc8rnaoC/k6Y2lTAkY2SKk
   emUeFFcSiwMEpWeHCKVeH1mIIX8RJfTAn7fQr6+KJfuOVOKy7DPb9o6je
   DSZhU853H9HUSHerW9K9miS99G32uu3iY+N8CZDZ5Snz8nxm/ZK7qO/2R
   WK9D21MK9LGPI+ODvy4O3XEkuCgTUESV0kzgwbKBU8KhOlnqkh3tAwjMO
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,221,1654531200"; 
   d="scan'208";a="320182415"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Aug 2022 10:02:29 +0800
IronPort-SDR: tten+aKbwb0AOlaSSngNNJivrEvC1uoFMKCsmEYk57MUl43YsSPx+jYKkOfFEFAqIh7z/fmrkn
 h7zbct9z/gCFptZxdSzQ6zDuQmyFw3LhNkS1veDoR7tDUqoMin2DKZNWQ0f6UyD1pRtNPPl9Fq
 FMKu16GY/TF8f3aLxbmF5lRtFX8IQ5ypEVX0pqIknJxesb24m/z+7hI30Ygyjz1UYSYWkQxHE6
 Aj1Qb943cg8P1QkXTwToECPd0VC/WRDrT2fbgHmkwcXgU1qvexBZ/SibPEnp1ILR9bHPVYU6B9
 VMF1zKcx4sobuVKxqk4lJPIq
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Aug 2022 18:18:10 -0700
IronPort-SDR: dzSYYrgIwI4FConoGw3KqQutevGoEBmGDojm/pWs16tzUvkBo4wJymvJhGobkX1zttH+Sc+brj
 0I7xqUuK5uBWqyyv9HkNgxJCfdCFMmOMRS9OI0RtBD3X0r2k9MdrYvgauZleSpB3XbtlVnVmBX
 bMCpwHlSG9qr/He4rROvIe6Q63XG6NifkbmTR/yvXrodD/1F51az8poU7gYDZGCER/1kT6TsgE
 sz6tnwj4S26x2Cy3uqNW8KFalQ71NdWqfNvDhUNqMyonhI5xq4P4//59rn4e28TNjAZYXpw0Bm
 mBo=
WDCIronportException: Internal
Received: from ctl002.ad.shared (HELO naota-xeon.wdc.com) ([10.225.53.129])
  by uls-op-cesaip02.wdc.com with ESMTP; 07 Aug 2022 19:02:29 -0700
From:   Naohiro Aota <naohiro.aota@wdc.com>
To:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Cc:     Naohiro Aota <naohiro.aota@wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH STABLE 5.18 v2 2/3] btrfs: zoned: fix critical section of relocation inode writeback
Date:   Mon,  8 Aug 2022 11:02:00 +0900
Message-Id: <20220808020201.712924-3-naohiro.aota@wdc.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808020201.712924-1-naohiro.aota@wdc.com>
References: <20220808020201.712924-1-naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 19ab78ca86981e0e1e73036fb73a508731a7c078 upstream

We use btrfs_zoned_data_reloc_{lock,unlock} to allow only one process to
write out to the relocation inode. That critical section must include all
the IO submission for the inode. However, flush_write_bio() in
extent_writepages() is out of the critical section, causing an IO
submission outside of the lock. This leads to an out of the order IO
submission and fail the relocation process.

Fix it by extending the critical section.

Fixes: 35156d852762 ("btrfs: zoned: only allow one process to add pages to a relocation inode")
CC: stable@vger.kernel.org # 5.16+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a23a42ba88ca..68ddd90685d9 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5214,13 +5214,14 @@ int extent_writepages(struct address_space *mapping,
 	 */
 	btrfs_zoned_data_reloc_lock(BTRFS_I(inode));
 	ret = extent_write_cache_pages(mapping, wbc, &epd);
-	btrfs_zoned_data_reloc_unlock(BTRFS_I(inode));
 	ASSERT(ret <= 0);
 	if (ret < 0) {
+		btrfs_zoned_data_reloc_unlock(BTRFS_I(inode));
 		end_write_bio(&epd, ret);
 		return ret;
 	}
 	ret = flush_write_bio(&epd);
+	btrfs_zoned_data_reloc_unlock(BTRFS_I(inode));
 	return ret;
 }
 
-- 
2.35.1

