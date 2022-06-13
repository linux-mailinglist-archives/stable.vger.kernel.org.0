Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF46A549734
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377470AbiFMNdB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378166AbiFMNa5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:30:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26786F4AD;
        Mon, 13 Jun 2022 04:25:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20964B80D3A;
        Mon, 13 Jun 2022 11:25:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80947C385A9;
        Mon, 13 Jun 2022 11:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119542;
        bh=iEkaNM5GFtw73VWBfMqoguXgWeUVCat7JftniUDJRYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XKH2BN/YmwYBWamx2/osQZmXPLDe1l+gbB/9dfYM4kcCNXGFF0+mAQMydQHHNAGhC
         ZChqdqt+3dxMf8M8x3qoqOY6VKPALZdq6wvBRNZRmxIIxyn5CTJ4HLDhzEV78fvmDU
         EoZ5QzL0RH5iYvliuCJY1p8GnkwNaw4iTWcgqmDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 043/339] power: supply: axp288_fuel_gauge: Drop BIOS version check from "T3 MRD" DMI quirk
Date:   Mon, 13 Jun 2022 12:07:48 +0200
Message-Id: <20220613094927.827304042@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit f61509a6f0b70f5bedea34efaf8065621689bd7a ]

Some "T3 MRD" mini-PCs / HDMI-sticks without a battery use a different
value then "5.11" for their DMI BIOS version field.

Drop the BIOS version check so that the no-battery "T3 MRD" DMI quirk
applies to these too.

Fixes: 3a06b912a5ce ("power: supply: axp288_fuel_gauge: Make "T3 MRD" no_battery_list DMI entry more generic")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/axp288_fuel_gauge.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/power/supply/axp288_fuel_gauge.c b/drivers/power/supply/axp288_fuel_gauge.c
index 5b8aa4a980cd..8e6f8a655079 100644
--- a/drivers/power/supply/axp288_fuel_gauge.c
+++ b/drivers/power/supply/axp288_fuel_gauge.c
@@ -609,7 +609,6 @@ static const struct dmi_system_id axp288_quirks[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "T3 MRD"),
 			DMI_MATCH(DMI_CHASSIS_TYPE, "3"),
 			DMI_MATCH(DMI_BIOS_VENDOR, "American Megatrends Inc."),
-			DMI_MATCH(DMI_BIOS_VERSION, "5.11"),
 		},
 		.driver_data = (void *)AXP288_QUIRK_NO_BATTERY,
 	},
-- 
2.35.1



