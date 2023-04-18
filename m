Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E30446E6254
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbjDRMbz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231574AbjDRMbu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:31:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C201EAF3E
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:31:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C3886313B
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:31:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F859C433EF;
        Tue, 18 Apr 2023 12:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821080;
        bh=5jd+H2qvse9+0T5vZAv2KLu4Yc33gmFKItwqhzT1A0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wSiieC4ltwRQhCEQFspxff1spRpMzrlJLTId+eeBO3XSeRd6S6A4oid6BumeGG0FL
         GzZQ9Ssj1Mw4ICEBHXKsU6rge3P1yCUsa3YxKXMt28nG0QdNs/UIriWBY0D4pntppv
         EIba0M6QP3EQt5e4x30ivvb6wSkCDAfHfBUAWofI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 66/92] efi: sysfb_efi: Add quirk for Lenovo Yoga Book X91F/L
Date:   Tue, 18 Apr 2023 14:21:41 +0200
Message-Id: <20230418120307.132254845@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
References: <20230418120304.658273364@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
index 9ea65611fba0b..fff04d2859765 100644
--- a/arch/x86/kernel/sysfb_efi.c
+++ b/arch/x86/kernel/sysfb_efi.c
@@ -272,6 +272,14 @@ static const struct dmi_system_id efifb_dmi_swap_width_height[] __initconst = {
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



