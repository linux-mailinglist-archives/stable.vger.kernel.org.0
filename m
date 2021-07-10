Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4964C3C2DC3
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbhGJCZH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:25:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231883AbhGJCY4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:24:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1723F613D9;
        Sat, 10 Jul 2021 02:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883732;
        bh=4DYIJkBBNEgbBtLUIK/WIpKbeZB5/9WqbXBS6E8Bh54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eyFl5hIUXi0DZdsiGwDLVOoQ2mi0YkGgdCEBrhtATSxK0Jw/PyRKHY5VRMdn18NJ2
         Ur71vyL6l3blM2lYjeXONBXdy1LoGEO69l0the5eQLnMbvyVjqgHsllbieDuGvNfj5
         MxPwH9cnAwKNg90aGzBJeXF2K0xOJ6D6ZlKwXdURHL65jUdUwSU7yQnu5OsUqtZk0y
         50JaeLh2eMC/JhlUFx9+KOPVE2y1yjXmrlui7/3reSr3TM1iriUA1Uk4AJQ9vExRyW
         QVFHQx+/fx76McAOI91X6DMQW013s9YtwZYCY0dUooogjd+/is497S9w255huOtkl6
         gHhaKOcIfrwqQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.12 012/104] misc/libmasm/module: Fix two use after free in ibmasm_init_one
Date:   Fri,  9 Jul 2021 22:20:24 -0400
Message-Id: <20210710022156.3168825-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022156.3168825-1-sashal@kernel.org>
References: <20210710022156.3168825-1-sashal@kernel.org>
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
index 4edad6c445d3..dc8a06c06c63 100644
--- a/drivers/misc/ibmasm/module.c
+++ b/drivers/misc/ibmasm/module.c
@@ -111,7 +111,7 @@ static int ibmasm_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	result = ibmasm_init_remote_input_dev(sp);
 	if (result) {
 		dev_err(sp->dev, "Failed to initialize remote queue\n");
-		goto error_send_message;
+		goto error_init_remote;
 	}
 
 	result = ibmasm_send_driver_vpd(sp);
@@ -131,8 +131,9 @@ static int ibmasm_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
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

