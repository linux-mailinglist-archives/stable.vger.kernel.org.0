Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B71DF58C105
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243617AbiHHB5O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243803AbiHHB4E (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:56:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1CC9F5B2;
        Sun,  7 Aug 2022 18:39:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8975DB80DDF;
        Mon,  8 Aug 2022 01:39:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F1EFC43470;
        Mon,  8 Aug 2022 01:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922773;
        bh=MYOMFbptAUcIePjYdRyu8OSVn7/0hfV7tcqXeEefLR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kv0PsA4B0De6RSarwKziDzfkwMGKnty1r1w4DEI6MVFOzm2sXU26FX6/lL4K6uq9E
         RXwy0Nh7lFZMDqkNZNN4UV8Gh1/C9OwjWnqxQBe1H+YzdC9IUvQwTp9TeYz7SVqtjs
         5rCb6OguR76GkzQ8Sl2DyVy3wDukR9ywpmclqqkdMuSS4YnTdt4LcB1YyauFDGhDX/
         TcGFAuKd9+zcMMX14QaEni81Xjgjk/g5CJdpMt0t9iW0F7GPtDviCJI9YOQIkxxq/w
         gXhe3B7msj7AdAHGzUfACCOlgtBbpGdhSXMA06A0BmBXxU97KNxsC6QGKMji2BrMlk
         rr3zIzAGSOreA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Manyi Li <limanyi@uniontech.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 11/16] ACPI: PM: save NVS memory for Lenovo G40-45
Date:   Sun,  7 Aug 2022 21:39:08 -0400
Message-Id: <20220808013914.316709-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013914.316709-1-sashal@kernel.org>
References: <20220808013914.316709-1-sashal@kernel.org>
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
index 847db3edcb5b..a3b4ac97793f 100644
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

