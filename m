Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 733A766C7FA
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233321AbjAPQf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:35:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233312AbjAPQf1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:35:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7CAD30B3D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:23:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 689BAB8107A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:23:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3AFFC433D2;
        Mon, 16 Jan 2023 16:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886196;
        bh=czbWisWp1hjdvbdP5Wy5ZTE3jxfC1ySlUaUoCeFLkfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KJGcgt5hTltjbK/2G1jevGBiejqvs4hDh9VwkNt0HwU6iO7GKFc/SMF5byNyNWM8X
         KjODzLjfVIw2Aykojfs7JtLP8n5kpGScVV+Xi3TKtC+/9SdgsZG2t0qCO90r0X7Wmc
         yX778krMArEra9nnHesRnIO4DqFySrzNbIr6+JNY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 338/658] rtc: rtc-cmos: Do not check ACPI_FADT_LOW_POWER_S0
Date:   Mon, 16 Jan 2023 16:47:06 +0100
Message-Id: <20230116154925.008970200@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 6492fed7d8c95f53b0b804ef541324d924d95d41 ]

The ACPI_FADT_LOW_POWER_S0 flag merely means that it is better to
use low-power S0 idle on the given platform than S3 (provided that
the latter is supported) and it doesn't preclude using either of
them (which of them will be used depends on the choices made by user
space).

For this reason, there is no benefit from checking that flag in
use_acpi_alarm_quirks().

First off, it cannot be a bug to do S3 with use_acpi_alarm set,
because S3 can be used on systems with ACPI_FADT_LOW_POWER_S0 and it
must work if really supported, so the ACPI_FADT_LOW_POWER_S0 check is
not needed to protect the S3-capable systems from failing.

Second, suspend-to-idle can be carried out on a system with
ACPI_FADT_LOW_POWER_S0 unset and it is expected to work, so if setting
use_acpi_alarm is needed to handle that case correctly, it should be
set regardless of the ACPI_FADT_LOW_POWER_S0 value.

Accordingly, drop the ACPI_FADT_LOW_POWER_S0 check from
use_acpi_alarm_quirks().

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/12054246.O9o76ZdvQC@kreacher
Stable-dep-of: 83ebb7b3036d ("rtc: cmos: Disable ACPI RTC event on removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-cmos.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 60271ea2a28d..398b4fb8d934 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -1203,9 +1203,6 @@ static void use_acpi_alarm_quirks(void)
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
 		return;
 
-	if (!(acpi_gbl_FADT.flags & ACPI_FADT_LOW_POWER_S0))
-		return;
-
 	if (!is_hpet_enabled())
 		return;
 
-- 
2.35.1



