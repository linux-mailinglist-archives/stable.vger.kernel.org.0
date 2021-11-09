Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5B5844B888
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241146AbhKIWox (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:44:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:34962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345740AbhKIWmN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:42:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA7FF61A3D;
        Tue,  9 Nov 2021 22:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496648;
        bh=dcpl2f+8KBRt/uP+tn0OmypMvVqNkSS9gHGCM7XvEhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E+1UdtJsUSbh76q1shiM/VrFjgTMVaCXtZn/oMU2a5BSZFpp0hIDvV9NyIxOb+gDX
         zBeHcNNeHRODSClWi+ps8K56srNZE8KKqO0QKQSWSYBcSp6NNOuyPFlRPkdN6vvKIh
         mo4ZeMKXzcS06e2LRMl7lHZBjVgdVZu79WUP1DpobDTble+0bntKZI6p8fk0A90hoZ
         LnmD2sqcd46ZkdgKZtWPYvzx1LlRAYfO9w9h8tQKoPnwsGCKm4wPC7BURzz39Yagco
         OvZM6u/3aNP/FTEr/Nay0VXNsA1gPY/U8nf4+QWnWtfMsfZXsvqkN+FXOdnkk7XQWZ
         6lehCUIvP+QTQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, balbi@ti.com,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 02/13] usb: musb: tusb6010: check return value after calling platform_get_resource()
Date:   Tue,  9 Nov 2021 17:23:53 -0500
Message-Id: <20211109222405.1236040-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222405.1236040-1-sashal@kernel.org>
References: <20211109222405.1236040-1-sashal@kernel.org>
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
index 7e9204fdba4a8..fb4239b5286fb 100644
--- a/drivers/usb/musb/tusb6010.c
+++ b/drivers/usb/musb/tusb6010.c
@@ -1120,6 +1120,11 @@ static int tusb_musb_init(struct musb *musb)
 
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

