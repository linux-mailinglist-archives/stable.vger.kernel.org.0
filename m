Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8A36583BD
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235106AbiL1QvW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:51:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235064AbiL1QvA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:51:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25999EA3
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:45:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D590AB8188B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:45:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3097DC433EF;
        Wed, 28 Dec 2022 16:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245937;
        bh=SlFOvmMdVICDIUhdLCEFcFnIe5h4iszNQXPFJAN9MsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ulUF3a0OLvV1bGL0bDo1tWAoGEiBmUOeHr8CI/kVPRcw6DJrOp1E/6Zh03diiSbse
         /FP9fgnymEsh/s+b8ZpfrvOLb/YXuncn/ILGfqozBnabZ+hUYZ5UNJR7mULZfuakhr
         LuG7/LSyvZy78SPN/T5G8xoq5JglCXU72m6IJW1s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mia Kanashi <chad@redpilled.dev>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0950/1146] ACPI: EC: Add quirk for the HP Pavilion Gaming 15-cx0041ur
Date:   Wed, 28 Dec 2022 15:41:29 +0100
Message-Id: <20221228144356.122717490@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Mia Kanashi <chad@redpilled.dev>

[ Upstream commit b423f240a66ad928c4cb5ec6055dfc90ce8d894e ]

Added GPE quirk entry for the HP Pavilion Gaming 15-cx0041ur.
There is a quirk entry for the 15-cx0xxx laptops, but this one has
different DMI_PRODUCT_NAME.

Notably backlight keys and other ACPI events now function correctly.

Signed-off-by: Mia Kanashi <chad@redpilled.dev>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/ec.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 9b42628cf21b..9751b84c1b22 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1875,6 +1875,16 @@ static const struct dmi_system_id ec_dmi_table[] __initconst = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion Gaming Laptop 15-cx0xxx"),
 		},
 	},
+	{
+		/*
+		 * HP Pavilion Gaming Laptop 15-cx0041ur
+		 */
+		.callback = ec_honor_dsdt_gpe,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP 15-cx0041ur"),
+		},
+	},
 	{
 		/*
 		 * Samsung hardware
-- 
2.35.1



