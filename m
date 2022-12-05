Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A76A6433E4
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234776AbiLETkd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:40:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234708AbiLETkP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:40:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D37D727FFD
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:37:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DB3761315
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:37:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ABE5C433D6;
        Mon,  5 Dec 2022 19:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269046;
        bh=YPrkSZcHmssOwqYPWtHg0dZ5FWUmJQNDA2byJRLUxIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WbZkrkmJTFEN4ekRpiHBXPk8jMPqN10pZRE8j+vGaER9uUprwi15BDDeJX98oPJp+
         NYZXE+sq7VWlSkWs9QQZBJKamR0McM9w346jgFOeT4rG3khmgNBMhPMm6Bx7BmmynA
         TufWSLu2WroBY2qJpx1utpI3x4v0WDSPFJCEogTw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wenchao Chen <wenchao.chen@unisoc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 079/120] mmc: sdhci-sprd: Fix no reset data and command after voltage switch
Date:   Mon,  5 Dec 2022 20:10:19 +0100
Message-Id: <20221205190808.980896827@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenchao Chen <wenchao.chen@unisoc.com>

commit dd30dcfa7a74a06f8dcdab260d8d5adf32f17333 upstream.

After switching the voltage, no reset data and command will cause
CMD2 timeout.

Fixes: 29ca763fc26f ("mmc: sdhci-sprd: Add pin control support for voltage switch")
Signed-off-by: Wenchao Chen <wenchao.chen@unisoc.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221130121328.25553-1-wenchao.chen@unisoc.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-sprd.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci-sprd.c
+++ b/drivers/mmc/host/sdhci-sprd.c
@@ -457,7 +457,7 @@ static int sdhci_sprd_voltage_switch(str
 	}
 
 	if (IS_ERR(sprd_host->pinctrl))
-		return 0;
+		goto reset;
 
 	switch (ios->signal_voltage) {
 	case MMC_SIGNAL_VOLTAGE_180:
@@ -485,6 +485,8 @@ static int sdhci_sprd_voltage_switch(str
 
 	/* Wait for 300 ~ 500 us for pin state stable */
 	usleep_range(300, 500);
+
+reset:
 	sdhci_reset(host, SDHCI_RESET_CMD | SDHCI_RESET_DATA);
 
 	return 0;


