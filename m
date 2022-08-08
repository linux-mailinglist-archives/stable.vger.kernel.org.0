Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5E558C296
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 06:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbiHHEi3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Aug 2022 00:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233189AbiHHEi2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Aug 2022 00:38:28 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C581DFD9;
        Sun,  7 Aug 2022 21:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1659933506; x=1691469506;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qGkEyaTmlYStnq2DFOKi3L5tBXmJjPOAKxO4uAvxLSo=;
  b=TdtqquxiKr2rg2To0vGcRH4lpHjOeQANfJHUQlcDMhQXY18Q/5W5evBm
   6IoakoyLwr//vYb0oUaQaLXyRhOhXO5HLgGQMtxNSf9I990fKv1n7qpqy
   JS245+Wvw2ySpxf690HD3DXpn5LYA290WL58anJqN7y8LmXSCxqdnhNu3
   dkKit+YXC+v0WwCUfrG7H1YmWuNpwGqqoQRHcPCpW68ZwkBmmQ3774p9Y
   Z0xPln5YJUGnjTMwOmanthOfbRmQYT68DgM/MVJDhZUREaLoRyoNN0iTD
   REkuhOyQt0SovmgNYy+kKQZnjYqfXKiKPm/D4nqzxRbCvIOSmt5mown5V
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,221,1654531200"; 
   d="scan'208";a="208100755"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Aug 2022 12:38:26 +0800
IronPort-SDR: wsaR0+TRbCny2sZD5p/Q4a++H1mpU68AYpj8fRI3DlVzg0BxExb+8/zK51L4f7Q72eVNpvanb3
 2ERC2m75E5pjmcrJoz4Gnqge7sy7kApzhan2PgdgYAegDWOXUkQqEOTJu0dWHK6GsFhWAl2Mvb
 7njpCfSOhZxKq+2/7KJKMCoVjiYnyE8P8fANQfjfBZjzRBWupNlID0i7hIwx/HEicLl74htnHG
 bzFOVy0iYjLPpK4XKsj0X2IRzLWyfuz60q7zWf0hw5euTVCalE9AwQQLIo2DBgyhBoUZ6Ekyk1
 IGvd16kHrTBVnH+ZK/AKX4Aj
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Aug 2022 20:54:08 -0700
IronPort-SDR: Eng3JXc/mYj4JObpFZLpRAlsvTfM9KzfOBxrB//WYio7L43lt4fPvqBqagQ8jmhAbExWFw+JvP
 QfwjMS+bi37Ccv1e38KPPiTyX3t08Y3CAJyF7CDnPnVwMb4kAaMs9c7qzCs84mxRay/Ugcpowo
 4LVjLsDzoi8UN9+lpy/2Ft581We7ATHOp1lle1TL8ImcWesPRCpZRL3yQa7sZap27eAHktw68t
 GARh9chrgTXYgDX1A8IDoNFybWC61PrQr6kX2uF/sSJSW54smT4cydsOw0en/Vlpre3YEoPxtf
 DAc=
WDCIronportException: Internal
Received: from ctl002.ad.shared (HELO naota-xeon.wdc.com) ([10.225.53.129])
  by uls-op-cesaip02.wdc.com with ESMTP; 07 Aug 2022 21:38:26 -0700
From:   Naohiro Aota <naohiro.aota@wdc.com>
To:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Cc:     Naohiro Aota <naohiro.aota@wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH STABLE 5.15 2/2] btrfs: zoned: fix critical section of relocation inode writeback
Date:   Mon,  8 Aug 2022 13:38:18 +0900
Message-Id: <20220808043818.1183760-3-naohiro.aota@wdc.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808043818.1183760-1-naohiro.aota@wdc.com>
References: <20220808043818.1183760-1-naohiro.aota@wdc.com>
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
index b791e280af0c..a90546b3107c 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5152,13 +5152,14 @@ int extent_writepages(struct address_space *mapping,
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

