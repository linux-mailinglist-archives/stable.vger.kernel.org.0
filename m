Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2F65A69BA
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 19:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbiH3RWl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 13:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbiH3RVo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 13:21:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C4306412;
        Tue, 30 Aug 2022 10:20:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1A8E6177A;
        Tue, 30 Aug 2022 17:20:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75301C433C1;
        Tue, 30 Aug 2022 17:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661880030;
        bh=IFikoIwYMuGHOCmiTtW6rEfGuDE6Jp7sFedtFiowjxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=efTmyBNJymoW/F/EGyM81z3aydLhcXtqRxw8ZSxlPdUw3N+yUJ5ZJI26YT2CCrHp+
         qFhqOwotQ7Jfd/6c9GhxSygbxc8YoPdvhYm1w5QWbk/5E9diMoazbTl7ZoP+X/ypRH
         T0MhOsC33IDR2mnjik5KVXvy4UiqlV78rKveZfdiJ6FhUaFgg+BgibTNqNDFY/TiVW
         66lZf8+lt37pLl80O33BPFUM3JtxNfF5Obgqv9L4zP6FvWk9ohnwWKPR1IbkRG4ixG
         lbOwQBhIlX6C0zN5IdTOBEBkrSV4TffafouRStnJT3Pm5cV5pQijSG3ZS5/iZDu7FS
         VSkyTQ4boLssg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        "Lee, Chun-Yi" <jlee@suse.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        daniel.lezcano@linaro.org, srinivas.pandruvada@linux.intel.com,
        rui.zhang@intel.com, dave@stgolabs.net,
        sumeet.r.pawnikar@intel.com, chuansheng.liu@intel.com,
        keescook@chromium.org, dan.carpenter@oracle.com,
        linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 22/33] thermal/int340x_thermal: handle data_vault when the value is ZERO_SIZE_PTR
Date:   Tue, 30 Aug 2022 13:18:13 -0400
Message-Id: <20220830171825.580603-22-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220830171825.580603-1-sashal@kernel.org>
References: <20220830171825.580603-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>

[ Upstream commit 7931e28098a4c1a2a6802510b0cbe57546d2049d ]

In some case, the GDDV returns a package with a buffer which has
zero length. It causes that kmemdup() returns ZERO_SIZE_PTR (0x10).

Then the data_vault_read() got NULL point dereference problem when
accessing the 0x10 value in data_vault.

[   71.024560] BUG: kernel NULL pointer dereference, address:
0000000000000010

This patch uses ZERO_OR_NULL_PTR() for checking ZERO_SIZE_PTR or
NULL value in data_vault.

Signed-off-by: "Lee, Chun-Yi" <jlee@suse.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/intel/int340x_thermal/int3400_thermal.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
index 80d4e0676083a..365489bf4b8c1 100644
--- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
@@ -527,7 +527,7 @@ static void int3400_setup_gddv(struct int3400_thermal_priv *priv)
 	priv->data_vault = kmemdup(obj->package.elements[0].buffer.pointer,
 				   obj->package.elements[0].buffer.length,
 				   GFP_KERNEL);
-	if (!priv->data_vault)
+	if (ZERO_OR_NULL_PTR(priv->data_vault))
 		goto out_free;
 
 	bin_attr_data_vault.private = priv->data_vault;
@@ -597,7 +597,7 @@ static int int3400_thermal_probe(struct platform_device *pdev)
 			goto free_imok;
 	}
 
-	if (priv->data_vault) {
+	if (!ZERO_OR_NULL_PTR(priv->data_vault)) {
 		result = sysfs_create_group(&pdev->dev.kobj,
 					    &data_attribute_group);
 		if (result)
@@ -615,7 +615,8 @@ static int int3400_thermal_probe(struct platform_device *pdev)
 free_sysfs:
 	cleanup_odvp(priv);
 	if (priv->data_vault) {
-		sysfs_remove_group(&pdev->dev.kobj, &data_attribute_group);
+		if (!ZERO_OR_NULL_PTR(priv->data_vault))
+			sysfs_remove_group(&pdev->dev.kobj, &data_attribute_group);
 		kfree(priv->data_vault);
 	}
 free_uuid:
@@ -647,7 +648,7 @@ static int int3400_thermal_remove(struct platform_device *pdev)
 	if (!priv->rel_misc_dev_res)
 		acpi_thermal_rel_misc_device_remove(priv->adev->handle);
 
-	if (priv->data_vault)
+	if (!ZERO_OR_NULL_PTR(priv->data_vault))
 		sysfs_remove_group(&pdev->dev.kobj, &data_attribute_group);
 	sysfs_remove_group(&pdev->dev.kobj, &uuid_attribute_group);
 	sysfs_remove_group(&pdev->dev.kobj, &imok_attribute_group);
-- 
2.35.1

