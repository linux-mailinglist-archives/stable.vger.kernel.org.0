Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D47D45944B5
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344615AbiHOWCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348239AbiHOWBK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:01:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C53994E61D;
        Mon, 15 Aug 2022 12:35:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D4316111E;
        Mon, 15 Aug 2022 19:35:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A24EC433C1;
        Mon, 15 Aug 2022 19:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592141;
        bh=SY2E2wXYD56yvEtvgGm7t9vW1KbZ8dTo7tvk4SOguHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ovMfJUecB1geD2fFrUq1r9iNGL0Y7tyz+rZ/JGjI2KfOmwZHAuQnOjes5jCJk+XYC
         4ShuTTm0+ZyM11OL1yufx2ME+2hNQHKqmFZgClRgSoiNX9wsuO3CZfY4Na2PnWF+hU
         MABX8I4nL5QYjOriGWEOeqWOq38funG8D1cpVorU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0740/1095] mmc: sdhci-of-esdhc: Fix refcount leak in esdhc_signal_voltage_switch
Date:   Mon, 15 Aug 2022 20:02:19 +0200
Message-Id: <20220815180459.996945325@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
index d9dc41143bb3..8b3d8119f388 100644
--- a/drivers/mmc/host/sdhci-of-esdhc.c
+++ b/drivers/mmc/host/sdhci-of-esdhc.c
@@ -904,6 +904,7 @@ static int esdhc_signal_voltage_switch(struct mmc_host *mmc,
 		scfg_node = of_find_matching_node(NULL, scfg_device_ids);
 		if (scfg_node)
 			scfg_base = of_iomap(scfg_node, 0);
+		of_node_put(scfg_node);
 		if (scfg_base) {
 			sdhciovselcr = SDHCIOVSELCR_TGLEN |
 				       SDHCIOVSELCR_VSELVAL;
-- 
2.35.1



