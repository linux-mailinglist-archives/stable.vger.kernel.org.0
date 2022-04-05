Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66DD44F2F98
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353494AbiDEKHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344360AbiDEJTe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:19:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B0FA229;
        Tue,  5 Apr 2022 02:07:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2004F61573;
        Tue,  5 Apr 2022 09:07:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33C6CC385A0;
        Tue,  5 Apr 2022 09:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149671;
        bh=p7xJ9qpWfezlsKnmcqhlhATGgUbph48s1/5K73DMHN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=toAEP63mjREhutBDQjm5ubmqAQ/4/ayib39C1xBR2wb2v5X/HhQineseQTyVgzkA+
         fTRWFiaD0T6MM3uwIH8XL75jBcXzrXox4+nsn9tAuGlENQyIc10xkWECKpOTWYHuWU
         B1uGqdO4VUuTEUBmbiGylZ6GFLB3hu6+hxUwji7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yahu Gao <gaoyahu19@gmail.com>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0760/1017] block/bfq_wf2q: correct weight to ioprio
Date:   Tue,  5 Apr 2022 09:27:53 +0200
Message-Id: <20220405070416.818462026@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
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



