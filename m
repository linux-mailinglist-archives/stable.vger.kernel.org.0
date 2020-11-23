Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A95E2C0855
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732740AbgKWMtH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:49:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:33620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732829AbgKWMsk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:48:40 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E247B2137B;
        Mon, 23 Nov 2020 12:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135674;
        bh=qOLcD1tlmhit3J4RNathiiYPCF4BMnzr3lGPIae2Zqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PM3z4ltXxMqR3xDSQfzN4+QJMKM/CTd1DFd1Pg3UaX1PHT0dmqBy+Nvw2KyjmNM3A
         zw53zd2saPtQi5znR/XKnh9QqAWT1z9Y8MQolc1Lv1ZAYwvNwdSFwTU68bjA5DRID3
         59j58DhV6y1409XldrxrZn7RdqLy7YtVuONB7soU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 155/252] dmaengine: fix error codes in channel_register()
Date:   Mon, 23 Nov 2020 13:21:45 +0100
Message-Id: <20201123121843.073853185@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 7e4be1290a38b3dd4a77cdf4565c9ffe7e620013 ]

The error codes were not set on some of these error paths.

Also the error handling was more confusing than it needed to be so I
cleaned it up and shuffled it around a bit.

Fixes: d2fb0a043838 ("dmaengine: break out channel registration")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Link: https://lore.kernel.org/r/20201113101631.GE168908@mwanda
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dmaengine.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index a53e71d2bbd4c..a2146d1f42da7 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -1055,16 +1055,15 @@ static int get_dma_id(struct dma_device *device)
 static int __dma_async_device_channel_register(struct dma_device *device,
 					       struct dma_chan *chan)
 {
-	int rc = 0;
+	int rc;
 
 	chan->local = alloc_percpu(typeof(*chan->local));
 	if (!chan->local)
-		goto err_out;
+		return -ENOMEM;
 	chan->dev = kzalloc(sizeof(*chan->dev), GFP_KERNEL);
 	if (!chan->dev) {
-		free_percpu(chan->local);
-		chan->local = NULL;
-		goto err_out;
+		rc = -ENOMEM;
+		goto err_free_local;
 	}
 
 	/*
@@ -1077,7 +1076,8 @@ static int __dma_async_device_channel_register(struct dma_device *device,
 	if (chan->chan_id < 0) {
 		pr_err("%s: unable to alloc ida for chan: %d\n",
 		       __func__, chan->chan_id);
-		goto err_out;
+		rc = chan->chan_id;
+		goto err_free_dev;
 	}
 
 	chan->dev->device.class = &dma_devclass;
@@ -1098,9 +1098,10 @@ static int __dma_async_device_channel_register(struct dma_device *device,
 	mutex_lock(&device->chan_mutex);
 	ida_free(&device->chan_ida, chan->chan_id);
 	mutex_unlock(&device->chan_mutex);
- err_out:
-	free_percpu(chan->local);
+ err_free_dev:
 	kfree(chan->dev);
+ err_free_local:
+	free_percpu(chan->local);
 	return rc;
 }
 
-- 
2.27.0



