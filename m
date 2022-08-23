Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60EAC59E12A
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357351AbiHWLRT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357633AbiHWLQQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:16:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 977BF25C7D;
        Tue, 23 Aug 2022 02:20:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8964B8105C;
        Tue, 23 Aug 2022 09:20:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 437F0C433D7;
        Tue, 23 Aug 2022 09:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246400;
        bh=01wlZNj0CXFEbxmjQpb3g6MG83l6u3pzxEtYzfvtwcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fh/PXNGqwIypTVjDqm4ziM1CGTUWVzX3hlbiAIvdaK4R56mLRJileEjMxKAqCcadg
         nnoLpnIZpWmeJK9+HYSBpumHzypIaT+mBuqvKm2TFJp2XKjrETl65VVr/tXp6jd83o
         Lz9S+3LTNjJVEWmz1L2aezqUUYFiX7qs4kJVQ5YI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, huhai <huhai@kylinos.cn>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 067/389] ACPI: LPSS: Fix missing check in register_device_clock()
Date:   Tue, 23 Aug 2022 10:22:25 +0200
Message-Id: <20220823080118.413024931@linuxfoundation.org>
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



