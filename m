Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 939ED5936E1
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232909AbiHOS3m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242438AbiHOS2m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:28:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CBCFB9E;
        Mon, 15 Aug 2022 11:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCF1660EF0;
        Mon, 15 Aug 2022 18:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FB46C433D7;
        Mon, 15 Aug 2022 18:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587615;
        bh=h/3vNwF2fZo2vYAizALpNh0m0PgJAAUekHj5HiG8gUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K0fCkzWN+Z6VPjSjvCp3sMiwOxA9O2teIDZitw8MQ1bn+SXoN1aBlGZBWkWptDcxz
         NQXBu/tHisYCn7sjW2PL0QEvQY4aB71L/h1CyOvnbrufaOZrVzkGhxDdMOF+TUx32Y
         z95Dq7vbmH3yXnQFv4qo8qtvAIauXdnOINwL3sj4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, huhai <huhai@kylinos.cn>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 139/779] ACPI: LPSS: Fix missing check in register_device_clock()
Date:   Mon, 15 Aug 2022 19:56:23 +0200
Message-Id: <20220815180343.249574416@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
index 30b1f511c2af..f609f9d62efd 100644
--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -403,6 +403,9 @@ static int register_device_clock(struct acpi_device *adev,
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



