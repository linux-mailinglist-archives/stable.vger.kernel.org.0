Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0C95920DE
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240466AbiHNPbq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240472AbiHNPbS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:31:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0367B1AD85;
        Sun, 14 Aug 2022 08:29:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40FE4B80B4D;
        Sun, 14 Aug 2022 15:29:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E261CC43470;
        Sun, 14 Aug 2022 15:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660490973;
        bh=xXQAFQ/1p0AoaeHh21LVzZFWzJxzwfUL99cZqTHOlzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nxns9gPim73McSAJyAZMsHtmZIF3pE+ulCqPPG+bOMAKJt7wMf7AUr/X7MLfk/d5h
         +YdSaqr+APf+vxE053Q6kcyAzZkDXCd+GeuBDoLFtNqOVeV8prMhRShSKPTGZC4lep
         Q34zgUHsHdx3iqxWNOBfRIVWAO4NwuQnl1ayHSZWCx6pMG4UdR4DQiJfTjU5wv036H
         LhJcIlgNL3nqoZfHTaE7pDJVvjNiD8xWwR2GvR9WSYdP+mqySNyT0W7jecuQD30IRW
         N8KAnRf8cPZ2jZkZSDMh/ZEZJ1WpCndVTgpULLV/VNmLIAqBCLVBsepRutzwtypSzA
         2YwBYDG1a5yeA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Henning Schild <henning.schild@siemens.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee@kernel.org>, Sasha Levin <sashal@kernel.org>,
        andy@kernel.org, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 39/64] pinctrl: intel: Check against matching data instead of ACPI companion
Date:   Sun, 14 Aug 2022 11:24:12 -0400
Message-Id: <20220814152437.2374207-39-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814152437.2374207-1-sashal@kernel.org>
References: <20220814152437.2374207-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit c551bd81d198bf1dcd4398d5454acdc0309dbe77 ]

In some cases we may get a platform device that has ACPI companion
which is different to the pin control described in the ACPI tables.
This is primarily happens when device is instantiated by board file.

In order to allow this device being enumerated, refactor
intel_pinctrl_get_soc_data() to check the matching data instead of
ACPI companion.

Reported-by: Henning Schild <henning.schild@siemens.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Henning Schild <henning.schild@siemens.com>
Acked-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/intel/pinctrl-intel.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/pinctrl/intel/pinctrl-intel.c b/drivers/pinctrl/intel/pinctrl-intel.c
index ffc045f7bf00..fd093e36c3a8 100644
--- a/drivers/pinctrl/intel/pinctrl-intel.c
+++ b/drivers/pinctrl/intel/pinctrl-intel.c
@@ -1641,16 +1641,14 @@ EXPORT_SYMBOL_GPL(intel_pinctrl_probe_by_uid);
 
 const struct intel_pinctrl_soc_data *intel_pinctrl_get_soc_data(struct platform_device *pdev)
 {
+	const struct intel_pinctrl_soc_data * const *table;
 	const struct intel_pinctrl_soc_data *data = NULL;
-	const struct intel_pinctrl_soc_data **table;
-	struct acpi_device *adev;
-	unsigned int i;
 
-	adev = ACPI_COMPANION(&pdev->dev);
-	if (adev) {
-		const void *match = device_get_match_data(&pdev->dev);
+	table = device_get_match_data(&pdev->dev);
+	if (table) {
+		struct acpi_device *adev = ACPI_COMPANION(&pdev->dev);
+		unsigned int i;
 
-		table = (const struct intel_pinctrl_soc_data **)match;
 		for (i = 0; table[i]; i++) {
 			if (!strcmp(adev->pnp.unique_id, table[i]->uid)) {
 				data = table[i];
@@ -1664,7 +1662,7 @@ const struct intel_pinctrl_soc_data *intel_pinctrl_get_soc_data(struct platform_
 		if (!id)
 			return ERR_PTR(-ENODEV);
 
-		table = (const struct intel_pinctrl_soc_data **)id->driver_data;
+		table = (const struct intel_pinctrl_soc_data * const *)id->driver_data;
 		data = table[pdev->id];
 	}
 
-- 
2.35.1

