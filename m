Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 734E01CAD94
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728684AbgEHMtR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:49:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:54674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729711AbgEHMtQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:49:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89B7321473;
        Fri,  8 May 2020 12:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942156;
        bh=B0ZRehfb7daJt9fmJGPXuRxL4DWb4WzgqL+FHZ7Ej7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oKRm1kgUL1f3CeiVbBj505ss1hm5g1ORZKrs/QbonbYVZv8jRe61Gxm73Icmf1vmT
         53Fyyagu9QPAsaxZXYtJQ6xUzzBJHPzkLAwmgJYSgCDG3BL2SCqfJlLsSSgXj9rO0N
         pOsk1SAmhwyursZffLesLlnUPzNvCRa36qvaq2Vo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Johan Hovold <johan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 280/312] net: hns: fix device reference leaks
Date:   Fri,  8 May 2020 14:34:31 +0200
Message-Id: <20200508123144.109692712@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 2271150bfb814b72ec57ae2fdf66e39da2eafafd upstream.

Make sure to drop the reference taken by class_find_device() in
hnae_get_handle() on errors and when later releasing the handle.

Fixes: 6fe6611ff275 ("net: add Hisilicon Network Subsystem...")
Cc: Yisen Zhuang <yisen.zhuang@huawei.com>
Cc: Salil Mehta <salil.mehta@huawei.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/hisilicon/hns/hnae.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/hisilicon/hns/hnae.c
+++ b/drivers/net/ethernet/hisilicon/hns/hnae.c
@@ -331,8 +331,10 @@ struct hnae_handle *hnae_get_handle(stru
 		return ERR_PTR(-ENODEV);
 
 	handle = dev->ops->get_handle(dev, port_id);
-	if (IS_ERR(handle))
+	if (IS_ERR(handle)) {
+		put_device(&dev->cls_dev);
 		return handle;
+	}
 
 	handle->dev = dev;
 	handle->owner_dev = owner_dev;
@@ -355,6 +357,8 @@ out_when_init_queue:
 	for (j = i - 1; j >= 0; j--)
 		hnae_fini_queue(handle->qs[j]);
 
+	put_device(&dev->cls_dev);
+
 	return ERR_PTR(-ENOMEM);
 }
 EXPORT_SYMBOL(hnae_get_handle);
@@ -376,6 +380,8 @@ void hnae_put_handle(struct hnae_handle
 		dev->ops->put_handle(h);
 
 	module_put(dev->owner);
+
+	put_device(&dev->cls_dev);
 }
 EXPORT_SYMBOL(hnae_put_handle);
 


