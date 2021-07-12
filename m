Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4EE3C4F71
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242660AbhGLHZ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:25:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:32870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237935AbhGLHWr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:22:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BEE7610D1;
        Mon, 12 Jul 2021 07:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074399;
        bh=kuRrX1MUViblMIKwP9n3Eom3QwTmuiW3slBjQxbYPpk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QBWobdcL8Zi1sn+qbvmtkFoE3P9xJZOtfqY0nMG1gxC/yja23mKkEx5FJiSh3bE1M
         UxmlkhoSXT7XMewZSyE6SPmoFp3FcVSd/PcIFZxiXjRwmOhW+wHbYaMofrsEU1poTG
         3+BqMF8jsoTsMqGpQtOqD14EnJX5HRePxp0hznhI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 566/700] firmware: stratix10-svc: Fix a resource leak in an error handling path
Date:   Mon, 12 Jul 2021 08:10:49 +0200
Message-Id: <20210712061036.377955990@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit d99247f9b542533ddbf87a3481a05473b8e48194 ]

If an error occurs after a successful 'kfifo_alloc()' call, it must be
undone by a corresponding 'kfifo_free()' call, as already done in the
remove function.

While at it, move the 'platform_device_put()' call to this new error
handling path and explicitly return 0 in the success path.

Fixes: b5dc75c915cd ("firmware: stratix10-svc: extend svc to support new RSU features")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/0ca3f3ab139c53e846804455a1e7599ee8ae896a.1621621271.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/stratix10-svc.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/firmware/stratix10-svc.c b/drivers/firmware/stratix10-svc.c
index 3aa489dba30a..2a7687911c09 100644
--- a/drivers/firmware/stratix10-svc.c
+++ b/drivers/firmware/stratix10-svc.c
@@ -1034,24 +1034,32 @@ static int stratix10_svc_drv_probe(struct platform_device *pdev)
 
 	/* add svc client device(s) */
 	svc = devm_kzalloc(dev, sizeof(*svc), GFP_KERNEL);
-	if (!svc)
-		return -ENOMEM;
+	if (!svc) {
+		ret = -ENOMEM;
+		goto err_free_kfifo;
+	}
 
 	svc->stratix10_svc_rsu = platform_device_alloc(STRATIX10_RSU, 0);
 	if (!svc->stratix10_svc_rsu) {
 		dev_err(dev, "failed to allocate %s device\n", STRATIX10_RSU);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto err_free_kfifo;
 	}
 
 	ret = platform_device_add(svc->stratix10_svc_rsu);
-	if (ret) {
-		platform_device_put(svc->stratix10_svc_rsu);
-		return ret;
-	}
+	if (ret)
+		goto err_put_device;
+
 	dev_set_drvdata(dev, svc);
 
 	pr_info("Intel Service Layer Driver Initialized\n");
 
+	return 0;
+
+err_put_device:
+	platform_device_put(svc->stratix10_svc_rsu);
+err_free_kfifo:
+	kfifo_free(&controller->svc_fifo);
 	return ret;
 }
 
-- 
2.30.2



