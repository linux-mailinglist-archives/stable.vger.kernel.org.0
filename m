Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C010A44B8C0
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346223AbhKIWpz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:45:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:36030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346107AbhKIWnn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:43:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4C1461881;
        Tue,  9 Nov 2021 22:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496670;
        bh=yskHZabqsvAjti3StZjV+B4KzqCQCGY0fwXULf/2qd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lWBtg1mNptRRUO83e7z8OR4IN+GhdfBBUwKm2qSuv74mMhw3O+Fms/+07RbQqoSe3
         r3Xn7rmIwbkRGLU4aFmXQb24p1ouO6hFqMRhyZvSi0oNRDb1u1kZXReK4cLKtnWeS9
         koGFTxXCr8WYmerQppUP+GKw6GF34JFUZ39Dqb29XMSX7NbtyC5imgvSs0SkMj7MrZ
         8vkuHZrauAp8cHIBVhmFcvu7bG0d/PfM5TzszDaMkIGIzzEekRVbgiZFsIeKX0jF2Y
         x8bWSXY7qjwbdKbUBGiDKY+2ZJSnXgj+H/5/30m05BuCZ5Q9JfgulWh7xDxFvNloy9
         cTV8BDgOCDEoA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, balbi@ti.com,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 02/12] usb: musb: tusb6010: check return value after calling platform_get_resource()
Date:   Tue,  9 Nov 2021 17:24:16 -0500
Message-Id: <20211109222426.1236575-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222426.1236575-1-sashal@kernel.org>
References: <20211109222426.1236575-1-sashal@kernel.org>
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
index 85a57385958fd..f4297e5495958 100644
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

