Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC31250112E
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 16:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232112AbiDNNl4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344534AbiDNNca (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:32:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF9022298;
        Thu, 14 Apr 2022 06:30:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 485026190F;
        Thu, 14 Apr 2022 13:30:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D8AC385A1;
        Thu, 14 Apr 2022 13:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943004;
        bh=6qmuWssJE8BGwTQm90LV/eDA7PH3hvnsKvgw2QngIXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xxsd8jgP8D4JbLAsYRR7x+vWbzXQedcRBFKJ7GJySqjuWsBID8xVmP1YcrXiAcVi8
         NT2sDq0zUd8XkMbVhuDkQgF57yb0Gwt3CCuRK+kuO55eK0/iCyKPL4NtB5o6oIoVG4
         saJNMPSsPXxeh/Wv1WbOthKtnDvyNI4hW3y9bDmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 4.19 326/338] dmaengine: Revert "dmaengine: shdma: Fix runtime PM imbalance on error"
Date:   Thu, 14 Apr 2022 15:13:49 +0200
Message-Id: <20220414110848.170460403@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
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

From: Vinod Koul <vkoul@kernel.org>

commit d143f939a95696d38ff800ada14402fa50ebbd6c upstream.

This reverts commit 455896c53d5b ("dmaengine: shdma: Fix runtime PM
imbalance on error") as the patch wrongly reduced the count on error and
did not bail out. So drop the count by reverting the patch .

Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/sh/shdma-base.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/dma/sh/shdma-base.c
+++ b/drivers/dma/sh/shdma-base.c
@@ -118,10 +118,8 @@ static dma_cookie_t shdma_tx_submit(stru
 		ret = pm_runtime_get(schan->dev);
 
 		spin_unlock_irq(&schan->chan_lock);
-		if (ret < 0) {
+		if (ret < 0)
 			dev_err(schan->dev, "%s(): GET = %d\n", __func__, ret);
-			pm_runtime_put(schan->dev);
-		}
 
 		pm_runtime_barrier(schan->dev);
 


