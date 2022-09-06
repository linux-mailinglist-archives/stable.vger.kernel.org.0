Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A39C25AEEB3
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 17:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239368AbiIFP1C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 11:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239226AbiIFP0f (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 11:26:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 520C4C00D2;
        Tue,  6 Sep 2022 07:37:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94B7B6153B;
        Tue,  6 Sep 2022 13:43:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4C2C433D6;
        Tue,  6 Sep 2022 13:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471785;
        bh=Ym27K62WVbMA79vBCpNSbpm3d8vb7muL35dXoewCPmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EKRWDdecnJ3E12eQNE0jGs6HGfK3fMVueyvnsEbosk4d5QlUR9bAj/KpXRrRc4dH/
         WWqD7mtjhwxucLYVWOcuiERFuMROuV3saifQpLIaPpMFOlRzefGbN5y5lTxaVSffj5
         8zfM/QGzeSyV6oXkz1GBd6Ovou80AaG1va7OYy5k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 008/155] platform/x86: x86-android-tablets: Fix broken touchscreen on Chuwi Hi8 with Windows BIOS
Date:   Tue,  6 Sep 2022 15:29:16 +0200
Message-Id: <20220906132829.765398481@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 2986c51540ed50ac654ffb5a772e546c02628c91 ]

The x86-android-tablets handling for the Chuwi Hi8 is only necessary with
the Android BIOS and it is causing problems with the Windows BIOS version.

Specifically when trying to register the already present touchscreen
x86_acpi_irq_helper_get() calls acpi_unregister_gsi(), this breaks
the working of the touchscreen and also leads to an oops:

[   14.248946] ------------[ cut here ]------------
[   14.248954] remove_proc_entry: removing non-empty directory 'irq/75', leaking at least 'MSSL0001:00'
[   14.248983] WARNING: CPU: 3 PID: 440 at fs/proc/generic.c:718 remove_proc_entry
...
[   14.249293]  unregister_irq_proc+0xe0/0x100
[   14.249305]  free_desc+0x29/0x70
[   14.249312]  irq_free_descs+0x4b/0x80
[   14.249320]  mp_unmap_irq+0x5c/0x60
[   14.249329]  acpi_unregister_gsi_ioapic+0x2a/0x40
[   14.249338]  x86_acpi_irq_helper_get+0x4b/0x190 [x86_android_tablets]
[   14.249355]  x86_android_tablet_init+0x178/0xe34 [x86_android_tablets]

Add an init callback for the Chuwi Hi8, which detects when the Windows BIOS
is in use and exits with -ENODEV in that case, fixing this.

Fixes: 84c2dcdd475f ("platform/x86: x86-android-tablets: Add an init() callback to struct x86_dev_info")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20220810141934.140771-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/x86-android-tablets.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/platform/x86/x86-android-tablets.c b/drivers/platform/x86/x86-android-tablets.c
index 4803759774358..4acd6fa8d43b8 100644
--- a/drivers/platform/x86/x86-android-tablets.c
+++ b/drivers/platform/x86/x86-android-tablets.c
@@ -663,9 +663,23 @@ static const struct x86_i2c_client_info chuwi_hi8_i2c_clients[] __initconst = {
 	},
 };
 
+static int __init chuwi_hi8_init(void)
+{
+	/*
+	 * Avoid the acpi_unregister_gsi() call in x86_acpi_irq_helper_get()
+	 * breaking the touchscreen + logging various errors when the Windows
+	 * BIOS is used.
+	 */
+	if (acpi_dev_present("MSSL0001", NULL, 1))
+		return -ENODEV;
+
+	return 0;
+}
+
 static const struct x86_dev_info chuwi_hi8_info __initconst = {
 	.i2c_client_info = chuwi_hi8_i2c_clients,
 	.i2c_client_count = ARRAY_SIZE(chuwi_hi8_i2c_clients),
+	.init = chuwi_hi8_init,
 };
 
 #define CZC_EC_EXTRA_PORT	0x68
-- 
2.35.1



