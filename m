Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC1C6D2D3E
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 03:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233617AbjDABrX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 21:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233914AbjDABrA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 21:47:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 893B922210;
        Fri, 31 Mar 2023 18:44:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16F4862CFE;
        Sat,  1 Apr 2023 01:44:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2017C4339C;
        Sat,  1 Apr 2023 01:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680313440;
        bh=r+JRoVbJ6Bq9rX68HDbgD0D7lFjnHmsr6C1152qdGAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dDk6N8sWQvidjwh4pZIeFTQ6D8V7O2CQWz8abUCOErSeZyCdJ8R7nGnTJFq5UgMq3
         xsGmr0UoHk6wOdUjFSrawAYx4R7EwCR+vhd8oQZ+jHWhTIhVb8WpGpZhhfDH8UC/Rl
         fcvrzUEcyS8ymrtR6QdalxiN6BRkg9m08QKhkN6kpbqQYgzskIpCp5drUeutVX20VF
         2jUyBIoEY4EUdMUkdolHdVm+MVR+m0lski+ycnVQzf/qzWHXu+Ar7mvsRZLUJp2R1P
         nCNEarQhmsul4EfALV9WcSN/s+uVeOZo0LwiBw/asdV0cL/Sri/SfY8+pLzxTU6aG0
         BGDXcNXi3vPvA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-efi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 06/11] efi: sysfb_efi: Add quirk for Lenovo Yoga Book X91F/L
Date:   Fri, 31 Mar 2023 21:43:44 -0400
Message-Id: <20230401014350.3357107-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230401014350.3357107-1-sashal@kernel.org>
References: <20230401014350.3357107-1-sashal@kernel.org>
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
index 7ac757843dcfe..24d6f6e08df8b 100644
--- a/drivers/firmware/efi/sysfb_efi.c
+++ b/drivers/firmware/efi/sysfb_efi.c
@@ -274,6 +274,14 @@ static const struct dmi_system_id efifb_dmi_swap_width_height[] __initconst = {
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

