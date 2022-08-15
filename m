Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C545E594D09
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352771AbiHPAYM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357429AbiHPAWj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:22:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8674A17CF81;
        Mon, 15 Aug 2022 13:33:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B938B81197;
        Mon, 15 Aug 2022 20:33:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7E2C43470;
        Mon, 15 Aug 2022 20:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595618;
        bh=SY2E2wXYD56yvEtvgGm7t9vW1KbZ8dTo7tvk4SOguHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BEACWF9pR9EW/kcyc0GV+a6Qvm/BHGwWfq2DCfeJ3II369EFg4Frx3CApN/U6z+nU
         wv+IdEXmRjnAk+Ez41eWxASeEwMwEIXNi8U2KfFIhvHn8Bmc3Fwyw7J7GO/PaCXc8C
         6Ayvb9c1Cfd4kIDFBVtlTQig+sl9mG8fPGdV+iEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0794/1157] mmc: sdhci-of-esdhc: Fix refcount leak in esdhc_signal_voltage_switch
Date:   Mon, 15 Aug 2022 20:02:30 +0200
Message-Id: <20220815180511.245407404@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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



