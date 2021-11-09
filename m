Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12F6144B579
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343551AbhKIWVC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:21:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:41188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245561AbhKIWUd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:20:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C119461248;
        Tue,  9 Nov 2021 22:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496247;
        bh=4CRT7RCXMKiOsgu3ogcz06kWJVI2Tfh4ozMN2bCKil8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mNNIslf5Ttp1EMjEK+8uiSQE71j9avEujesk+b+vYb1Qy/Yf76Iz9Zk20dN1kA+Ss
         TfNwnL7Xyb3rOA2XN1NFMzJ+Z1B2itTUE8NO+xwFW4Y4zizoW4+nYIDC9ezIfHL4dn
         Ah60Yjp0wwcnf4o2orHnVD/AJAMehetFAwJyLuYXA2YgHRnflOFY3d1zzUybO7WnDB
         2iEoSULcuOtB8FqfnTk/hoJ1h88M5/bzq1n7SdcmCgg/wtgb/bn1brlGKQZQDCKWJ2
         cPjyUS7qqbQRO5ib7Y4KXyMm6nHRS2IZLi4Rj+M982Xe+4QfJcWjkMXiEvoBdzTSai
         kQ6+TfyKpipKg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, balbi@ti.com,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 21/82] usb: musb: tusb6010: check return value after calling platform_get_resource()
Date:   Tue,  9 Nov 2021 17:15:39 -0500
Message-Id: <20211109221641.1233217-21-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221641.1233217-1-sashal@kernel.org>
References: <20211109221641.1233217-1-sashal@kernel.org>
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
index c968ecda42aa8..7ed4cc348d993 100644
--- a/drivers/usb/musb/tusb6010.c
+++ b/drivers/usb/musb/tusb6010.c
@@ -1104,6 +1104,11 @@ static int tusb_musb_init(struct musb *musb)
 
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

