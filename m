Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9916085EE
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbiJVHlY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbiJVHkj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:40:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6DB465001;
        Sat, 22 Oct 2022 00:38:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55B1860ADC;
        Sat, 22 Oct 2022 07:36:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F34CC433D6;
        Sat, 22 Oct 2022 07:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424213;
        bh=lVh1oP4UqEge0pFZJpJr/ff3E2QK73mfpro3qwWesks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OrQbbhfT4vKiJph0qERXFwuqMtIJDbHoo2UYG7koaBzqr4dwLDfTcFJrmFtXH2a3m
         4R5lQG6ysyvNCS57u6EZZMdUO3fQrPvgEQ8UCUxNj+mRD06JxR8aQdsdtQED/f3FiD
         uLrhXd3WY/A6ZG5hYRLUw7l9CAxCcUbyidEb7icw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenchao Chen <wenchao.chen@unisoc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.19 034/717] mmc: sdhci-sprd: Fix minimum clock limit
Date:   Sat, 22 Oct 2022 09:18:33 +0200
Message-Id: <20221022072421.181001786@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -309,7 +309,7 @@ static unsigned int sdhci_sprd_get_max_c
 
 static unsigned int sdhci_sprd_get_min_clock(struct sdhci_host *host)
 {
-	return 400000;
+	return 100000;
 }
 
 static void sdhci_sprd_set_uhs_signaling(struct sdhci_host *host,


