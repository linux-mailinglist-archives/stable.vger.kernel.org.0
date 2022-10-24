Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C607060B148
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234011AbiJXQSR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234133AbiJXQQU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:16:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5458A8CD5;
        Mon, 24 Oct 2022 08:03:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71A3CB815C5;
        Mon, 24 Oct 2022 12:18:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE228C4314C;
        Mon, 24 Oct 2022 12:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613887;
        bh=CAaygUI3d5Iwg9TpDcUtziCnjlVX7gq+/9M0cwLO+2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FP/CLo8icwYp7Dvg7a3uJucey3Onu+8XdIcaSXei4vFln+A7e2ObrFuxxM8YWm/Mz
         gPX3fjgANh6Dmjvc5WCkWhVA3ZuMvY0OTM1tgYZuI2uCwRNvsQgGYJBRFU+67Se3M+
         TQOh2KkHTxnAV94jGQnAKo6lWU88oQvt3U2c9cYY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenchao Chen <wenchao.chen@unisoc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 022/390] mmc: sdhci-sprd: Fix minimum clock limit
Date:   Mon, 24 Oct 2022 13:26:59 +0200
Message-Id: <20221024113023.498588550@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenchao Chen <wenchao.chen@unisoc.com>

commit 6e141772e6465f937458b35ddcfd0a981b6f5280 upstream.

The Spreadtrum controller supports 100KHz minimal clock rate, which means
that the current value 400KHz is wrong.

Unfortunately this has also lead to fail to initialize some cards, which
are allowed to require 100KHz to work. So, let's fix the problem by
changing the minimal supported clock rate to 100KHz.

Signed-off-by: Wenchao Chen <wenchao.chen@unisoc.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Fixes: fb8bd90f83c4 ("mmc: sdhci-sprd: Add Spreadtrum's initial host controller")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221011104935.10980-1-wenchao.chen666@gmail.com
[Ulf: Clarified to commit-message]
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-sprd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci-sprd.c
+++ b/drivers/mmc/host/sdhci-sprd.c
@@ -296,7 +296,7 @@ static unsigned int sdhci_sprd_get_max_c
 
 static unsigned int sdhci_sprd_get_min_clock(struct sdhci_host *host)
 {
-	return 400000;
+	return 100000;
 }
 
 static void sdhci_sprd_set_uhs_signaling(struct sdhci_host *host,


