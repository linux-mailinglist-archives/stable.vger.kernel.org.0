Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B585758C109
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243623AbiHHB5Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243526AbiHHByO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:54:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6451B7A5;
        Sun,  7 Aug 2022 18:39:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB2F660EE3;
        Mon,  8 Aug 2022 01:39:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 488E6C433B5;
        Mon,  8 Aug 2022 01:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922742;
        bh=01wlZNj0CXFEbxmjQpb3g6MG83l6u3pzxEtYzfvtwcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ABZ/jW1eobz0S0SkPin+uB0Q9iwgqL9ED6YeEe4T2/x4Lek88JUq5hlSFTUIpE8RL
         zK9MJ9TBmwmSw59WbBP1XW4j0sLVWiF5ThJVjlHUwb9sx2hioQ30q+S7aeSTbBghsG
         XVZGQiEK3pzdYv8NFNsQT83ninuxk9t4JHkL4XGzGTRLVHbU+K4RmngKzJiC7ibLbL
         Wpo9akCzwwmGW3NvGQ5jGNYFzqa8UQPP1TDLD09w4VN7HbE1+zHTqOxDDz9eYCs46/
         gCRmpqsd1YoVnKG9fNRntI2zF1nPJjXvJ0+7drebSPbgwtHjK8ssJtOGwl4Z997zPw
         9LEPk7ybdZ0SA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     huhai <huhai@kylinos.cn>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 17/23] ACPI: LPSS: Fix missing check in register_device_clock()
Date:   Sun,  7 Aug 2022 21:38:24 -0400
Message-Id: <20220808013832.316381-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013832.316381-1-sashal@kernel.org>
References: <20220808013832.316381-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: huhai <huhai@kylinos.cn>

[ Upstream commit b4f1f61ed5928b1128e60e38d0dffa16966f06dc ]

register_device_clock() misses a check for platform_device_register_simple().
Add a check to fix it.

Signed-off-by: huhai <huhai@kylinos.cn>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_lpss.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
index 751ed38f2a10..b939a6736d0b 100644
--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -401,6 +401,9 @@ static int register_device_clock(struct acpi_device *adev,
 	if (!lpss_clk_dev)
 		lpt_register_clock_device();
 
+	if (IS_ERR(lpss_clk_dev))
+		return PTR_ERR(lpss_clk_dev);
+
 	clk_data = platform_get_drvdata(lpss_clk_dev);
 	if (!clk_data)
 		return -ENODEV;
-- 
2.35.1

