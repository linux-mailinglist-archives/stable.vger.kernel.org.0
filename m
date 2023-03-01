Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92DFF6A7122
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 17:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbjCAQbl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 11:31:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjCAQbN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 11:31:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2AA41096;
        Wed,  1 Mar 2023 08:30:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91FCCB810C3;
        Wed,  1 Mar 2023 16:30:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 430A6C433D2;
        Wed,  1 Mar 2023 16:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677688225;
        bh=DebMMl5JVaCccNPwj0VWexdoM2ZHUJyfI0s2IbXJf2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dTERKSOApbWzloUujDPfpx/8jXe3E1kZkb1s1ylSKWohXtgj/LMvByCEewzgzuvh7
         Ot6mKviQfG1iBiNT28h7+hnniGWIhWXJfZW2j5odFELKP+MhJpY9Fho406yNOxEpZB
         j7cGw2pCa9uztC7F4RwhuPB0fkTTLSmqPJqz9Y72fli9ajK//JuqVU8/Ddf2rxpOpr
         GLgvenPTaX8TMLnP/h7pB4Ts7duEg6vVJ9CT033Bf0tRlJTRsoeCJXtoVzJkXNwbV7
         SewnD119qVY/g29/6bHKDociL5YXzRsKZOd0/4LBmPqvbtuV888Ms/zuZghcryoFoK
         HZX9ftxcyoq0Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Darrell Kavanagh <darrell.kavanagh@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org
Subject: [PATCH AUTOSEL 4.19 3/3] firmware/efi sysfb_efi: Add quirk for Lenovo IdeaPad Duet 3
Date:   Wed,  1 Mar 2023 11:30:17 -0500
Message-Id: <20230301163017.1303229-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301163017.1303229-1-sashal@kernel.org>
References: <20230301163017.1303229-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darrell Kavanagh <darrell.kavanagh@gmail.com>

[ Upstream commit e1d447157f232c650e6f32c9fb89ff3d0207c69a ]

Another Lenovo convertable which reports a landscape resolution of
1920x1200 with a pitch of (1920 * 4) bytes, while the actual framebuffer
has a resolution of 1200x1920 with a pitch of (1200 * 4) bytes.

Signed-off-by: Darrell Kavanagh <darrell.kavanagh@gmail.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/sysfb_efi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/sysfb_efi.c b/arch/x86/kernel/sysfb_efi.c
index 897da526e40e6..dd8d7636c5420 100644
--- a/arch/x86/kernel/sysfb_efi.c
+++ b/arch/x86/kernel/sysfb_efi.c
@@ -265,6 +265,14 @@ static const struct dmi_system_id efifb_dmi_swap_width_height[] __initconst = {
 					"Lenovo ideapad D330-10IGM"),
 		},
 	},
+	{
+		/* Lenovo IdeaPad Duet 3 10IGL5 with 1200x1920 portrait screen */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_VERSION,
+					"IdeaPad Duet 3 10IGL5"),
+		},
+	},
 	{},
 };
 
-- 
2.39.2

