Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BDF665D86C
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239594AbjADQOE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:14:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239861AbjADQNc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:13:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D828926E8
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:13:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85BCBB8172E
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:13:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C327DC433D2;
        Wed,  4 Jan 2023 16:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848809;
        bh=CtwM4FknA6rs9U6+h3U1M1otnLVrQRN2QqBkbLSuYQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KBoKlU04KTut8t7oy0g62lSjbiO43W+cMiQit5qpmIqXceRvnYZ0IjWAFPKz2ByX+
         15XEtnxid+mbSbhm9SKV7PAU4Sj8qfsjt1l5CRwahGMmCHIfDOqLHwPQQweIX9BEKA
         1UVKQDMcJC0RjGd3Ib4SPj2+yn4TKFOtsZk4ZO1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 052/207] platform/x86: ideapad-laptop: Stop writing VPCCMD_W_TOUCHPAD at probe time
Date:   Wed,  4 Jan 2023 17:05:10 +0100
Message-Id: <20230104160513.563342360@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit a10ba160d427e78ffa2ab15a86cacaec291fa58a ]

Commit d69cd7eea93e ("platform/x86: ideapad-laptop: Disable touchpad_switch
for ELAN0634") from Janary 2021 added a flag hiding the touchpad sysfs-attr
and disabling ideapad_sync_touchpad_state() because some devices
"do not use EC to switch touchpad".

At the same time this added a write(VPCCMD_W_TOUCHPAD, 1) call at probe
time on these same devices. This seems to be copied from the rfkill code
which does something similar when hw rfkill support is disabled.

But for the rfkill code this is known to be necessary on some models,
where as for the touchpad control no motivation is given for doing this
and prior to this patch there were no reports of needing to do this.

So this seems unnecessary; and it is best to avoid poking the hardware
unnecessary to avoid unwanted side effects, so remove this.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Tested-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Tested-by: Maxim Mikityanskiy <maxtram95@gmail.com>
Link: https://lore.kernel.org/r/20221117110244.67811-6-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/ideapad-laptop.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 9b36cfddd36f..fc3d47a75944 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -1875,10 +1875,6 @@ static int ideapad_acpi_add(struct platform_device *pdev)
 	if (!priv->features.hw_rfkill_switch)
 		write_ec_cmd(priv->adev->handle, VPCCMD_W_RF, 1);
 
-	/* The same for Touchpad */
-	if (!priv->features.touchpad_ctrl_via_ec)
-		write_ec_cmd(priv->adev->handle, VPCCMD_W_TOUCHPAD, 1);
-
 	for (i = 0; i < IDEAPAD_RFKILL_DEV_NUM; i++)
 		if (test_bit(ideapad_rfk_data[i].cfgbit, &priv->cfg))
 			ideapad_register_rfkill(priv, i);
-- 
2.35.1



