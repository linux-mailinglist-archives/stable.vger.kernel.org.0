Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5F0D54907D
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383432AbiFMOWt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383310AbiFMOVy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:21:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 578FCA207D;
        Mon, 13 Jun 2022 04:44:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9C03612AC;
        Mon, 13 Jun 2022 11:44:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E8BC34114;
        Mon, 13 Jun 2022 11:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120642;
        bh=/XQp6G/NIOfCaEEU79/UPBuVPS3v/JgYHvs5q5WjPv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J1BEfjAb6onkrD0kZwL88svThF1b7SEcfJdWkc/cq+tbvh/56rZ04kiKZhjNlMfVv
         pwEjavMsRf0lBvIkphT0VNvj12acoj0pSbPJOFW1oz6y9xKIpdATO72+qHDWC26n/f
         I9GMw+j/w1PDFT4rao0KNKV1QvSiccmFKVFat6No=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haisu Wang <haisuwang@tencent.com>,
        samuelliao <samuelliao@tencent.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 105/298] blk-mq: do not update io_ticks with passthrough requests
Date:   Mon, 13 Jun 2022 12:09:59 +0200
Message-Id: <20220613094928.134297731@linuxfoundation.org>
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

From: Haisu Wang <haisuwang@tencent.com>

[ Upstream commit b81c14ca14b631aa1abae32fb5ae75b5e9251012 ]

Flush or passthrough requests are not accounted as normal IO in completion.
To reflect iostat for slow IO, io_ticks is updated when stat show called
based on inflight numbers.
It may cause inconsistent io_ticks calculation result.

So do not account non-passthrough request when check inflight.

Fixes: 86d7331299fd ("block: update io_ticks when io hang")
Signed-off-by: Haisu Wang <haisuwang@tencent.com>
Reviewed-by: samuelliao <samuelliao@tencent.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220530064059.1120058-1-haisuwang@tencent.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 6afe0cd128ac..f18e1c9c3f4a 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -132,7 +132,8 @@ static bool blk_mq_check_inflight(struct request *rq, void *priv,
 {
 	struct mq_inflight *mi = priv;
 
-	if ((!mi->part->bd_partno || rq->part == mi->part) &&
+	if (rq->part && blk_do_io_stat(rq) &&
+	    (!mi->part->bd_partno || rq->part == mi->part) &&
 	    blk_mq_rq_state(rq) == MQ_RQ_IN_FLIGHT)
 		mi->inflight[rq_data_dir(rq)]++;
 
-- 
2.35.1



