Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6127259B901
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 08:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232698AbiHVGHd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 02:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232647AbiHVGHc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 02:07:32 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 895DD2654D;
        Sun, 21 Aug 2022 23:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1661148451; x=1692684451;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ScblraXDsVbrqr7ODiFmAzbvRSYBn/pS99AjuXIZHKw=;
  b=Z25i9Pq4zJrCXYrmup+ueerOUUs1rKa0a1VidjJPGfOxBDiSss/ZKjcB
   P9P0QXSuvayhK3l1BP8pb6CoVCPuZt41cTBpLcB38wQqrRH949TQewOiP
   r0nrkQdZuPQIo6PFiZRXarrJEGJ5G+JnMl3a2STD9SCOH8gK4MUKa4Jbs
   XBsByuLTMjJLx/mrg1RpBFdN+d5Bf8jG5K+TUacAi/Q6Hd9Pv0ohh0+OT
   5UWLsLLhNuT+CK34B2tMeKMtGktbp5G2UE0d4/uiC8O5Yng3c217Fe81q
   5K6lrOo0Ab6efiUOEL8kCGj7JhcJoHFmpHkM5oyPmSN9XzYW91FGLDzD0
   A==;
X-IronPort-AV: E=Sophos;i="5.93,254,1654531200"; 
   d="scan'208";a="321397070"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 22 Aug 2022 14:07:30 +0800
IronPort-SDR: B996cZsUyDfB5nnLlm8VlPu7DzmqKzmu5OLYhkVb8jpic6Nb2HQlYbp8eULaKOs6bFz6NTaXuf
 ZtBeAP0uKCmR8zDvWZs8DaPhjtWn75C1xjm5JoRiMQByn4Zjqz2Fy2YQ22I5R2W7LLsr9Ag8yD
 5Mu50MDohJyo20kH/g7vpdp+ZynaUtTw8cplOFEddvXOeGu4Jq/Uu8tSJK6TTAZZkS7niQHB4u
 gfMY0MGklib6UC/fb9T6YtYFDetpoquY+7H9iM7iYnRgQZE1d/UvnuogljWwHp6cx59Mmx7ALQ
 PqSqbpBbvJFalPhsXk7TNutG
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Aug 2022 22:28:12 -0700
IronPort-SDR: TWX3mDkDjSO9dy6sk0G+RDjJedtPRinK+crmjTAwGaYx/7NkZcZyMXWjUkIYMjcoVhlSRlBHhR
 yT7ea8lXMCMoTFq8uhxMhYSMPJuDX3MSgtOFReLEspFpqgFBKhzDfKaYqvIrPSO7XTvXPsvtAt
 fH5dNZLr7WTWJVWmKSl0K0h80tUyFQIsTU2/w8tuY9aF9Uapk5wVD636N8R1IVNt++uyM8rpj4
 pb/KvthHKyuydDQNiMoWLvZEhPFghG6apF3nQabGmBp2fScu5mSwGLhdi9kUp4zIGjk165oiTR
 hTQ=
WDCIronportException: Internal
Received: from unknown (HELO naota-xeon.wdc.com) ([10.225.50.191])
  by uls-op-cesaip02.wdc.com with ESMTP; 21 Aug 2022 23:07:29 -0700
From:   Naohiro Aota <naohiro.aota@wdc.com>
To:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Cc:     Naohiro Aota <naohiro.aota@wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH STABLE 5.15 2/5] block: add bdev_max_segments() helper
Date:   Mon, 22 Aug 2022 15:07:01 +0900
Message-Id: <20220822060704.1278361-3-naohiro.aota@wdc.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220822060704.1278361-1-naohiro.aota@wdc.com>
References: <20220822060704.1278361-1-naohiro.aota@wdc.com>
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

commit 65ea1b66482f415d51cd46515b02477257330339 upstream

Add bdev_max_segments() like other queue parameters.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 include/linux/blkdev.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 2f4ba6e345d5..67344dfe07a7 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1393,6 +1393,11 @@ bdev_max_zone_append_sectors(struct block_device *bdev)
 	return queue_max_zone_append_sectors(bdev_get_queue(bdev));
 }
 
+static inline unsigned int bdev_max_segments(struct block_device *bdev)
+{
+	return queue_max_segments(bdev_get_queue(bdev));
+}
+
 static inline unsigned queue_logical_block_size(const struct request_queue *q)
 {
 	int retval = 512;
-- 
2.37.2

