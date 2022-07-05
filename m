Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 530B8566E31
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238000AbiGEMb6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236595AbiGEM0x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:26:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 372F119281;
        Tue,  5 Jul 2022 05:19:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6A8EB817D3;
        Tue,  5 Jul 2022 12:19:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CB6DC341C7;
        Tue,  5 Jul 2022 12:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023559;
        bh=11OHJIBZ3fG8MxkMGl4D4AZSGHT2IQhGDgeosFtCU9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qPpAF5W4JLaf9guefXYU/K1qmhy4F5jbujeNKbduWe2+LbAikVV7mXl944MyqsCQ2
         GHjweCf/WzKPJd4Bqw8s7pMbfIw5Pf9jQINUdhVQcl0ffDHTYVbHyqCRGJQ7pxjJe1
         FLp8U/ftiklTxs9bVwbMbKM7kMuCXVxE00e7pnhQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 083/102] platform/x86: ideapad-laptop: Add allow_v4_dytc module parameter
Date:   Tue,  5 Jul 2022 13:58:49 +0200
Message-Id: <20220705115620.767892150@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit a27a1e35f5c87463ba7c12d5b7d7cbafbefc9213 ]

Add an allow_v4_dytc module parameter to allow users to easily test if
DYTC version 4 platform-profiles work on their laptop.

Fixes: 599482c58ebd ("platform/x86: ideapad-laptop: Add platform support for Ideapad 5 Pro 16ACH6-82L5")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=213297
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20220623115914.103001-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/ideapad-laptop.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 6b472fd431d0..abd0c81d62c4 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -152,6 +152,10 @@ static bool no_bt_rfkill;
 module_param(no_bt_rfkill, bool, 0444);
 MODULE_PARM_DESC(no_bt_rfkill, "No rfkill for bluetooth.");
 
+static bool allow_v4_dytc;
+module_param(allow_v4_dytc, bool, 0444);
+MODULE_PARM_DESC(allow_v4_dytc, "Enable DYTC version 4 platform-profile support.");
+
 /*
  * ACPI Helpers
  */
@@ -907,13 +911,16 @@ static int ideapad_dytc_profile_init(struct ideapad_private *priv)
 
 	dytc_version = (output >> DYTC_QUERY_REV_BIT) & 0xF;
 
-	if (dytc_version < 5) {
-		if (dytc_version < 4 || !dmi_check_system(ideapad_dytc_v4_allow_table)) {
-			dev_info(&priv->platform_device->dev,
-				 "DYTC_VERSION is less than 4 or is not allowed: %d\n",
-				 dytc_version);
-			return -ENODEV;
-		}
+	if (dytc_version < 4) {
+		dev_info(&priv->platform_device->dev, "DYTC_VERSION < 4 is not supported\n");
+		return -ENODEV;
+	}
+
+	if (dytc_version < 5 &&
+	    !(allow_v4_dytc || dmi_check_system(ideapad_dytc_v4_allow_table))) {
+		dev_info(&priv->platform_device->dev,
+			 "DYTC_VERSION 4 support may not work. Pass ideapad_laptop.allow_v4_dytc=Y on the kernel commandline to enable\n");
+		return -ENODEV;
 	}
 
 	priv->dytc = kzalloc(sizeof(*priv->dytc), GFP_KERNEL);
-- 
2.35.1



