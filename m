Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA34C4AFD77
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 20:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233176AbiBIT1b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 14:27:31 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:47006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234327AbiBIT0r (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 14:26:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72AB7E00E266;
        Wed,  9 Feb 2022 11:19:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A180B8238D;
        Wed,  9 Feb 2022 19:15:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A48C340E7;
        Wed,  9 Feb 2022 19:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644434100;
        bh=dCxPR4JBeSv02HURTnL42udmBp2yb2pJ1Ew0FokUAEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zwE9JROxVTYQOo5PkARElkaSznCXNHyGVg3VjEtiNGl1HxJ4Fq8nsFP4xZerAvBN9
         Ocn2OiF9JilSnRl05REjzCniWQPsxtdJYqUE2xj64fAyKPWn0m7f/1PmeOmB7FDMA9
         plHbVrjJa7zaaAhnheXS5KIw3hbUWCkZEKZFHpto=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Xiong <xiongx18@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Yang Li <yang.lee@linux.alibaba.com>,
        linux-mmc@vger.kernel.org, whitehat002 <hackyzh002@gmail.com>
Subject: [PATCH 4.14 2/3] moxart: fix potential use-after-free on remove path
Date:   Wed,  9 Feb 2022 20:13:39 +0100
Message-Id: <20220209191248.739254160@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220209191248.659458918@linuxfoundation.org>
References: <20220209191248.659458918@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit bd2db32e7c3e35bd4d9b8bbff689434a50893546 upstream.

It was reported that the mmc host structure could be accessed after it
was freed in moxart_remove(), so fix this by saving the base register of
the device and using it instead of the pointer dereference.

Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc: Xin Xiong <xiongx18@fudan.edu.cn>
Cc: Xin Tan <tanxin.ctf@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Yang Li <yang.lee@linux.alibaba.com>
Cc: linux-mmc@vger.kernel.org
Cc: stable <stable@vger.kernel.org>
Reported-by: whitehat002 <hackyzh002@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/r/20220127071638.4057899-1-gregkh@linuxfoundation.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/moxart-mmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/moxart-mmc.c
+++ b/drivers/mmc/host/moxart-mmc.c
@@ -696,12 +696,12 @@ static int moxart_remove(struct platform
 		if (!IS_ERR(host->dma_chan_rx))
 			dma_release_channel(host->dma_chan_rx);
 		mmc_remove_host(mmc);
-		mmc_free_host(mmc);
 
 		writel(0, host->base + REG_INTERRUPT_MASK);
 		writel(0, host->base + REG_POWER_CONTROL);
 		writel(readl(host->base + REG_CLOCK_CONTROL) | CLK_OFF,
 		       host->base + REG_CLOCK_CONTROL);
+		mmc_free_host(mmc);
 	}
 	return 0;
 }


