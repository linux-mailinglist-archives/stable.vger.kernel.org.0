Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0337549889
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382694AbiFMOVG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382944AbiFMOTX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:19:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EB3B4615D;
        Mon, 13 Jun 2022 04:43:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F63BB80EB2;
        Mon, 13 Jun 2022 11:43:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D3BC34114;
        Mon, 13 Jun 2022 11:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120626;
        bh=8SmF3u8jtyrgaKPmoZQpFxedcHtPU80zlRVhFLsWpQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j2xrdYiMcdcoUYMQwO8HcDnxOb9iFDHc4i9htbauwWOVpneAN/enkjXMkab4yf7cw
         NZ/qALPgfuB7mnYkmr6eZpYScV6PP7Sw8HSFKIsVc70AkGM1Acyd0EhZTWi6Pj3o1E
         Bi6xG2FJjQyXrs4dIBGa9LoFNHMq34Bsm9sIXg2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 101/298] block: use bio_queue_enter instead of blk_queue_enter in bio_poll
Date:   Mon, 13 Jun 2022 12:09:55 +0200
Message-Id: <20220613094928.015022495@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
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
index 779b4a1f66ac..45d750eb2628 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -992,7 +992,7 @@ int bio_poll(struct bio *bio, struct io_comp_batch *iob, unsigned int flags)
 	if (current->plug)
 		blk_flush_plug(current->plug, false);
 
-	if (blk_queue_enter(q, BLK_MQ_REQ_NOWAIT))
+	if (bio_queue_enter(bio))
 		return 0;
 	if (WARN_ON_ONCE(!queue_is_mq(q)))
 		ret = 0;	/* not yet implemented, should not happen */
-- 
2.35.1



