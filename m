Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB7CE6AEB07
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231839AbjCGRj1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:39:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbjCGRi7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:38:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BA819E671
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:35:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D40F0B8191D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:35:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43C92C433D2;
        Tue,  7 Mar 2023 17:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210517;
        bh=tNejX0fv5fKZWIl0iCnjhAFVMzbG39fQ+7fL/GDEqfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eXmbXNjUrzBWvvEU9D0YMdtNJ1at9QYRVwIZO7klOEBfzfjmhTqEsp4HQpWHP1h9p
         Nk8Jbm1h1jSOfSgSv6+FrKWat0x684Zld3T8lW9sF/2ayxY8dDUw7s58QFj9vZDUDY
         2xysKMYiDR9zml2wM/OQ0o69GfZ8Skw0moGXnPmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Pilmore <epilmore@gigaio.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0567/1001] dmaengine: ptdma: check for null desc before calling pt_cmd_callback
Date:   Tue,  7 Mar 2023 17:55:39 +0100
Message-Id: <20230307170046.078166671@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Pilmore <epilmore@gigaio.com>

[ Upstream commit 928469986171a6f763b34b039427f5667ba3fd50 ]

Resolves a panic that can occur on AMD systems, typically during host
shutdown, after the PTDMA driver had been exercised. The issue was
the pt_issue_pending() function is mistakenly assuming that there will
be at least one descriptor in the Submitted queue when the function
is called. However, it is possible that both the Submitted and Issued
queues could be empty, which could result in pt_cmd_callback() being
mistakenly called with a NULL pointer.
Ref: Bugzilla Bug 216856.

Fixes: 6fa7e0e836e2 ("dmaengine: ptdma: fix concurrency issue with multiple dma transfer")
Signed-off-by: Eric Pilmore <epilmore@gigaio.com>
Link: https://lore.kernel.org/r/20230210075142.58253-1-epilmore@gigaio.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ptdma/ptdma-dmaengine.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/ptdma/ptdma-dmaengine.c b/drivers/dma/ptdma/ptdma-dmaengine.c
index cc22d162ce250..1aa65e5de0f3a 100644
--- a/drivers/dma/ptdma/ptdma-dmaengine.c
+++ b/drivers/dma/ptdma/ptdma-dmaengine.c
@@ -254,7 +254,7 @@ static void pt_issue_pending(struct dma_chan *dma_chan)
 	spin_unlock_irqrestore(&chan->vc.lock, flags);
 
 	/* If there was nothing active, start processing */
-	if (engine_is_idle)
+	if (engine_is_idle && desc)
 		pt_cmd_callback(desc, 0);
 }
 
-- 
2.39.2



