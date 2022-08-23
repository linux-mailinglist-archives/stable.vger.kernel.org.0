Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44AA159DD35
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353238AbiHWKcv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:32:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355258AbiHWKbd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:31:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 250ECA50EA;
        Tue, 23 Aug 2022 02:06:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90A53B81C65;
        Tue, 23 Aug 2022 09:06:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012F6C433D6;
        Tue, 23 Aug 2022 09:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245595;
        bh=JX/scm5s1L43BX5Rvh5Ctvz41qWO/MzUKa0DMvIFjaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zUN3WvHK0BLSRLn4rGz1uKhHp3a4E24/KJ/Qaz+r2n18KcLMBUXbm+engd8a7U02B
         klmh50+xpM4JxDxxnJv5fsqW2kh+JhtpO675HvMGmMgM4jNwWZ8hJGOCaEshFaCZ1G
         Ua9HISWvdTJkEgXndIQ/HrGG7TnvS9q3D5CEzsbM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 127/287] mmc: sdhci-of-esdhc: Fix refcount leak in esdhc_signal_voltage_switch
Date:   Tue, 23 Aug 2022 10:24:56 +0200
Message-Id: <20220823080104.668629920@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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
index d6cb0f9a3488..77ae23077f56 100644
--- a/drivers/mmc/host/sdhci-of-esdhc.c
+++ b/drivers/mmc/host/sdhci-of-esdhc.c
@@ -704,6 +704,7 @@ static int esdhc_signal_voltage_switch(struct mmc_host *mmc,
 		scfg_node = of_find_matching_node(NULL, scfg_device_ids);
 		if (scfg_node)
 			scfg_base = of_iomap(scfg_node, 0);
+		of_node_put(scfg_node);
 		if (scfg_base) {
 			sdhciovselcr = SDHCIOVSELCR_TGLEN |
 				       SDHCIOVSELCR_VSELVAL;
-- 
2.35.1



