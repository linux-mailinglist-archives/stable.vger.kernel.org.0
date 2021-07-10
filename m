Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9A963C316B
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233838AbhGJClU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:41:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:58378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235807AbhGJCjr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:39:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6E5861430;
        Sat, 10 Jul 2021 02:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884567;
        bh=NmpHhKxyWabwxzoQk+F8jXQUcqsTQj1VPDk0XMEuu2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LIO4QGPY5B8WalpPv0ClcL9ndgHBP/qAfH7xDYHMFxyf/+lF4Zn7GfanXbBEs3lNf
         SMdoVad6GH1qUnNqcvfs0yWNn3rWh/wbvAkjzuHiwnmXj1mf8kn3yytieTKmzSRpud
         KQGtfoFK91LS9dnJ/KoTUwwlUCQSPc2ZNdxu1dbTIYzA8xQMmkLaL9kGTKdAUr4XZU
         ApwSYUQXrEnyZwGsYmJKsX6dvxMaYuYjXYTzn9+As1+aPY1lMu81zJ879F+ghjPGF9
         H4aBr4WebajBp1M+QFaJxkZIk9SCtCIu1z263fs8imZzI+UVVXU8jd2xK+pGhMlcYj
         vPPUIP0qsxI0g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 02/26] misc/libmasm/module: Fix two use after free in ibmasm_init_one
Date:   Fri,  9 Jul 2021 22:35:40 -0400
Message-Id: <20210710023604.3172486-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710023604.3172486-1-sashal@kernel.org>
References: <20210710023604.3172486-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Yunlong <lyl2019@mail.ustc.edu.cn>

[ Upstream commit 7272b591c4cb9327c43443f67b8fbae7657dd9ae ]

In ibmasm_init_one, it calls ibmasm_init_remote_input_dev().
Inside ibmasm_init_remote_input_dev, mouse_dev and keybd_dev are
allocated by input_allocate_device(), and assigned to
sp->remote.mouse_dev and sp->remote.keybd_dev respectively.

In the err_free_devices error branch of ibmasm_init_one,
mouse_dev and keybd_dev are freed by input_free_device(), and return
error. Then the execution runs into error_send_message error branch
of ibmasm_init_one, where ibmasm_free_remote_input_dev(sp) is called
to unregister the freed sp->remote.mouse_dev and sp->remote.keybd_dev.

My patch add a "error_init_remote" label to handle the error of
ibmasm_init_remote_input_dev(), to avoid the uaf bugs.

Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Link: https://lore.kernel.org/r/20210426170620.10546-1-lyl2019@mail.ustc.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/ibmasm/module.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/ibmasm/module.c b/drivers/misc/ibmasm/module.c
index 6b3bf9ab051d..706decef68a0 100644
--- a/drivers/misc/ibmasm/module.c
+++ b/drivers/misc/ibmasm/module.c
@@ -123,7 +123,7 @@ static int ibmasm_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	result = ibmasm_init_remote_input_dev(sp);
 	if (result) {
 		dev_err(sp->dev, "Failed to initialize remote queue\n");
-		goto error_send_message;
+		goto error_init_remote;
 	}
 
 	result = ibmasm_send_driver_vpd(sp);
@@ -143,8 +143,9 @@ static int ibmasm_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	return 0;
 
 error_send_message:
-	disable_sp_interrupts(sp->base_address);
 	ibmasm_free_remote_input_dev(sp);
+error_init_remote:
+	disable_sp_interrupts(sp->base_address);
 	free_irq(sp->irq, (void *)sp);
 error_request_irq:
 	iounmap(sp->base_address);
-- 
2.30.2

