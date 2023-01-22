Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A15F0676E28
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbjAVPHj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:07:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbjAVPHi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:07:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 693971C320
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:07:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04EC260C5C
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:07:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13104C433EF;
        Sun, 22 Jan 2023 15:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400053;
        bh=yBFlBlRv7098clVsprTs//qaNM14YQ+sRNjZ9XLxRv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=giORIsc4yjuyJmBdmWIpB0tnMGFsEpOKAceO5b6kMh0YqA2oR6ViVxmfiV9MDRRDt
         MsNsSFpDmNd9v2VtdDQaLdW0xme9OXySbsxx/rh3BcyqZYOkRbFGyflF/ilP067Rg6
         duvlnYYJSCsqDe/E+st77NQFI2uKqxGIKkS4Asdk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Samuel Holland <samuel@sholland.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.19 21/37] mmc: sunxi-mmc: Fix clock refcount imbalance during unbind
Date:   Sun, 22 Jan 2023 16:04:18 +0100
Message-Id: <20230122150220.445830257@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150219.557984692@linuxfoundation.org>
References: <20230122150219.557984692@linuxfoundation.org>
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

From: Samuel Holland <samuel@sholland.org>

commit 8509419758f2cc28dd05370385af0d91573b76b4 upstream.

If the controller is suspended by runtime PM, the clock is already
disabled, so do not try to disable it again during removal. Use
pm_runtime_disable() to flush any pending runtime PM transitions.

Fixes: 9a8e1e8cc2c0 ("mmc: sunxi: Add runtime_pm support")
Signed-off-by: Samuel Holland <samuel@sholland.org>
Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220810022509.43743-1-samuel@sholland.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sunxi-mmc.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/mmc/host/sunxi-mmc.c
+++ b/drivers/mmc/host/sunxi-mmc.c
@@ -1441,9 +1441,11 @@ static int sunxi_mmc_remove(struct platf
 	struct sunxi_mmc_host *host = mmc_priv(mmc);
 
 	mmc_remove_host(mmc);
-	pm_runtime_force_suspend(&pdev->dev);
-	disable_irq(host->irq);
-	sunxi_mmc_disable(host);
+	pm_runtime_disable(&pdev->dev);
+	if (!pm_runtime_status_suspended(&pdev->dev)) {
+		disable_irq(host->irq);
+		sunxi_mmc_disable(host);
+	}
 	dma_free_coherent(&pdev->dev, PAGE_SIZE, host->sg_cpu, host->sg_dma);
 	mmc_free_host(mmc);
 


