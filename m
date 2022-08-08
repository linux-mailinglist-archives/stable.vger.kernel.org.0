Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2382358C123
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243600AbiHHB53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243801AbiHHB4E (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:56:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84ABEF5A7;
        Sun,  7 Aug 2022 18:39:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22A4E60EB5;
        Mon,  8 Aug 2022 01:39:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAAF4C433D6;
        Mon,  8 Aug 2022 01:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922774;
        bh=a6/dzNLnl3+ueGSUXifc4gcmQx39zUiZ4KE3nKIegv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jKXZjYYw5HagTIead86jMRRb6Qg/oJGjSsku+IkHDKPbsbUso0+xtIQ2w76CA6B2/
         oQa3YiSerwThSE3DbCpyvKecovFUvm7mIXhX6DBpBKZ47HehPZsHyqrXW+q7iT2tlN
         CXCTe+B6TG/t1hQvtoDT5xtm5vXqr67X1ceUT/ipx1wEBMeOvaiCxuWGNb/MMEdFTr
         4EghG4yHY/Z5d5x8CdEXAXkxWpZHqAs7j9NIgp5YShSI74OQrspA7dbirDlfr0fTG1
         T+rmFSDE1zOyPVuio/N4O2tQeGRkgF1o6YD//+HilK4/6XqfXma2xcL10/hX4slCIA
         /unyEMcoUpE5A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     huhai <huhai@kylinos.cn>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 12/16] ACPI: LPSS: Fix missing check in register_device_clock()
Date:   Sun,  7 Aug 2022 21:39:09 -0400
Message-Id: <20220808013914.316709-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013914.316709-1-sashal@kernel.org>
References: <20220808013914.316709-1-sashal@kernel.org>
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
index ded6c5c17fd7..144cda7da7ee 100644
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

