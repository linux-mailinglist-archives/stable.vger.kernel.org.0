Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADC156D2D25
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 03:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233891AbjDABqa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 21:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231213AbjDABp6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 21:45:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA0F25446;
        Fri, 31 Mar 2023 18:44:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80849B8330C;
        Sat,  1 Apr 2023 01:43:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B12C433EF;
        Sat,  1 Apr 2023 01:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680313379;
        bh=x5wyPMzvshtOqGQQDm3KVUPh6zsQSerG4WW+h3kXnMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MHLCcSIkN0lw/WcAabf67cUWUzxP+18mvyiix3TnFqh0abrHy+NvdDBD3sH0SctTA
         WsWOAWG8mvd6LOGfAmvkpPaw69VX4CWlqlqGzTa34BBff164uppHJmCzQcGilbm/8h
         TOH/dKkfJdLXGAlhjSYHt1mymYnY/a9e7moi6ifRHQNvdUIYyI31EeZeVEYd4zFzUC
         etxyn6U+tppbHm6PkGk9j/r3ZfFIErlU6anFmXuKYAS7bYIksolIyZg4zBC8lCpp7Z
         zRcZEJSQtUiv9ASROFb2wetzb86VQS8TDRXzXxq2s6rTib0lqW4pUYbKzf696tC7r0
         9x7ErNxK57aTg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-efi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 10/24] efi: sysfb_efi: Add quirk for Lenovo Yoga Book X91F/L
Date:   Fri, 31 Mar 2023 21:42:26 -0400
Message-Id: <20230401014242.3356780-10-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230401014242.3356780-1-sashal@kernel.org>
References: <20230401014242.3356780-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
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
 drivers/firmware/efi/sysfb_efi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/firmware/efi/sysfb_efi.c b/drivers/firmware/efi/sysfb_efi.c
index e76d6803bdd08..456d0e5eaf78b 100644
--- a/drivers/firmware/efi/sysfb_efi.c
+++ b/drivers/firmware/efi/sysfb_efi.c
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

