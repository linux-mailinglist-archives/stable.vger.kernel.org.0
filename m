Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2FE260A6CB
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232094AbiJXMk2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232303AbiJXMhC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:37:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E1D8994A;
        Mon, 24 Oct 2022 05:06:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D382E612F0;
        Mon, 24 Oct 2022 12:05:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E350CC433C1;
        Mon, 24 Oct 2022 12:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613132;
        bh=urrhEJtct4bcw8a1xS0BclzyA+n+yNouVsNJBzE1OLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zY9mTwZYwgq1EomY6r3eQMa+2znDocgz+/K1hq5N3Sd9EtewKYPUtegt0V6w+GvZ7
         v0h7mhkCIw5MULJUUSDLmeKUPw4HI4atuDY/kWEy8Muk6fF4bJ0acSDYZo9dIndr/3
         dW8G7MIN0BdWWJqm9F76fiv7j9y6Lw4zOufkEDmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenchao Chen <wenchao.chen@unisoc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 020/255] mmc: sdhci-sprd: Fix minimum clock limit
Date:   Mon, 24 Oct 2022 13:28:50 +0200
Message-Id: <20221024113003.109807512@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
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
@@ -295,7 +295,7 @@ static unsigned int sdhci_sprd_get_max_c
 
 static unsigned int sdhci_sprd_get_min_clock(struct sdhci_host *host)
 {
-	return 400000;
+	return 100000;
 }
 
 static void sdhci_sprd_set_uhs_signaling(struct sdhci_host *host,


