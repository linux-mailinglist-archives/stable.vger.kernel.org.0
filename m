Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 191E35B7038
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232939AbiIMOUN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233202AbiIMOSY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:18:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0982647CA;
        Tue, 13 Sep 2022 07:13:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88F6F614A1;
        Tue, 13 Sep 2022 14:13:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C18EC433D6;
        Tue, 13 Sep 2022 14:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078402;
        bh=Xk+ffZi/oa6bLT8bt/QyXdr/GDsumuckqso5rDA4S28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LKamBtO+WszuUvV1cRWlvAURLWryS+1YaYJ8mDtWiawohO+c/FPs4FvUzTd08ccdG
         yhdR7qAe7a1PwHfV9ooFsX7uyysHNYOe41WJKGnMD0v9ZCjNINxcL5wuuHqB8ej78p
         Nk01B5mMKDwOiEz1rjwvFXbxX4GnNMZznEQ4IcTs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 125/192] block: dont add partitions if GD_SUPPRESS_PART_SCAN is set
Date:   Tue, 13 Sep 2022 16:03:51 +0200
Message-Id: <20220913140416.230554549@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 748008e1da926a814cc0a054c81ca614408b1b0c ]

Commit b9684a71fca7 ("block, loop: support partitions without scanning")
adds GD_SUPPRESS_PART_SCAN for replacing part function of
GENHD_FL_NO_PART. But looks blk_add_partitions() is missed, since
loop doesn't want to add partitions if GENHD_FL_NO_PART was set.
And it causes regression on libblockdev (as called from udisks) which
operates with the LO_FLAGS_PARTSCAN.

Fixes the issue by not adding partitions if GD_SUPPRESS_PART_SCAN is
set.

Fixes: b9684a71fca7 ("block, loop: support partitions without scanning")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220823103819.395776-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/partitions/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/block/partitions/core.c b/block/partitions/core.c
index 8a0ec929023bc..76617b1d2d47f 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -597,6 +597,9 @@ static int blk_add_partitions(struct gendisk *disk)
 	if (disk->flags & GENHD_FL_NO_PART)
 		return 0;
 
+	if (test_bit(GD_SUPPRESS_PART_SCAN, &disk->state))
+		return 0;
+
 	state = check_partition(disk);
 	if (!state)
 		return 0;
-- 
2.35.1



