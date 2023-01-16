Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D76A66C9A4
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbjAPQxJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:53:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233848AbjAPQwu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:52:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7671623875
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:37:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0951B61083
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:37:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DAE4C433EF;
        Mon, 16 Jan 2023 16:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887058;
        bh=UQicHO1lR8Q4Jm7njpll5NKST1mr4Bt4d6DQGWGX7pE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x1Z7Bc2ZLqL8HsT4KmAOWBWuObTUGn865csMrHVc9gy/C2VuRf1pQvQeQS6dotBjW
         Qajz43mMd/cv4q2GgvdapsHMGeol77wtlB5AugZU1kfigB3xeUcEy0wydZqdq/wlek
         WlkCVD7eKnLs6xHpzlk3v0Usy/fhMK/ID2hjYphs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Li Heng <liheng40@huawei.com>,
        Johan Hovold <johan+linaro@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 650/658] efi: fix NULL-deref in init error path
Date:   Mon, 16 Jan 2023 16:52:18 +0100
Message-Id: <20230116154939.219658867@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
@@ -345,8 +345,8 @@ static int __init efisubsys_init(void)
 	efi_kobj = kobject_create_and_add("efi", firmware_kobj);
 	if (!efi_kobj) {
 		pr_err("efi: Firmware registration failed.\n");
-		destroy_workqueue(efi_rts_wq);
-		return -ENOMEM;
+		error = -ENOMEM;
+		goto err_destroy_wq;
 	}
 
 	error = generic_ops_register();
@@ -382,7 +382,10 @@ err_unregister:
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
 


