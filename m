Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4149C6D2D98
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 04:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233722AbjDACJa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 22:09:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233414AbjDACJ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 22:09:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A240210264;
        Fri, 31 Mar 2023 19:09:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7154AB83322;
        Sat,  1 Apr 2023 01:44:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DCF0C433EF;
        Sat,  1 Apr 2023 01:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680313492;
        bh=1+g7eqLuyOnPiPDUrW+1zFjZb3jUlRhPKvkJOd1CUj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BLoyJi11pPvReY8OQz4cjWdvbJVlnGB3lZwaKAwqWcrTolMXlEJ35rNWdXKh0v8D7
         GtiXVh8obuFYEzV3xL1LRXQr8h5/N1RIKwGx1qnxtEx27eFpmHzth4OH/XNqREGAvt
         ye3dDMvjpioLxQ3YikPVdSijzyUaWR0OBZS27w6i93/4GIVIgJaOsKb3/ABWuyTfvo
         DcpEl9PHP9zw6xwvmF5k7iAJxDV/+71zysHTERkzgkELEuswAyh3TJxqtXFgR5C+dC
         HfyS171HiYPDHMnoMof6aHxzYWjVuZFHfQaWgDqAN/EU7YUOfPnWkAIcpOa1W0MSTr
         2VoAQnvsHhuYw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org
Subject: [PATCH AUTOSEL 4.19 3/4] efi: sysfb_efi: Add quirk for Lenovo Yoga Book X91F/L
Date:   Fri, 31 Mar 2023 21:44:43 -0400
Message-Id: <20230401014444.3357427-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230401014444.3357427-1-sashal@kernel.org>
References: <20230401014444.3357427-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 5ed213dd64681f84a01ceaa82fb336cf7d59ddcf ]

Another Lenovo convertable which reports a landscape resolution of
1920x1200 with a pitch of (1920 * 4) bytes, while the actual framebuffer
has a resolution of 1200x1920 with a pitch of (1200 * 4) bytes.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/sysfb_efi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/sysfb_efi.c b/arch/x86/kernel/sysfb_efi.c
index dd8d7636c5420..5bc0fedb33420 100644
--- a/arch/x86/kernel/sysfb_efi.c
+++ b/arch/x86/kernel/sysfb_efi.c
@@ -273,6 +273,14 @@ static const struct dmi_system_id efifb_dmi_swap_width_height[] __initconst = {
 					"IdeaPad Duet 3 10IGL5"),
 		},
 	},
+	{
+		/* Lenovo Yoga Book X91F / X91L */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			/* Non exact match to match F + L versions */
+			DMI_MATCH(DMI_PRODUCT_NAME, "Lenovo YB1-X91"),
+		},
+	},
 	{},
 };
 
-- 
2.39.2

