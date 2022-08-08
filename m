Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 706F558BFB2
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242752AbiHHBme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243095AbiHHBlu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:41:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55E4D13D53;
        Sun,  7 Aug 2022 18:35:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 926B860DDA;
        Mon,  8 Aug 2022 01:35:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49B29C433C1;
        Mon,  8 Aug 2022 01:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922522;
        bh=zhcN5rVttKQpHt0Mnjwy+TDGMAsgje+gQlW+Ph9klbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hXk08HEc9ABK8J0ZKrHcnr5j/ir9zeYHI9GxU9frqjoYBEtbuAUExRzUF3h7632Zw
         dOZwdMdv1msKaSBUmw7kD4Dd5FOJSQ1NW56bIg6IZNgny4Pxny++6QrOh3qu0TKKY7
         +ugvE1INY0eppssxymd8USj7U6KifzuSrgKMZbb0vJlIaY4E1kIfZhlTBJ0UtRxUUw
         WhTCv17inFtAZ9JxI1cDpG+NxzCJDOPECbDWh0Mn90Z2ORVn9KZd37V33w82XrW2XH
         xy529sSpw9XeNVXqkzNCLHY67qvNhceTrZFzA7aAYyqrz6sVe4x6OkH2AKqD/NzxaZ
         ltfvOen0sSobQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Manyi Li <limanyi@uniontech.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 38/53] ACPI: PM: save NVS memory for Lenovo G40-45
Date:   Sun,  7 Aug 2022 21:33:33 -0400
Message-Id: <20220808013350.314757-38-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013350.314757-1-sashal@kernel.org>
References: <20220808013350.314757-1-sashal@kernel.org>
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
index 3147702710af..1ec3238e2cdc 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -360,6 +360,14 @@ static const struct dmi_system_id acpisleep_dmi_table[] __initconst = {
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
 	 * ThinkPad X1 Tablet(2016) cannot do suspend-to-idle using
 	 * the Low Power S0 Idle firmware interface (see
-- 
2.35.1

