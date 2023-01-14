Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE0BC66AAB7
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 10:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbjANJuv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 04:50:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbjANJuu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 04:50:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20519172F
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 01:50:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C92A1B808C5
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 09:50:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC36C433EF;
        Sat, 14 Jan 2023 09:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673689847;
        bh=4+OCjHNcM0G6oaKTxhaqqaI3VpydndDHsZLsx5i55pk=;
        h=Subject:To:Cc:From:Date:From;
        b=GAdT94v07iY7hrO/q1J7IMW9IrNBXeEUJCc58VxqKjE7m21KQLmye51KoAXXFVk47
         KTdNVNDN76Z3czxPls2lfKhQS5HrdL81cyqZSJz46MX1HXErCUziY92MNhylP7czbT
         IXUDgLCVgUKANitc+QQeZO29KBYIMKcxEbPPgd68=
Subject: FAILED: patch "[PATCH] efi: fix NULL-deref in init error path" failed to apply to 6.1-stable tree
To:     johan+linaro@kernel.org, ardb@kernel.org, liheng40@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 14 Jan 2023 10:50:44 +0100
Message-ID: <16736898442184@kroah.com>
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


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

703c13fe3c9a ("efi: fix NULL-deref in init error path")
1fff234de2b6 ("efi: x86: Move EFI runtime map sysfs code to arch/x86")
8dfac4d8ad27 ("efi: runtime-maps: Clarify purpose and enable by default for kexec")
4059ba656ce5 ("efi: memmap: Move EFI fake memmap support into x86 arch tree")

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
 

