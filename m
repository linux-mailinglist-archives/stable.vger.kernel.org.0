Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE65F66C1BE
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbjAPOO4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:14:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232502AbjAPONr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:13:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3852332C;
        Mon, 16 Jan 2023 06:05:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05DF3B80F9B;
        Mon, 16 Jan 2023 14:05:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6967AC4339C;
        Mon, 16 Jan 2023 14:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877905;
        bh=IzuufyDbJLXhFSsDSZlIOGlXoHOFnZTOQwcthzc3Pi4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sBjxKqvHq7xELSDb74X1xg2l0FoWRzHL0Mt2PlbrdYtvZxaDbroDskOEbFEafnoQH
         NBMupeya33qV4Ltr6gQvLdJgZqJ9w/UfISuNwtICT8zUIEr5lrEvXJ4dHdi7RomioP
         +73sZp5AxrEt9q6duNRcGRSwNV28cp3lwP5qF4gFfMb807KqBKjZaZysr/xwnOsNqJ
         pV4hq7fxaJM/1VkLwYLgCabr5maa4ma2FjSSXhhQiimsDej2rTREk0MNdt++GGncHb
         ZUY4HySiGCA3J5l24y4GsZvlOWopcqG3oiNerh0oeCT/bgTr+l4fLD2xSCbNuNyjVG
         Bq32tfqNT5OXA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miles Chen <miles.chen@mediatek.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>, andrew@lunn.ch,
        gregory.clement@bootlin.com, sebastian.hesselbarth@gmail.com,
        rafael@kernel.org, matthias.bgg@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 08/17] cpufreq: armada-37xx: stop using 0 as NULL pointer
Date:   Mon, 16 Jan 2023 09:04:39 -0500
Message-Id: <20230116140448.116034-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140448.116034-1-sashal@kernel.org>
References: <20230116140448.116034-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miles Chen <miles.chen@mediatek.com>

[ Upstream commit 08f0adb193c008de640fde34a2e00a666c01d77c ]

Use NULL for NULL pointer to fix the following sparse warning:
drivers/cpufreq/armada-37xx-cpufreq.c:448:32: sparse: warning: Using plain integer as NULL pointer

Signed-off-by: Miles Chen <miles.chen@mediatek.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/armada-37xx-cpufreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/armada-37xx-cpufreq.c b/drivers/cpufreq/armada-37xx-cpufreq.c
index 2de7fd18f66a..f0be8a43ec49 100644
--- a/drivers/cpufreq/armada-37xx-cpufreq.c
+++ b/drivers/cpufreq/armada-37xx-cpufreq.c
@@ -443,7 +443,7 @@ static int __init armada37xx_cpufreq_driver_init(void)
 		return -ENODEV;
 	}
 
-	clk = clk_get(cpu_dev, 0);
+	clk = clk_get(cpu_dev, NULL);
 	if (IS_ERR(clk)) {
 		dev_err(cpu_dev, "Cannot get clock for CPU0\n");
 		return PTR_ERR(clk);
-- 
2.35.1

