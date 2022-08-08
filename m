Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B586258C144
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243836AbiHHB5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244054AbiHHB4w (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:56:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED411D8E;
        Sun,  7 Aug 2022 18:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B6FEB80E12;
        Mon,  8 Aug 2022 01:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097CCC433C1;
        Mon,  8 Aug 2022 01:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922813;
        bh=0ie/x+deJNmPPRkTSfSWjW9Y8KhstuhgEtIrW71RO70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AQ3/jfW8Md3lKWjSIcSAnDpwKdW5MvrpMB2Qv3cuu/3IiEomMHJnXur+pB8zIv78T
         /zYT/qbZ5LH/mqjoi/TF+38k0gn2hGn0zKa91lSr4cXWQnew79tDwhsCIJIPfwBAaR
         tauXcIaG/gMtisVTq0f0YCHzJ43LvQhuSnXaav4igu69jkdyH2eboShEsee5UnlFVd
         ZaurasCSpr7XQRqscdrCcx1Btc77mzwaydEmrG5KPSHqUIajgTKgBkX2fw9GA0r3HB
         iZendOVv1S81R3OiUXd9wSUOKteK56uVE8YHdJHxZehO63cqoGbRgMHHXWnvwHns7o
         upoOQZU6u5KFw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     huhai <huhai@kylinos.cn>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 5/8] ACPI: LPSS: Fix missing check in register_device_clock()
Date:   Sun,  7 Aug 2022 21:40:00 -0400
Message-Id: <20220808014005.317064-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808014005.317064-1-sashal@kernel.org>
References: <20220808014005.317064-1-sashal@kernel.org>
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
index a9158858f54c..6ca4b3dc11ca 100644
--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -330,6 +330,9 @@ static int register_device_clock(struct acpi_device *adev,
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

