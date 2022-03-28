Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D682E4E940A
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 13:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241024AbiC1L0J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 07:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241716AbiC1LYJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 07:24:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCDF356212;
        Mon, 28 Mar 2022 04:21:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D80961126;
        Mon, 28 Mar 2022 11:21:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F9BDC36AE5;
        Mon, 28 Mar 2022 11:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648466505;
        bh=p7xJ9qpWfezlsKnmcqhlhATGgUbph48s1/5K73DMHN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CP/oZgRIqKbUfX0YKgoftcYgZW6AdFVHZREwqrHCTMfHmv6WDs7hgB3wK0p770XsR
         /xQfvP52JH/dBIAWOruGI14mP+S/bTiSITZFg3tME82RCZtilRV53hKW8M7xNDnF4H
         K9S59F6oty2weRnWMkm5zIgUgUDJkNz0dnVEUY/OJybkuxKkhuXfgW/ZyZQGYEINt5
         /pKbRGa1ZkK3tuz6ge4FYE3mKOpiVLO31gUEzvQ0k3/e4Fnac+A3ythm1UFrC8t5RU
         P0QMMxKx8WQO2nFSq7H+0Y6+H3HdJCwG6wMemCfqoq8g+B5IvtuLRpGvYHujwvfumA
         upUvcjmgj486w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yahu Gao <gaoyahu19@gmail.com>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 07/29] block/bfq_wf2q: correct weight to ioprio
Date:   Mon, 28 Mar 2022 07:21:09 -0400
Message-Id: <20220328112132.1555683-7-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328112132.1555683-1-sashal@kernel.org>
References: <20220328112132.1555683-1-sashal@kernel.org>
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

From: Yahu Gao <gaoyahu19@gmail.com>

[ Upstream commit bcd2be763252f3a4d5fc4d6008d4d96c601ee74b ]

The return value is ioprio * BFQ_WEIGHT_CONVERSION_COEFF or 0.
What we want is ioprio or 0.
Correct this by changing the calculation.

Signed-off-by: Yahu Gao <gaoyahu19@gmail.com>
Acked-by: Paolo Valente <paolo.valente@linaro.org>
Link: https://lore.kernel.org/r/20220107065859.25689-1-gaoyahu19@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-wf2q.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
index b74cc0da118e..709b901de3ca 100644
--- a/block/bfq-wf2q.c
+++ b/block/bfq-wf2q.c
@@ -519,7 +519,7 @@ unsigned short bfq_ioprio_to_weight(int ioprio)
 static unsigned short bfq_weight_to_ioprio(int weight)
 {
 	return max_t(int, 0,
-		     IOPRIO_NR_LEVELS * BFQ_WEIGHT_CONVERSION_COEFF - weight);
+		     IOPRIO_NR_LEVELS - weight / BFQ_WEIGHT_CONVERSION_COEFF);
 }
 
 static void bfq_get_entity(struct bfq_entity *entity)
-- 
2.34.1

