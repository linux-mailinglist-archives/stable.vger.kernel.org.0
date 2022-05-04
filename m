Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42E4F5192FE
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 02:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244776AbiEDAxR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 20:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244769AbiEDAxQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 20:53:16 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E7B43F8BB;
        Tue,  3 May 2022 17:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1651625383; x=1683161383;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5HVpc36GD/gLGbmClhd7HS6r7wGttaAQGBxRDAT8lus=;
  b=RieTnPKKAKPdp6baQq2+TpWbhayI5uX0lHn7MRj2b4SkQIPam3KmKm/l
   hcgpmiO2K0+9UaHgmM0JQbcxqv+UrlgNqN9hFp+9w7HHHCjtLTFZWp3l3
   zaUeQneDRS2o8pQARnMfQWgLNigWowNJCVzDKJLV+dLEbmWkQtkugCMm3
   8Wn/uUkEqNKf1K/UxWjw7An2JlZ9WA95TFi/wh2e2eSjNIqnvsaU5p2YP
   FX5rkug1nqX37ZziFnjYFRBamutOp1WVHm5u0zNp3lUxRngVMHeLXxSd6
   tkl1M63zzKSI4DByztiG/YZQ75USZsjrE+66Nh7+xUu+EGTdhdORPhqYP
   w==;
X-IronPort-AV: E=Sophos;i="5.91,196,1647273600"; 
   d="scan'208";a="200341886"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 04 May 2022 08:49:42 +0800
IronPort-SDR: AhIQwvzX+I0GmabbE87AMzDjVqbBrLAodbwwuWWsuymVnAJ9HC4SyXjCzByZYWNW+YtZOFke8R
 sZ3IPRPoAf1XvASY+SXIWGDoR0MBnWQKUEYdq2eQOH1hOPVdrNDY7aO1/CwhBEvhTfAM1TTUBh
 uxstnm0bK7Bg9Pa9QLwLNTGrAHgeH2bvpvm2scLn6Kb1XZXQSeQNuQZsaSFKCjlKoIy6SQBYgt
 7NsUGy6sPxEL2eJpdsg9I8LzGVdLqNrtNuwxysYTq+DRt43VLVIwd9HfNKoGRJwpr0wmr1xDEk
 xu9qvw7p/l5e4K1/l1nr48Uu
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 May 2022 17:19:44 -0700
IronPort-SDR: 76vdjQFV9lyxlFcn3HOzX8kH1l9ZPXNpJuG9uwtNZOQ7QS6tTlQrOpgU+M65V6/VXMHi38zf+y
 fzWAHmr8wwT3poHU/okiCz9v+ig+SOCzd1XSBXlAXjm/DsxPwXL/FSi67nDbght+Y8dgPdL02c
 syOuOs1R5AWEdk+TdYieVHxBsg5wiPCWj4CigALERBnJ89Pl9qkOnwu29q6qpXxaI/YGNd5Qkw
 xADxxwKtQ3TBbAri8iIddK26mVcOxE8k0fd87YYBfHYpTyMSIPrMuhuuuPFsbqfhZzhwZCsSs/
 Gvw=
WDCIronportException: Internal
Received: from jv0vzd3.ad.shared (HELO naota-x1.wdc.com) ([10.225.48.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 03 May 2022 17:49:40 -0700
From:   Naohiro Aota <naohiro.aota@wdc.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Naohiro Aota <naohiro.aota@wdc.com>, stable@vger.kernel.org,
        Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH v2 3/5] btrfs: zoned: finish BG when there are no more allocatable bytes left
Date:   Tue,  3 May 2022 17:48:52 -0700
Message-Id: <f50c845105ca7f81383c3feb1d1bc399bc589fd4.1651624820.git.naohiro.aota@wdc.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1651624820.git.naohiro.aota@wdc.com>
References: <cover.1651624820.git.naohiro.aota@wdc.com>
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

Currently, btrfs_zone_finish_endio() finishes a block group only when the
written region reaches the end of the block group. We can also finish the
block group when no more allocation is possible.

Cc: stable@vger.kernel.org # 5.16+
Fixes: be1a1d7a5d24 ("btrfs: zoned: finish fully written block group")
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
---
 fs/btrfs/zoned.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 0286fb1c63db..320bb7ba1c49 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2021,6 +2021,7 @@ bool btrfs_can_activate_zone(struct btrfs_fs_devices *fs_devices, u64 flags)
 void btrfs_zone_finish_endio(struct btrfs_fs_info *fs_info, u64 logical, u64 length)
 {
 	struct btrfs_block_group *block_group;
+	u64 min_alloc_bytes;
 
 	if (!btrfs_is_zoned(fs_info))
 		return;
@@ -2028,7 +2029,15 @@ void btrfs_zone_finish_endio(struct btrfs_fs_info *fs_info, u64 logical, u64 len
 	block_group = btrfs_lookup_block_group(fs_info, logical);
 	ASSERT(block_group);
 
-	if (logical + length < block_group->start + block_group->zone_capacity)
+	/* No MIXED BG on zoned btrfs. */
+	if (block_group->flags & BTRFS_BLOCK_GROUP_DATA)
+		min_alloc_bytes = fs_info->sectorsize;
+	else
+		min_alloc_bytes = fs_info->nodesize;
+
+	/* Bail out if we can allocate more data from this BG. */
+	if (logical + length + min_alloc_bytes <=
+	    block_group->start + block_group->zone_capacity)
 		goto out;
 
 	do_zone_finish(block_group, true);
-- 
2.35.1

