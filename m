Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C17F06A7112
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 17:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbjCAQbJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 11:31:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbjCAQac (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 11:30:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09E08497FB;
        Wed,  1 Mar 2023 08:30:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9C4061378;
        Wed,  1 Mar 2023 16:30:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 208C2C433D2;
        Wed,  1 Mar 2023 16:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677688205;
        bh=tgeLc7UXDEzXXhY1MdmXH1yOGMjkSL8ZA45eJlQ2DBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KqJga284JNk9cWHy4kXRC9UfFVEn/W+n2CSz0ZL1fUk3gmvBle3Bi37zEBBe/ihhG
         lUAcFagMXJ1ZuWqWRl8n72dBcChXjyPrF2LZc1mME1uHsQ1vCdE/pKBh+dbXqk5MKQ
         2gcsbBkeA1wR7QnpPdFc3PHF1e7gAUKhfOyP+X0x/7ufyvBdqHsCSDKF3E60kLkvgE
         CJzSOG3obMDhYZnYIVFgTgVXPqDl4EUShB4e3UgzX7oqsSrhrfC6T/7Ul24Vft4hMR
         e6z4dcaE2FT2mMssTf5YJ9a5GQIvRLHJ7JnYFdwydsXZaLehHLrocuUHXy7NNw+fbG
         2ndVBnEzGV6eg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Darrell Kavanagh <darrell.kavanagh@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org
Subject: [PATCH AUTOSEL 5.10 3/5] firmware/efi sysfb_efi: Add quirk for Lenovo IdeaPad Duet 3
Date:   Wed,  1 Mar 2023 11:29:55 -0500
Message-Id: <20230301162957.1303086-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301162957.1303086-1-sashal@kernel.org>
References: <20230301162957.1303086-1-sashal@kernel.org>
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
index 653b7f617b61b..9ea65611fba0b 100644
--- a/arch/x86/kernel/sysfb_efi.c
+++ b/arch/x86/kernel/sysfb_efi.c
@@ -264,6 +264,14 @@ static const struct dmi_system_id efifb_dmi_swap_width_height[] __initconst = {
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

