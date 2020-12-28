Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7542E39AC
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389491AbgL1N03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:26:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:55016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389487AbgL1N03 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:26:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51D8020719;
        Mon, 28 Dec 2020 13:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161973;
        bh=Nt/MzaAIEEJxH5sdzbVHDdFTyFSIOnPo/lyqHov3v/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t1jqAGu5JmTKcOtO/nKGZm0wq503+qm7P7Dcyb6SvhXR+dcN8FdSH+NhWM8uEU0tZ
         RX54rUUWQpYoBI2A6pvXOSo0ni6CB9ejO+yaRQipp9Bmn/D57PYjnZkh8G0Y+Hg5hn
         JizXvyEZGdEzDfxhDb+KvmO9qegAH4Oe6cTq3aWA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 145/346] video: fbdev: atmel_lcdfb: fix return error code in atmel_lcdfb_of_init()
Date:   Mon, 28 Dec 2020 13:47:44 +0100
Message-Id: <20201228124926.797764598@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit ba236455ee750270f33998df57f982433cea4d8e ]

If devm_kzalloc() failed after the first time, atmel_lcdfb_of_init()
can't return -ENOMEM, fix this by putting the error code in loop.

Fixes: b985172b328a ("video: atmel_lcdfb: add device tree suport")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20201117061350.3453742-1-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/atmel_lcdfb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/atmel_lcdfb.c b/drivers/video/fbdev/atmel_lcdfb.c
index 4ed55e6bbb840..6d01ae3984c73 100644
--- a/drivers/video/fbdev/atmel_lcdfb.c
+++ b/drivers/video/fbdev/atmel_lcdfb.c
@@ -1071,8 +1071,8 @@ static int atmel_lcdfb_of_init(struct atmel_lcdfb_info *sinfo)
 	}
 
 	INIT_LIST_HEAD(&pdata->pwr_gpios);
-	ret = -ENOMEM;
 	for (i = 0; i < gpiod_count(dev, "atmel,power-control"); i++) {
+		ret = -ENOMEM;
 		gpiod = devm_gpiod_get_index(dev, "atmel,power-control",
 					     i, GPIOD_ASIS);
 		if (IS_ERR(gpiod))
-- 
2.27.0



