Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3B4C66AABB
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 10:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjANJvO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 04:51:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbjANJvO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 04:51:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB694495
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 01:51:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33534B808C7
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 09:51:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21974C433EF;
        Sat, 14 Jan 2023 09:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673689870;
        bh=m1EVXKC2t9VWvMwERk9/ZjpZyKQx5qpjuM7N/NHyZvA=;
        h=Subject:To:Cc:From:Date:From;
        b=H1eeFDig92OFJPOTLCY85WV28GSjvJndmOHVh/FOSTtiXh7TJRZtES7LeMH2bQE0A
         90y4wurWEhDsXHBNZWZaKnjo/O2kIQLUPkOjARqdXsq+0iGIID+ixAi0u7uXqKR90M
         uO71pYFUdCB4PmyS9JLPkGlj+MF0MJ1MYqenEvwg=
Subject: FAILED: patch "[PATCH] efi: fix NULL-deref in init error path" failed to apply to 4.19-stable tree
To:     johan+linaro@kernel.org, ardb@kernel.org, liheng40@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 14 Jan 2023 10:50:47 +0100
Message-ID: <1673689847133237@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

703c13fe3c9a ("efi: fix NULL-deref in init error path")
1fff234de2b6 ("efi: x86: Move EFI runtime map sysfs code to arch/x86")
8dfac4d8ad27 ("efi: runtime-maps: Clarify purpose and enable by default for kexec")
4059ba656ce5 ("efi: memmap: Move EFI fake memmap support into x86 arch tree")
d391c5827107 ("drivers/firmware: move x86 Generic System Framebuffers support")
25519d683442 ("ima: generalize x86/EFI arch glue for other EFI architectures")
88e9a5b7965c ("efi/fake_mem: arrange for a resource entry per efi_fake_mem instance")
4d0a4388ccdd ("Merge branch 'efi/urgent' into efi/core, to pick up fixes")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 703c13fe3c9af557d312f5895ed6a5fda2711104 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan+linaro@kernel.org>
Date: Mon, 19 Dec 2022 10:10:04 +0100
Subject: [PATCH] efi: fix NULL-deref in init error path

In cases where runtime services are not supported or have been disabled,
the runtime services workqueue will never have been allocated.

Do not try to destroy the workqueue unconditionally in the unlikely
event that EFI initialisation fails to avoid dereferencing a NULL
pointer.

Fixes: 98086df8b70c ("efi: add missed destroy_workqueue when efisubsys_init fails")
Cc: stable@vger.kernel.org
Cc: Li Heng <liheng40@huawei.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 09716eebe8ac..a2b0cbc8741c 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -394,8 +394,8 @@ static int __init efisubsys_init(void)
 	efi_kobj = kobject_create_and_add("efi", firmware_kobj);
 	if (!efi_kobj) {
 		pr_err("efi: Firmware registration failed.\n");
-		destroy_workqueue(efi_rts_wq);
-		return -ENOMEM;
+		error = -ENOMEM;
+		goto err_destroy_wq;
 	}
 
 	if (efi_rt_services_supported(EFI_RT_SUPPORTED_GET_VARIABLE |
@@ -443,7 +443,10 @@ static int __init efisubsys_init(void)
 err_put:
 	kobject_put(efi_kobj);
 	efi_kobj = NULL;
-	destroy_workqueue(efi_rts_wq);
+err_destroy_wq:
+	if (efi_rts_wq)
+		destroy_workqueue(efi_rts_wq);
+
 	return error;
 }
 

