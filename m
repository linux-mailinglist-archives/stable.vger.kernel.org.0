Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92D0158BF2B
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242226AbiHHBgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242257AbiHHBfV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:35:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1390FDF9C;
        Sun,  7 Aug 2022 18:33:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89B9EB80E06;
        Mon,  8 Aug 2022 01:33:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C666C433D7;
        Mon,  8 Aug 2022 01:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922387;
        bh=Sja0o4WT94abP/9yeowwf/8JUqSGSH1x3gwkaizUJp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NNs2i7H3BeDoO+dBCjXdXEQJlIIGN0UDNwnXVGd3ga6vmXkk6EVbwftkCX9KEDQnu
         nnIE537U53YunpF3NvjtG0LuSm/UKJax368CV2ZTgZxG4QEf9qihq4gVm6ESLfLhNv
         jUSMcpYrN6Ccp/odkB127knHhmUFhCGhCEpOqE+lJ9dmTW0hL1A/YHbyEBhFRY1Ewx
         ObV/9JTAuYNS3REH6htjgyZCGlE2xxvswzeSvSGbCDIlXQmyuxGNK2fBuqmhLJJcvp
         FcuQgcHxDJ4SNFuxsIKYlQDVG39H0eL+coIZt1+fYg1So7/mkJk31CMuligU0zHVt/
         ntmRg3PrVpGMw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     huhai <huhai@kylinos.cn>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 40/58] ACPI: LPSS: Fix missing check in register_device_clock()
Date:   Sun,  7 Aug 2022 21:30:58 -0400
Message-Id: <20220808013118.313965-40-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013118.313965-1-sashal@kernel.org>
References: <20220808013118.313965-1-sashal@kernel.org>
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
index fbe0756259c5..c4d4d21391d7 100644
--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -422,6 +422,9 @@ static int register_device_clock(struct acpi_device *adev,
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

