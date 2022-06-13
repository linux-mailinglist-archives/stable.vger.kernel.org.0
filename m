Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56E3A549146
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381004AbiFMOHn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381187AbiFMOEL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:04:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6AF39154B;
        Mon, 13 Jun 2022 04:38:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 615E1B80EC6;
        Mon, 13 Jun 2022 11:38:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B904FC34114;
        Mon, 13 Jun 2022 11:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120325;
        bh=SCQ+MybIxNDW38P3d6S6zBq1APAMPxcMsTSOrG99vXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aVIh/w353ukDN4qEzTMcK6U9qDNAhtDeOojlk1eSVFgqntac6hY6OOJ9gVwB++cmj
         CJCqefqcjdv1SDjIPtV9INblr7KicufOwGpGtBpmp9tRdpaD8v4l3tJfueMvp97h8V
         BFtmRsNHi8CVzsVaEHBuMZBn7x2/IOAdGXHIwvQE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Chuang <benchuanggli@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.18 312/339] mmc: sdhci-pci-gli: Fix GL9763E runtime PM when the system resumes from suspend
Date:   Mon, 13 Jun 2022 12:12:17 +0200
Message-Id: <20220613094936.215695755@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
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

From: Ben Chuang <benchuanggli@gmail.com>

commit 291e7d52d19f114cad6cbf802f3f19ef12a011f8 upstream.

When the system resumes from suspend (S3 or S4), the power mode is
MMC_POWER_OFF. In this status, gl9763e_runtime_resume() should not enable
PLL. Add a condition to this function to enable PLL only when the power
mode is MMC_POWER_ON.

Fixes: d607667bb8fa (mmc: sdhci-pci-gli: Add runtime PM for GL9763E)
Signed-off-by: Ben Chuang <benchuanggli@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220520114242.150235-1-benchuanggli@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-pci-gli.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/mmc/host/sdhci-pci-gli.c
+++ b/drivers/mmc/host/sdhci-pci-gli.c
@@ -972,6 +972,9 @@ static int gl9763e_runtime_resume(struct
 	struct sdhci_host *host = slot->host;
 	u16 clock;
 
+	if (host->mmc->ios.power_mode != MMC_POWER_ON)
+		return 0;
+
 	clock = sdhci_readw(host, SDHCI_CLOCK_CONTROL);
 
 	clock |= SDHCI_CLOCK_PLL_EN;


