Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22F7245C297
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350777AbhKXNak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:30:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:60596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350756AbhKXN2f (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:28:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3867B610E6;
        Wed, 24 Nov 2021 12:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758268;
        bh=HpeFUNsbzxu0oeLBzGfrdJpJldVwpo7oeRiX/ogBVrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D8iE0VperazG6uZmgK24MWNSzvzAyXsnz+zOACoaQisGTGwES3KbFeTQybC2rpmf0
         p6MrawvliMP6MMiwlSEekS/GPQT3gWBBX0B3+fMdTUibKGSvWPcrSWOmRNLTncBSIC
         eou11cLZ5efonBS/qpglqCeAbRTbHcf3FCpfyeAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 014/154] usb: musb: tusb6010: check return value after calling platform_get_resource()
Date:   Wed, 24 Nov 2021 12:56:50 +0100
Message-Id: <20211124115702.843378695@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 0c2afed4131bc..038307f661985 100644
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



