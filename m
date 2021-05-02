Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 555D5370CC3
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbhEBOHW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:07:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:52030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233364AbhEBOGj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:06:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 616B3613C1;
        Sun,  2 May 2021 14:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964343;
        bh=YRT2/kN3O7xM06ZO/H9sYeubUAXwAdZi/sEG8a5jqvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tw3lifwVRGcIdTeqEeIscO/bS79izzECxUYShtQud0wsOQGstdiuGhbo0MBfNwKdI
         gpF7SRQsNA995HD8OvKHVtvfjQOOiwvEuwyyZinLyk3F/hhoC9jDr1oclR96YO9jA1
         RZXSu2PSnQdja1YimU1II3HkXUewKVXBY/526LTNdHWERDkrftmjVmZIfzzBgQx4k8
         8Ff2J5xV9vErOcuZ/T/1aQ5YdorhWOsToAD9Wwlw97boVITB7qAGGLhh88Rqw3WIs0
         PJbWRVT5IJqFzM/fueJ1BQwjnodlgn0jfACAHbOulpTmf7ClucPl+nxM9JgD68mXB3
         YNE9fF69yDdUw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shixin Liu <liushixin2@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 20/21] crypto: omap-aes - Fix PM reference leak on omap-aes.c
Date:   Sun,  2 May 2021 10:05:16 -0400
Message-Id: <20210502140517.2719912-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140517.2719912-1-sashal@kernel.org>
References: <20210502140517.2719912-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shixin Liu <liushixin2@huawei.com>

[ Upstream commit 1f34cc4a8da34fbb250efb928f9b8c6fe7ee0642 ]

pm_runtime_get_sync will increment pm usage counter even it failed.
Forgetting to putting operation will result in reference leak here.
Fix it by replacing it with pm_runtime_resume_and_get to keep usage
counter balanced.

Signed-off-by: Shixin Liu <liushixin2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/omap-aes.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index a5d6e1a0192b..2288fa6a939e 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -107,7 +107,7 @@ static int omap_aes_hw_init(struct omap_aes_dev *dd)
 		dd->err = 0;
 	}
 
-	err = pm_runtime_get_sync(dd->dev);
+	err = pm_runtime_resume_and_get(dd->dev);
 	if (err < 0) {
 		dev_err(dd->dev, "failed to get sync: %d\n", err);
 		return err;
@@ -1159,7 +1159,7 @@ static int omap_aes_probe(struct platform_device *pdev)
 	pm_runtime_set_autosuspend_delay(dev, DEFAULT_AUTOSUSPEND_DELAY);
 
 	pm_runtime_enable(dev);
-	err = pm_runtime_get_sync(dev);
+	err = pm_runtime_resume_and_get(dev);
 	if (err < 0) {
 		dev_err(dev, "%s: failed to get_sync(%d)\n",
 			__func__, err);
@@ -1327,7 +1327,7 @@ static int omap_aes_suspend(struct device *dev)
 
 static int omap_aes_resume(struct device *dev)
 {
-	pm_runtime_get_sync(dev);
+	pm_runtime_resume_and_get(dev);
 	return 0;
 }
 #endif
-- 
2.30.2

