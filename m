Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5BC58C04B
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243143AbiHHBtq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243154AbiHHBtK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:49:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72FD017E00;
        Sun,  7 Aug 2022 18:37:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0557E60E65;
        Mon,  8 Aug 2022 01:37:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95DFFC43470;
        Mon,  8 Aug 2022 01:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922632;
        bh=K5ZHDwywZf6sEzoMUCgypmRbTxPVUltpevV5pX0h7J4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QE79Wda8IxWlGvERMcueJIQ4pz9yAVKgeDUspynQluWZ3NakZbQ5mmknClwh3WTIU
         MGtrWclElXr/kHTNdLFFtpIm4gckJRBPsZTA/DjUrX6kk9awVXCehDs8bkqR7a1RAv
         okblRV34kmXp3Ms+Q6aEFyOAPn8pnzBZmRL/+l0rGtDB0Oa8ObVhNsav8sNH1oVRpg
         BMK0QkzRzTM0wB+62RjwZiuScCV7BetoJIgqfQhBbWvtyA6vEA00ZvcKUAd+kHYz46
         bAqWNcMfEkg1fqabJeD2ZgRnmXAcdN40Gi/+xrnyH9niLw+aQ4Crdl3iQNlkKJBqsL
         N0mZPzYXMp10g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Manyi Li <limanyi@uniontech.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 32/45] ACPI: PM: save NVS memory for Lenovo G40-45
Date:   Sun,  7 Aug 2022 21:35:36 -0400
Message-Id: <20220808013551.315446-32-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013551.315446-1-sashal@kernel.org>
References: <20220808013551.315446-1-sashal@kernel.org>
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
index 07515139141e..d7194047d256 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -361,6 +361,14 @@ static const struct dmi_system_id acpisleep_dmi_table[] __initconst = {
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

