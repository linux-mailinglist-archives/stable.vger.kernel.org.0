Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03DD258BED2
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242155AbiHHBc5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242062AbiHHBcR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:32:17 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA704B859;
        Sun,  7 Aug 2022 18:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1659922336; x=1691458336;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4iRH2Heg/YztVNHuPLG+Pi5cN1PMuYAJr1dtblZ5aQE=;
  b=B/yZbIFUf5Cqr+TxUea9Ft1QSSdeKwRtsohxcf+OwPTMUtoZGSgvgyYY
   1/eeWFy+Cg9m+VvGzR+rchziT7U9kZBOZgygDb27urDoCQos0KXsYlDZb
   HzU3w5GpNjxBHNS+XAbFbmQv/qeaPpB7YL1MOd/XWsa6FxP5v63lCKKNV
   rBNj0yl7iF9Z2jFZDbLNRtrThyafLnnMBy3Wtj2P2ffJb9NN7+PQkdVWK
   b2TcfX1x5yP6D7+4wjnH5GnLCEnWdwaNzL7WEzYTbIy9vFXYnwemPjCQD
   nhkaBWdnTaRBprz0a7ypAhQcvd8nNFjXNWCzNc4X8W/vRJx6MlrhvZNMB
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,221,1654531200"; 
   d="scan'208";a="320180306"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Aug 2022 09:32:15 +0800
IronPort-SDR: nhUYnPGi6nijPjh/L/GzmPwXoay1EX3kgLHknyX/IcLAZxiu8xU3yOjGOcHLOso5M//Qb/1yRn
 c+Q9lvEn6JPJjU9yycqfsxbdaChVxAeybBDjQQMsf9Jn/mcLBF8l2Ze7h1246wSAHf+W7rYhQc
 iOtPv4Q2ZDGW9YRl5QnsB8UQzbaWWU2rG1nj1Akby6vNMS+KhtbZF5qxGw6C087c5PuIP9CXTN
 lg5qN2cTSpolxK4c/0WNYbhABilbjMqXtRfbWkGjX92TSrHW6LJR4Lj1/E5ibZptOgad6J40D4
 QKUMZxkueGs7WMmuZX6Ddp2I
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Aug 2022 17:47:56 -0700
IronPort-SDR: 5ugjVepvgjD4wh9FSoYFYexJJmjtGxMmeARorLemJybAnawW3QAQJhF4QJErqfsIk5Dnx0neZR
 f8ZopckzcbGItNWU+kWzSGZJLhtHU1e9ActiDhtbbfIvkNcQA4iB3J5JM9gdBkjCFAvnAOYvWe
 RGJ3w6TqWdWM8VYzYIkZog8tUwqi3VHkIZzrNLahQBwrsx5XuNScV/mbIAux2xmZ41Q9ToRFXo
 3Wf65sKAlxnc6KPloPj84y+nHie6Z7D2/V5QFjJBhcQbQFpgAtWrh3fgY6rv1R3A6M0kgxLyRe
 4UQ=
WDCIronportException: Internal
Received: from ctl002.ad.shared (HELO naota-xeon.wdc.com) ([10.225.53.129])
  by uls-op-cesaip01.wdc.com with ESMTP; 07 Aug 2022 18:32:14 -0700
From:   Naohiro Aota <naohiro.aota@wdc.com>
To:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Cc:     Naohiro Aota <naohiro.aota@wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH STABLE 5.18 2/3] btrfs: zoned: fix critical section of relocation inode writeback
Date:   Mon,  8 Aug 2022 10:32:09 +0900
Message-Id: <20220808013210.646680-3-naohiro.aota@wdc.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013210.646680-1-naohiro.aota@wdc.com>
References: <20220808013210.646680-1-naohiro.aota@wdc.com>
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

