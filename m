Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4ABD5EA1FA
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237025AbiIZLAR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237286AbiIZK7S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:59:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25BE55C972;
        Mon, 26 Sep 2022 03:30:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ABEEAB80930;
        Mon, 26 Sep 2022 10:29:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD6BC433C1;
        Mon, 26 Sep 2022 10:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188177;
        bh=8yjxeJaLsFyddxEoLe4GbCUknf9u3Le+pjnTTNM+Hg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hMO1+3PF1obb5s/6k4Gq3hV2wyMCNmZw24+UjdB4RnZ7bFLtLfS7vGzl6/2pimRYz
         twRqQAjuuB5FnBWYaSQQttLBgRhrCIiZ4NbEnd/+h+8icidPl7PwxN30dAa6BSxMpX
         GBUcneqi3cVJRRMV7Q3ZrKE58pyt1+t73fL3AsGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 066/141] dmaengine: ti: k3-udma-private: Fix refcount leak bug in of_xudma_dev_get()
Date:   Mon, 26 Sep 2022 12:11:32 +0200
Message-Id: <20220926100756.821231579@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit f9fdb0b86f087c2b7f6c6168dd0985a3c1eda87e ]

We should call of_node_put() for the reference returned by
of_parse_phandle() in fail path or when it is not used anymore.
Here we only need to move the of_node_put() before the check.

Fixes: d70241913413 ("dmaengine: ti: k3-udma: Add glue layer for non DMAengine users")
Signed-off-by: Liang He <windhl@126.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Link: https://lore.kernel.org/r/20220720073234.1255474-1-windhl@126.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti/k3-udma-private.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/ti/k3-udma-private.c b/drivers/dma/ti/k3-udma-private.c
index 8563a392f30b..dadab2feca08 100644
--- a/drivers/dma/ti/k3-udma-private.c
+++ b/drivers/dma/ti/k3-udma-private.c
@@ -31,14 +31,14 @@ struct udma_dev *of_xudma_dev_get(struct device_node *np, const char *property)
 	}
 
 	pdev = of_find_device_by_node(udma_node);
+	if (np != udma_node)
+		of_node_put(udma_node);
+
 	if (!pdev) {
 		pr_debug("UDMA device not found\n");
 		return ERR_PTR(-EPROBE_DEFER);
 	}
 
-	if (np != udma_node)
-		of_node_put(udma_node);
-
 	ud = platform_get_drvdata(pdev);
 	if (!ud) {
 		pr_debug("UDMA has not been probed\n");
-- 
2.35.1



