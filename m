Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0651858C140
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243821AbiHHB5q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243912AbiHHB4f (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:56:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC91101E5;
        Sun,  7 Aug 2022 18:39:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7077560DF3;
        Mon,  8 Aug 2022 01:39:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EF2DC433D6;
        Mon,  8 Aug 2022 01:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922796;
        bh=Xa6s7LYbZMRUMtcixMwGFLO019BA0YLdj1CCuUTJ8O8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Owmnm62KPWHegWdtwSM3fNwNwNJyARHK+AhZtsYRVr3FPV4uPr6HHwM7d1sDVhe0E
         yDTBtiO4W7lwy1zX69lnCJQV+0mKB6mYDotc19e15wEpxxVvlZ695gCMVhEUQDWGSK
         luuBvemxPgr89GgEBX+NUbfs7Y+8Y/z+CZ2K4vCyPILyYD4GRyLE9MYROOc3MeeC+G
         4oAxsiVUdmzTI7ja04Af26k6JK0WdHB+jzDd+uZvPKOvBTUrnp8YyHcvQyF6lSqM8h
         ldPDRFvPi1MG6LtBX2D+XVsOtM/B/70KGPeJmnC7f6kjNBD95o01D/lG95uy1he+tB
         fH2d4Tmjm8zZA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Manyi Li <limanyi@uniontech.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 08/12] ACPI: PM: save NVS memory for Lenovo G40-45
Date:   Sun,  7 Aug 2022 21:39:38 -0400
Message-Id: <20220808013943.316907-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013943.316907-1-sashal@kernel.org>
References: <20220808013943.316907-1-sashal@kernel.org>
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

From: Manyi Li <limanyi@uniontech.com>

[ Upstream commit 4b7ef7b05afcde44142225c184bf43a0cd9e2178 ]

[821d6f0359b0614792ab8e2fb93b503e25a65079] is to make machines
produced from 2012 to now not saving NVS region to accelerate S3.

But, Lenovo G40-45, a platform released in 2015, still needs NVS memory
saving during S3. A quirk is introduced for this platform.

Signed-off-by: Manyi Li <limanyi@uniontech.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/sleep.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index 7a0af16f86f2..d341908cbd16 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -359,6 +359,14 @@ static const struct dmi_system_id acpisleep_dmi_table[] __initconst = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "80E3"),
 		},
 	},
+	{
+	.callback = init_nvs_save_s3,
+	.ident = "Lenovo G40-45",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "80E1"),
+		},
+	},
 	/*
 	 * https://bugzilla.kernel.org/show_bug.cgi?id=196907
 	 * Some Dell XPS13 9360 cannot do suspend-to-idle using the Low Power
-- 
2.35.1

