Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E65AF540E44
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353118AbiFGSxn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354546AbiFGSrH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:47:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F5BAB0D0A;
        Tue,  7 Jun 2022 11:02:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3691A617B0;
        Tue,  7 Jun 2022 18:02:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 402E5C34115;
        Tue,  7 Jun 2022 18:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624922;
        bh=7wjUYIaNsXVt03m+j0Kox8IXzon5mRDG5anZNTMcKHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RMJzV8Tv8v9lwL9MY8uA57bi050+qEsThEFnMKyPcnC3Q8UHJys04un1+tfd663Q+
         S8bGf4a60JiBpsoJXW6fsCXf0lVzFFgLT3aX9UEGFZuYXCwKkupCx/8uA7J33U9o4V
         bS9ScRJFXp33CR8BESJ1hetWjisq0LYEVQusr1Z0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 502/667] dmaengine: stm32-mdma: fix chan initialization in stm32_mdma_irq_handler()
Date:   Tue,  7 Jun 2022 19:02:47 +0200
Message-Id: <20220607164949.757277311@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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

From: Amelie Delaunay <amelie.delaunay@foss.st.com>

[ Upstream commit da3b8ddb464bd49b6248d00ca888ad751c9e44fd ]

The parameter to pass back to the handler function when irq has been
requested is a struct stm32_mdma_device pointer, not a struct
stm32_mdma_chan pointer.
Even if chan is reinit later in the function, remove this wrong
initialization.

Fixes: a4ffb13c8946 ("dmaengine: Add STM32 MDMA driver")
Signed-off-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Link: https://lore.kernel.org/r/20220504155322.121431-3-amelie.delaunay@foss.st.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/stm32-mdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/stm32-mdma.c b/drivers/dma/stm32-mdma.c
index 343afb9722ea..21a7bdc88970 100644
--- a/drivers/dma/stm32-mdma.c
+++ b/drivers/dma/stm32-mdma.c
@@ -1344,7 +1344,7 @@ static void stm32_mdma_xfer_end(struct stm32_mdma_chan *chan)
 static irqreturn_t stm32_mdma_irq_handler(int irq, void *devid)
 {
 	struct stm32_mdma_device *dmadev = devid;
-	struct stm32_mdma_chan *chan = devid;
+	struct stm32_mdma_chan *chan;
 	u32 reg, id, ccr, ien, status;
 
 	/* Find out which channel generates the interrupt */
-- 
2.35.1



