Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46335548F67
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378721AbiFMNm2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379184AbiFMNkA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:40:00 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 519BE22B0A;
        Mon, 13 Jun 2022 04:29:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C738ECE116E;
        Mon, 13 Jun 2022 11:29:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD518C34114;
        Mon, 13 Jun 2022 11:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119766;
        bh=zaJ54aqljYU3glLctuLdXw0T4Jh9fBKyskzpmi1NTio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gQ95zkduYSwznI0OHVljsaPT/JujjVXJNHoniEai+rCZw8wml5LEA7N3pSBX2/YXw
         tFYus8lNBNsgomdWBRpcbNJyuhBJsRh+i8OMVmrXpLOkvTcKuxY8Us+Bb7qaUNCTR1
         OxSbzWkLz4tdQ+ZHIfzsWJBw8k3SKgJRihQsyi/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 112/339] block: use bio_queue_enter instead of blk_queue_enter in bio_poll
Date:   Mon, 13 Jun 2022 12:08:57 +0200
Message-Id: <20220613094929.908659843@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit ebd076bf7d5deef488ec7ebc3fdbf781eafae269 ]

We want to have a valid live gendisk to call ->poll and not just a
request_queue, so call the right helper.

Fixes: 3e08773c3841 ("block: switch polling to be bio based")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220523124302.526186-1-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index bc0506772152..84f7b7884d07 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -948,7 +948,7 @@ int bio_poll(struct bio *bio, struct io_comp_batch *iob, unsigned int flags)
 
 	blk_flush_plug(current->plug, false);
 
-	if (blk_queue_enter(q, BLK_MQ_REQ_NOWAIT))
+	if (bio_queue_enter(bio))
 		return 0;
 	if (queue_is_mq(q)) {
 		ret = blk_mq_poll(q, cookie, iob, flags);
-- 
2.35.1



