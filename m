Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22CBF6D2D66
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 03:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233777AbjDABuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 21:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233991AbjDABt3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 21:49:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E8F1DFA6;
        Fri, 31 Mar 2023 18:46:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 722DE62D1C;
        Sat,  1 Apr 2023 01:45:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62A8C433D2;
        Sat,  1 Apr 2023 01:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680313499;
        bh=1+g7eqLuyOnPiPDUrW+1zFjZb3jUlRhPKvkJOd1CUj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V6a9v6YquCEqE7Lrv6F/7f1A63H0ULkBD4RzAlCkP6eFRPMXgZ8aT7O9iRceG+dvV
         V1XAlbP4U/y3kGkDp1usDYOhkgXo7I4p0V16+ERQNKjttvQ/q1CTLTG3zebFr6xJxK
         A9Ek3i3sm6xXLAtN1v8aB9LPS1GwEvy4/ZiWivnMDEjqB5d1rkrUbKozlqMq41EFxt
         D4+P+phhM1bWd2p3G9ZXiPIYp1opadxccfawxOztLyrTkCPFQKdb4aFuch5umdjIJP
         Gwqe9WONc+kL4b0zYiEHHPN7Vxvpih8g8XtE6p1gsBybbmhoseBv4pJfvWie5f/E9A
         r5ejjs7qTqlZA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org
Subject: [PATCH AUTOSEL 4.14 2/3] efi: sysfb_efi: Add quirk for Lenovo Yoga Book X91F/L
Date:   Fri, 31 Mar 2023 21:44:53 -0400
Message-Id: <20230401014454.3357487-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230401014454.3357487-1-sashal@kernel.org>
References: <20230401014454.3357487-1-sashal@kernel.org>
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

