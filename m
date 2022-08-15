Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43161593DF6
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345474AbiHOUde (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347303AbiHOUbF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:31:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19BC6A4074;
        Mon, 15 Aug 2022 12:04:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7AFF0B8110A;
        Mon, 15 Aug 2022 19:04:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852F3C433D6;
        Mon, 15 Aug 2022 19:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590279;
        bh=eSCLQPm4JrorGQH+yAQyQacLZ20uAQNUTy1284zWgFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Md58umynxB6QaJ6PZPZO/olk7rEyh6KkuTBWoujwiGt9QDHtG8qtpJ70DGpZJyj5
         RkIGYZgtKzvSrDgyXkPpcSraOuUAE3G/V0bOQSfbrrx8I/vtYK3QOAE8593FMpJZkx
         R15exNKP36d2rygbnPyMT8G/J2qpssi0e9xrJQsI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0210/1095] block: fix infinite loop for invalid zone append
Date:   Mon, 15 Aug 2022 19:53:29 +0200
Message-Id: <20220815180438.357692738@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit b82d9fa257cb3725c49d94d2aeafc4677c34448a ]

Returning 0 early from __bio_iov_append_get_pages() for the
max_append_sectors warning just creates an infinite loop since 0 means
success, and the bio will never fill from the unadvancing iov_iter. We
could turn the return into an error value, but it will already be turned
into an error value later on, so just remove the warning. Clearly no one
ever hit it anyway.

Fixes: 0512a75b98f84 ("block: Introduce REQ_OP_ZONE_APPEND")
Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Link: https://lore.kernel.org/r/20220610195830.3574005-2-kbusch@fb.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index d3ca79c3ebdf..fd73ee03d57e 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1199,9 +1199,6 @@ static int __bio_iov_append_get_pages(struct bio *bio, struct iov_iter *iter)
 	size_t offset;
 	int ret = 0;
 
-	if (WARN_ON_ONCE(!max_append_sectors))
-		return 0;
-
 	/*
 	 * Move page array up in the allocated memory for the bio vecs as far as
 	 * possible so that we can start filling biovecs from the beginning
-- 
2.35.1



