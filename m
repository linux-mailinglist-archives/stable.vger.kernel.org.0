Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61C264E94D2
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 13:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241428AbiC1Lcl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 07:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241489AbiC1Lb2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 07:31:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED1A57499;
        Mon, 28 Mar 2022 04:24:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 262B360F43;
        Mon, 28 Mar 2022 11:24:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB69C340ED;
        Mon, 28 Mar 2022 11:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648466661;
        bh=rLsO+ntsnTh0EzAnd/PjkFHrU+ojDgLX96KW1jxcRh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z8BiODu4WuPordFkxBrJ1pg0wWczddBALNfUnSTZgqTgfLAYPDoODxiOBgCT5H6jX
         Bh7i9pyldUdgrwXyu/E3xsGyPtino8wEKopRNrxlkZxZ+4pxfawKWrDU/AFN5mRiXK
         Ki1biKUxdgIqG7MQi4X+vYBwBSf+5Qsoa1Cjju1j2LxQk/AP9UPfKgPU+vWVxb3AaM
         PvdsZAmduIoQywIkZQlYBSBBULWZqCgJxRY5g5JKQfo+wg8TcWCmOvqWyo6lz2mTrQ
         DOuA7Oc0zIkpvE8BusrrWeBaKFfTShd3GTIK+LLXdp73cv65U+kIkc1ahNJM4vBvIB
         1hLhUQojSM9+Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chaitanya Kulkarni <kch@nvidia.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 02/12] loop: use sysfs_emit() in the sysfs xxx show()
Date:   Mon, 28 Mar 2022 07:24:07 -0400
Message-Id: <20220328112417.1556946-2-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328112417.1556946-1-sashal@kernel.org>
References: <20220328112417.1556946-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Chaitanya Kulkarni <kch@nvidia.com>

[ Upstream commit b27824d31f09ea7b4a6ba2c1b18bd328df3e8bed ]

sprintf does not know the PAGE_SIZE maximum of the temporary buffer
used for outputting sysfs content and it's possible to overrun the
PAGE_SIZE buffer length.

Use a generic sysfs_emit function that knows the size of the
temporary buffer and ensures that no overrun is done for offset
attribute in
loop_attr_[offset|sizelimit|autoclear|partscan|dio]_show() callbacks.

Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Link: https://lore.kernel.org/r/20220215213310.7264-2-kch@nvidia.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/loop.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 19042b42a8ba..c31a76485c9c 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -795,33 +795,33 @@ static ssize_t loop_attr_backing_file_show(struct loop_device *lo, char *buf)
 
 static ssize_t loop_attr_offset_show(struct loop_device *lo, char *buf)
 {
-	return sprintf(buf, "%llu\n", (unsigned long long)lo->lo_offset);
+	return sysfs_emit(buf, "%llu\n", (unsigned long long)lo->lo_offset);
 }
 
 static ssize_t loop_attr_sizelimit_show(struct loop_device *lo, char *buf)
 {
-	return sprintf(buf, "%llu\n", (unsigned long long)lo->lo_sizelimit);
+	return sysfs_emit(buf, "%llu\n", (unsigned long long)lo->lo_sizelimit);
 }
 
 static ssize_t loop_attr_autoclear_show(struct loop_device *lo, char *buf)
 {
 	int autoclear = (lo->lo_flags & LO_FLAGS_AUTOCLEAR);
 
-	return sprintf(buf, "%s\n", autoclear ? "1" : "0");
+	return sysfs_emit(buf, "%s\n", autoclear ? "1" : "0");
 }
 
 static ssize_t loop_attr_partscan_show(struct loop_device *lo, char *buf)
 {
 	int partscan = (lo->lo_flags & LO_FLAGS_PARTSCAN);
 
-	return sprintf(buf, "%s\n", partscan ? "1" : "0");
+	return sysfs_emit(buf, "%s\n", partscan ? "1" : "0");
 }
 
 static ssize_t loop_attr_dio_show(struct loop_device *lo, char *buf)
 {
 	int dio = (lo->lo_flags & LO_FLAGS_DIRECT_IO);
 
-	return sprintf(buf, "%s\n", dio ? "1" : "0");
+	return sysfs_emit(buf, "%s\n", dio ? "1" : "0");
 }
 
 LOOP_ATTR_RO(backing_file);
-- 
2.34.1

