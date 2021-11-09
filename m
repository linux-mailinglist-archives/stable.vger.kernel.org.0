Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB31344B875
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240623AbhKIWol (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:44:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:59458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344980AbhKIWl3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:41:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41E9361B29;
        Tue,  9 Nov 2021 22:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496630;
        bh=/FX/HvPV1wbd/mWSfwnt+7LoURga2Z4SLtXXZalJUT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jR2lNZUPMYhsYP9HinsDl+eLlEDKXdSMKpQlbnLdc7sk6ccm26llu8LwxaCeAl1xN
         BjuqLmFKv7h1ONGWpyPOVswBFrsmrkWtwaTLPatryxG8OnQq31weiJYfVJJ6DgnndE
         k61qqwUet7yhHOclpdXcW0a/awO3fcLBtg0wBxHS32uGWo2Tipld7XwHmW3E4UzywM
         PULOyOgLKZrW+GemmIoJRBtlKFtIjn1AfKSfT9399AUX7tcE9gja9L6X4NYDVLD/kX
         ydG6JyKnStFgeokIR3/Fz9aA+4w/UlynARRQkE5VR0Y9MsK6sGigEwBfAMCmA1iKS2
         GjBvABgw1B3qg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, balbi@ti.com,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 04/14] usb: musb: tusb6010: check return value after calling platform_get_resource()
Date:   Tue,  9 Nov 2021 17:23:33 -0500
Message-Id: <20211109222343.1235902-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222343.1235902-1-sashal@kernel.org>
References: <20211109222343.1235902-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 14651496a3de6807a17c310f63c894ea0c5d858e ]

It will cause null-ptr-deref if platform_get_resource() returns NULL,
we need check the return value.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20210915034925.2399823-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/musb/tusb6010.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/musb/tusb6010.c b/drivers/usb/musb/tusb6010.c
index 7d7cb1c5ec808..9a7b5b2d7ccc7 100644
--- a/drivers/usb/musb/tusb6010.c
+++ b/drivers/usb/musb/tusb6010.c
@@ -1108,6 +1108,11 @@ static int tusb_musb_init(struct musb *musb)
 
 	/* dma address for async dma */
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem) {
+		pr_debug("no async dma resource?\n");
+		ret = -ENODEV;
+		goto done;
+	}
 	musb->async = mem->start;
 
 	/* dma address for sync dma */
-- 
2.33.0

