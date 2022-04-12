Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 912794FDACA
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235063AbiDLHTQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351615AbiDLHMq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:12:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EC1911A31;
        Mon, 11 Apr 2022 23:50:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BC8D614B0;
        Tue, 12 Apr 2022 06:50:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35ABBC385A6;
        Tue, 12 Apr 2022 06:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746235;
        bh=OTYaN9cEFJk3+s8Bk6TF+yOQ9yew98O3/jc7PDaRvlI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iqw50bkHSTjfVn9ixxyhk6wzpZ2ZsCMTsDpvCOxcUon8LY20rIRWm3zapv2mxpjij
         kO2fzcY4NPsoEZq+Zd6o54PyEy9YpRQIzvtM96hHJd1TLizkU+FU4rN2DprV83bJZB
         MHnwxYlmFCk15P3IKRVdAIn7O0464gTjsQ+Uwj7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 209/277] Revert "mmc: sdhci-xenon: fix annoying 1.8V regulator warning"
Date:   Tue, 12 Apr 2022 08:30:12 +0200
Message-Id: <20220412062948.089189503@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
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

From: Pali Rohár <pali@kernel.org>

commit 7e2646ed47542123168d43916b84b954532e5386 upstream.

This reverts commit bb32e1987bc55ce1db400faf47d85891da3c9b9f.

Commit 1a3ed0dc3594 ("mmc: sdhci-xenon: fix 1.8v regulator stabilization")
contains proper fix for the issue described in commit bb32e1987bc5 ("mmc:
sdhci-xenon: fix annoying 1.8V regulator warning").

Fixes: 8d876bf472db ("mmc: sdhci-xenon: wait 5ms after set 1.8V signal enable")
Cc: stable@vger.kernel.org # 1a3ed0dc3594 ("mmc: sdhci-xenon: fix 1.8v regulator stabilization")
Signed-off-by: Pali Rohár <pali@kernel.org>
Reviewed-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Marcin Wojtas <mw@semihalf.com>
Link: https://lore.kernel.org/r/20220318141441.32329-1-pali@kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-xenon.c |   10 ----------
 1 file changed, 10 deletions(-)

--- a/drivers/mmc/host/sdhci-xenon.c
+++ b/drivers/mmc/host/sdhci-xenon.c
@@ -241,16 +241,6 @@ static void xenon_voltage_switch(struct
 {
 	/* Wait for 5ms after set 1.8V signal enable bit */
 	usleep_range(5000, 5500);
-
-	/*
-	 * For some reason the controller's Host Control2 register reports
-	 * the bit representing 1.8V signaling as 0 when read after it was
-	 * written as 1. Subsequent read reports 1.
-	 *
-	 * Since this may cause some issues, do an empty read of the Host
-	 * Control2 register here to circumvent this.
-	 */
-	sdhci_readw(host, SDHCI_HOST_CONTROL2);
 }
 
 static unsigned int xenon_get_max_clock(struct sdhci_host *host)


