Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41CF766C0FB
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbjAPOGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:06:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231766AbjAPOFR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:05:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D11233F3;
        Mon, 16 Jan 2023 06:03:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9127B80E93;
        Mon, 16 Jan 2023 14:03:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 467E9C433EF;
        Mon, 16 Jan 2023 14:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877797;
        bh=vzGU7fggFYdTM/Yz8WBo94uwKocZoX7eVhfAfkKbvRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cSJFOyD0U/8NUKLfczffwrD458xnjyQImChDno+1T6qLYpUhD6FXA7ql9o5f1ISlK
         qy3RiIW/wNk6B5XIFhGGruOB2aYvEwdTd5ANOjDdfVpxsIa/7Yg52+RVdW/UbJ9xdM
         23L3Nw0cMiEQ7lvO48RV5uFHvTsPM/ad9pHcQFk/X/bRT/JIUaIC79CrJkatMrilJ/
         1RJfibmzy5m8maqAEA+jm7YM78/TThv7kFFtpUgx3eMLZ59Y8tYlLr48W/SQaEM2IA
         93MLC3HqEklTAPHF+BrcGqHVKvodT9f3GjVNdH94nlGNw92HebUIou36p1kLDM/ecZ
         HW7C3+iv/JiSA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miles Chen <miles.chen@mediatek.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>, andrew@lunn.ch,
        gregory.clement@bootlin.com, sebastian.hesselbarth@gmail.com,
        rafael@kernel.org, matthias.bgg@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 6.1 31/53] cpufreq: armada-37xx: stop using 0 as NULL pointer
Date:   Mon, 16 Jan 2023 09:01:31 -0500
Message-Id: <20230116140154.114951-31-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140154.114951-1-sashal@kernel.org>
References: <20230116140154.114951-1-sashal@kernel.org>
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
index c10fc33b29b1..b74289a95a17 100644
--- a/drivers/cpufreq/armada-37xx-cpufreq.c
+++ b/drivers/cpufreq/armada-37xx-cpufreq.c
@@ -445,7 +445,7 @@ static int __init armada37xx_cpufreq_driver_init(void)
 		return -ENODEV;
 	}
 
-	clk = clk_get(cpu_dev, 0);
+	clk = clk_get(cpu_dev, NULL);
 	if (IS_ERR(clk)) {
 		dev_err(cpu_dev, "Cannot get clock for CPU0\n");
 		return PTR_ERR(clk);
-- 
2.35.1

