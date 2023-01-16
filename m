Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9FC66CC26
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234485AbjAPRWm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:22:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234528AbjAPRWN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:22:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6242859E6C
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:00:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19314B8109B
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:00:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5953CC433D2;
        Mon, 16 Jan 2023 17:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888401;
        bh=kIr63EoiCK7ursHImBDWXjTtvStaWfR/+w3upn+J73c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ARTQk9lSuazsXo3bu3qw7cJYoj8/HXSGT3QO7yCGBkn1+8gzrPqx9Fy7H3t7bZFKr
         YKhNLarXubZchbsatBRmpwC7Ire+63bMeowiw2sC72/GtDNDvbFgmqV9fjsRLQvpz3
         2H+a/twFW+VOnQa9aeXS/EJVMsCqP+A936ceQcY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Li Heng <liheng40@huawei.com>,
        Johan Hovold <johan+linaro@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 514/521] efi: fix NULL-deref in init error path
Date:   Mon, 16 Jan 2023 16:52:56 +0100
Message-Id: <20230116154910.206825548@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit 703c13fe3c9af557d312f5895ed6a5fda2711104 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/efi.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -359,8 +359,8 @@ static int __init efisubsys_init(void)
 	efi_kobj = kobject_create_and_add("efi", firmware_kobj);
 	if (!efi_kobj) {
 		pr_err("efi: Firmware registration failed.\n");
-		destroy_workqueue(efi_rts_wq);
-		return -ENOMEM;
+		error = -ENOMEM;
+		goto err_destroy_wq;
 	}
 
 	error = generic_ops_register();
@@ -396,7 +396,10 @@ err_unregister:
 	generic_ops_unregister();
 err_put:
 	kobject_put(efi_kobj);
-	destroy_workqueue(efi_rts_wq);
+err_destroy_wq:
+	if (efi_rts_wq)
+		destroy_workqueue(efi_rts_wq);
+
 	return error;
 }
 


