Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4F4159DF92
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241501AbiHWL1y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:27:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357676AbiHWL0i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:26:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0763BFE81;
        Tue, 23 Aug 2022 02:24:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94108B81C86;
        Tue, 23 Aug 2022 09:24:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C625FC433C1;
        Tue, 23 Aug 2022 09:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246654;
        bh=BsiNkFf8a+ud4pJ0SB7cr/5NOTD3WmS0vMiFC0bRA84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EVF6wkeXchpJ0tpZX/TdrOJvvZY7AdtIRCpQSqZp2wgaekQM1xQIN5sX/knKI0mOs
         R0rollJRtK3SZN5zWYhKVY/SjGk6Wy/9Ly+blkhea+OjGfr78iw/qN+hm8ob2Jr1jx
         3KmDMKRZRJQhJv0hx+OjupVgylkU1WoW2N3AqmpI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 178/389] mmc: sdhci-of-esdhc: Fix refcount leak in esdhc_signal_voltage_switch
Date:   Tue, 23 Aug 2022 10:24:16 +0200
Message-Id: <20220823080123.076834713@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit b5899a3e2f783a27b268e38d37f9b24c71bddf45 ]

of_find_matching_node() returns a node pointer with refcount
incremented, we should use of_node_put() on it when not need anymore.
Add missing of_node_put() to avoid refcount leak.
of_node_put() checks null pointer.

Fixes: ea35645a3c66 ("mmc: sdhci-of-esdhc: add support for signal voltage switch")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220523144255.10310-1-linmq006@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-of-esdhc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/sdhci-of-esdhc.c b/drivers/mmc/host/sdhci-of-esdhc.c
index 0ff339004d8a..69c133e7ced0 100644
--- a/drivers/mmc/host/sdhci-of-esdhc.c
+++ b/drivers/mmc/host/sdhci-of-esdhc.c
@@ -844,6 +844,7 @@ static int esdhc_signal_voltage_switch(struct mmc_host *mmc,
 		scfg_node = of_find_matching_node(NULL, scfg_device_ids);
 		if (scfg_node)
 			scfg_base = of_iomap(scfg_node, 0);
+		of_node_put(scfg_node);
 		if (scfg_base) {
 			sdhciovselcr = SDHCIOVSELCR_TGLEN |
 				       SDHCIOVSELCR_VSELVAL;
-- 
2.35.1



