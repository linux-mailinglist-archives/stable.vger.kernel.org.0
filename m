Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6C04650925
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 10:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbiLSJLN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 04:11:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231779AbiLSJKP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 04:10:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74471D2D0;
        Mon, 19 Dec 2022 01:10:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E08E60EA6;
        Mon, 19 Dec 2022 09:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 674A4C433EF;
        Mon, 19 Dec 2022 09:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671441013;
        bh=KQcpNIi0lkfvil0776TwVu1owzN9g859QKqnaK0hcJ0=;
        h=From:To:Cc:Subject:Date:From;
        b=tePLX7VxLr3Fq3e9b9dHN3bX118i9ELp/L2kkxoryqzKZbv4JkfnoVnIl1zDnRYn7
         cEQpKj/uF8eS2TZ9iMB2rHffUEpVAIm7tLa/bjc8QM9UhjnNuQYfZL3nkGtkTXajUr
         LQPHWKbAPD+OGzDsiSD5wXPbzWQn//StEXUagT7xgcIf/FsSt14h+QOpBTZNdWxzJJ
         WSIHJCFd2ZqLoD660qJc05JV8QPc/1vkuvFNBvEEjEWRpZ+uC7nwYTX6aDCBxG8WNg
         pEVPx1OBKMzdYhGA1yJKjg6LC6Ty4DN5nIWVneodfsSNZDI7EJsLJwAdXSQ+IUflER
         GKXbO1GXlDx3g==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1p7CAh-00009f-Fj; Mon, 19 Dec 2022 10:10:55 +0100
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org,
        Li Heng <liheng40@huawei.com>
Subject: [PATCH] efi: fix NULL-deref in init error path
Date:   Mon, 19 Dec 2022 10:10:04 +0100
Message-Id: <20221219091004.562-1-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.37.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In case runtime services are not supported or have been disabled the
runtime services workqueue will never have been allocated.

Do not try to destroy the workqueue unconditionally in the unlikely
event that EFI initialisation fails to avoid dereferencing a NULL
pointer.

Fixes: 98086df8b70c ("efi: add missed destroy_workqueue when efisubsys_init fails")
Cc: stable@vger.kernel.org
Cc: Li Heng <liheng40@huawei.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/firmware/efi/efi.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

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
 
-- 
2.37.4

