Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 741C944B7EA
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345114AbhKIWjL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:39:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:56626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344670AbhKIWgL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:36:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50F4E61AFB;
        Tue,  9 Nov 2021 22:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496559;
        bh=sQQuDsAz4XaUdqpfDeZQWEr/ejmbJZi8Sa5xGXMaYqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bf3VXKYZBpQ0CzDLCzCIeT6XIIHtVQdml+RvqumImPk6OXxzWQ5upPhJxPuYCPXxM
         xVMgepUVxoVxX8Gh2fIvdizV7ayV927cBqxKs+1g+MeYJaMuHGvfTrLWPlt+JrSRjp
         NRdvsP3HRqPPhGV45608Niwl5RT36TlD7QEZvPfTTuZGEmQGLsNUdFmboYpXhC1bzN
         bsxM2V5dlNT/6J1gmXTkMT6oqUsZKbiZ+IhKMjJZibJbuGoopzBRRE/vRobrlWdJKP
         pbKuwXaebVVdsEX5FrFsvqSsExXVEckyQH2H6xeTKqfbmXSaSqx4rrYoo6oBoBViwj
         dNRFjwfDh9umQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, balbi@ti.com,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 08/30] usb: musb: tusb6010: check return value after calling platform_get_resource()
Date:   Tue,  9 Nov 2021 17:22:02 -0500
Message-Id: <20211109222224.1235388-8-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222224.1235388-1-sashal@kernel.org>
References: <20211109222224.1235388-1-sashal@kernel.org>
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
index 4ecfbf6bb1fa8..902507da8aa85 100644
--- a/drivers/usb/musb/tusb6010.c
+++ b/drivers/usb/musb/tusb6010.c
@@ -1103,6 +1103,11 @@ static int tusb_musb_init(struct musb *musb)
 
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

