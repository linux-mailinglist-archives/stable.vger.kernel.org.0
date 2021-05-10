Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 850BB3783D2
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231752AbhEJKrm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:47:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233227AbhEJKpX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:45:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B19A16199C;
        Mon, 10 May 2021 10:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642925;
        bh=Y4ruUgLEFtdjN/MsVT/UtKbMP86g7mEtzbd5RxTHF94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FcBS6jy2R+Le7FN/Y7cOHaWDdsuk2DfvNob2YnJkraGK1kNUmCyJYlSFrJ8kGTJi9
         X/guMvXKNl8ZKVLUEMY87i9g387ZXOigZsX5wBHgWuovdD+N0oJCZT4fwX8BzdTb4x
         IgbtL74cGotdIeR9QsLQOUO70QasCSpwV1arVFnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shixin Liu <liushixin2@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 107/299] crypto: omap-aes - Fix PM reference leak on omap-aes.c
Date:   Mon, 10 May 2021 12:18:24 +0200
Message-Id: <20210510102008.478130426@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 1b1e0ab0a831..0dd4c6b157de 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -103,7 +103,7 @@ static int omap_aes_hw_init(struct omap_aes_dev *dd)
 		dd->err = 0;
 	}
 
-	err = pm_runtime_get_sync(dd->dev);
+	err = pm_runtime_resume_and_get(dd->dev);
 	if (err < 0) {
 		dev_err(dd->dev, "failed to get sync: %d\n", err);
 		return err;
@@ -1133,7 +1133,7 @@ static int omap_aes_probe(struct platform_device *pdev)
 	pm_runtime_set_autosuspend_delay(dev, DEFAULT_AUTOSUSPEND_DELAY);
 
 	pm_runtime_enable(dev);
-	err = pm_runtime_get_sync(dev);
+	err = pm_runtime_resume_and_get(dev);
 	if (err < 0) {
 		dev_err(dev, "%s: failed to get_sync(%d)\n",
 			__func__, err);
@@ -1302,7 +1302,7 @@ static int omap_aes_suspend(struct device *dev)
 
 static int omap_aes_resume(struct device *dev)
 {
-	pm_runtime_get_sync(dev);
+	pm_runtime_resume_and_get(dev);
 	return 0;
 }
 #endif
-- 
2.30.2



