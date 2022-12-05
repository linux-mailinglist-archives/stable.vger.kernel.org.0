Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7DC6433E3
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233781AbiLETkc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:40:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234508AbiLETkP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:40:15 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909A927DE2
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:37:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 07723CE139F
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:37:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50552C433C1;
        Mon,  5 Dec 2022 19:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269044;
        bh=Og3sb0viEqRWaWK0WFwZsDrDYpdxmoLHvHK+7iBiZco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qn4g6ii/8rKmnzcvd2eJXB8yEKEmbZtmzG9zOXjdmP1+f/5TyEVrbCdczLORkZeGg
         LysjtAGcbFW6Lduu/GsK9HmL81hAH5TfmX4hMuJQ8VPM6o6mn2ZHOWmMk5TWwBzq//
         Vn2q0op9i8krooLAe2rx/KxAtwL4knZfH2DjFZZ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Sebastian Falbesoner <sebastian.falbesoner@gmail.com>,
        Haibo Chen <haibo.chen@nxp.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 078/120] mmc: sdhci-esdhc-imx: correct CQHCI exit halt state check
Date:   Mon,  5 Dec 2022 20:10:18 +0100
Message-Id: <20221205190808.953930613@linuxfoundation.org>
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

From: Sebastian Falbesoner <sebastian.falbesoner@gmail.com>

commit a3cab1d2132474969871b5d7f915c5c0167b48b0 upstream.

With the current logic the "failed to exit halt state" error would be
shown even if any other bit than CQHCI_HALT was set in the CQHCI_CTL
register, since the right hand side is always true. Fix this by using
the correct operator (bit-wise instead of logical AND) to only check for
the halt bit flag, which was obviously intended here.

Fixes: 85236d2be844 ("mmc: sdhci-esdhc-imx: clear the HALT bit when enable CQE")
Signed-off-by: Sebastian Falbesoner <sebastian.falbesoner@gmail.com>
Acked-by: Haibo Chen <haibo.chen@nxp.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221121105721.1903878-1-sebastian.falbesoner@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-esdhc-imx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -1495,7 +1495,7 @@ static void esdhc_cqe_enable(struct mmc_
 	 * system resume back.
 	 */
 	cqhci_writel(cq_host, 0, CQHCI_CTL);
-	if (cqhci_readl(cq_host, CQHCI_CTL) && CQHCI_HALT)
+	if (cqhci_readl(cq_host, CQHCI_CTL) & CQHCI_HALT)
 		dev_err(mmc_dev(host->mmc),
 			"failed to exit halt state when enable CQE\n");
 


