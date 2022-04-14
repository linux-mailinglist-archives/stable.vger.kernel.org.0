Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33DF4501055
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 16:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244706AbiDNOHG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347687AbiDNN71 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:59:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABFC35D672;
        Thu, 14 Apr 2022 06:51:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47ACC61DF0;
        Thu, 14 Apr 2022 13:51:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506ADC385A1;
        Thu, 14 Apr 2022 13:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649944282;
        bh=QaNOR5RKZom6VvVT+7/5NSchd1phah1uvn1QBNxVMAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FAMqrHmc83yg23Ssyvnt50h8CChPsCG3fYBLHsYGR1pjTs2MpoBNnW5OqdY9zZs7Y
         Umny/f2JMoLafC0XxMZ+5KvSUZvYuAWHeXcE5fjCRJYb8E3IlWpxYtd3uS0N1q5LDE
         YBRBm5Fo8NtVIvGPzVpE13UCbOm5bUbDlvqO/gQ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.4 459/475] dmaengine: Revert "dmaengine: shdma: Fix runtime PM imbalance on error"
Date:   Thu, 14 Apr 2022 15:14:04 +0200
Message-Id: <20220414110907.902021377@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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
@@ -115,10 +115,8 @@ static dma_cookie_t shdma_tx_submit(stru
 		ret = pm_runtime_get(schan->dev);
 
 		spin_unlock_irq(&schan->chan_lock);
-		if (ret < 0) {
+		if (ret < 0)
 			dev_err(schan->dev, "%s(): GET = %d\n", __func__, ret);
-			pm_runtime_put(schan->dev);
-		}
 
 		pm_runtime_barrier(schan->dev);
 


