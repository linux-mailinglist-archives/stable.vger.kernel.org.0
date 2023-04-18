Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28E316E63D4
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbjDRMnh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231337AbjDRMnf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:43:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED789146EF
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:43:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 532386335F
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:43:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 630D0C4339B;
        Tue, 18 Apr 2023 12:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821812;
        bh=jaQaabwiGAugIc2jTfWH15Ai29yX7+57k6YWU76NwQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=erZCq2AAmnxQ54FklfsdRNerPlN7ymQrneMueFMf92ghqZ+Zv8k88ng80A600kOlI
         LdT7skywtT0gdrKJ1GjTv38laaJ1G9kJemmFOlbFmnMguwtb5nRjB+2lrIzAnl2QZg
         5Ap4KUnntyY0a2CB6PjCh4ajTNAFat0Pc65vygQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Martin=20Povi=C5=A1er?= <povik+lin@cutebit.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 043/134] dmaengine: apple-admac: Fix current_tx not getting freed
Date:   Tue, 18 Apr 2023 14:21:39 +0200
Message-Id: <20230418120314.432041259@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Povišer <povik+lin@cutebit.org>

[ Upstream commit d9503be5a100c553731c0e8a82c7b4201e8a970c ]

In terminate_all we should queue up all submitted descriptors to be
freed. We do that for the content of the 'issued' and 'submitted' lists,
but the 'current_tx' descriptor falls through the cracks as it's
removed from the 'issued' list once it gets assigned to be the current
descriptor. Explicitly queue up freeing of the 'current_tx' descriptor
to address a memory leak that is otherwise present.

Fixes: b127315d9a78 ("dmaengine: apple-admac: Add Apple ADMAC driver")
Signed-off-by: Martin Povišer <povik+lin@cutebit.org>
Link: https://lore.kernel.org/r/20230224152222.26732-2-povik+lin@cutebit.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/apple-admac.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/apple-admac.c b/drivers/dma/apple-admac.c
index b9132b495d181..4cf8da77bdd91 100644
--- a/drivers/dma/apple-admac.c
+++ b/drivers/dma/apple-admac.c
@@ -512,7 +512,10 @@ static int admac_terminate_all(struct dma_chan *chan)
 	admac_stop_chan(adchan);
 	admac_reset_rings(adchan);
 
-	adchan->current_tx = NULL;
+	if (adchan->current_tx) {
+		list_add_tail(&adchan->current_tx->node, &adchan->to_free);
+		adchan->current_tx = NULL;
+	}
 	/*
 	 * Descriptors can only be freed after the tasklet
 	 * has been killed (in admac_synchronize).
-- 
2.39.2



