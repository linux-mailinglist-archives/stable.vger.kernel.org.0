Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8AF6C19D4
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233133AbjCTPiu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233139AbjCTPi0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:38:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF45E2
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:29:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2596B80EDD
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:29:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FB55C433D2;
        Mon, 20 Mar 2023 15:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679326178;
        bh=d81WpvGHXcAaGO6+jdo5a6M6e5BWfqqEcbhXTx3AZ70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NFGP7rhN8KcdXRlC8jNzIZA4oyAziZ5kGtv6ZEpPnPihBUXD2qcprVh4NvBk1xf/r
         LcFJ/F62BSGULV5qtdP7lThbSD6Jqxlq59RAmPGtOT2Fak+nN4/6AJB6KDvb5zAicG
         73UrSXLA2Wp8p8t4kGiUdsD3wasYJI+WFe9yHpyQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.2 189/211] mmc: sdhci_am654: lower power-on failed message severity
Date:   Mon, 20 Mar 2023 15:55:24 +0100
Message-Id: <20230320145521.434354126@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
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

From: Francesco Dolcini <francesco.dolcini@toradex.com>

commit 11440da77d6020831ee6f9ce4551b545dea789ee upstream.

Lower the power-on failed message severity from warn to info when the
controller does not power-up. It's normal to have this situation when
the SD card slot is empty, therefore we should not warn the user about
it.

Fixes: 7ca0f166f5b2 ("mmc: sdhci_am654: Add workaround for card detect debounce timer")
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230306162751.163369-1-francesco@dolcini.it
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci_am654.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci_am654.c
+++ b/drivers/mmc/host/sdhci_am654.c
@@ -369,7 +369,7 @@ static void sdhci_am654_write_b(struct s
 					MAX_POWER_ON_TIMEOUT, false, host, val,
 					reg);
 		if (ret)
-			dev_warn(mmc_dev(host->mmc), "Power on failed\n");
+			dev_info(mmc_dev(host->mmc), "Power on failed\n");
 	}
 }
 


