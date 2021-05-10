Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0413787C4
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233972AbhEJLSu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:18:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:46208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236610AbhEJLIU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:08:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 180DD61A25;
        Mon, 10 May 2021 11:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644556;
        bh=EufKKJo3MqMMuGuyaHZCQbVTmCcGGc1G3Pok+Txyilw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kakpXI5uQK0t/93EqyiM4SSJKSpW3f+Slu8J/S1mH9o4bmm9XU/GsXjTnBJ5odw6Z
         ru9yao6xxO8557S//uZporwa3u5GRx6EqTpoczbX7GxbNV95Md6/OJRP01NPU7/18p
         njSOw90VcSDarRttP0s8naTW3nVfx6IOuGF3V3WQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shixin Liu <liushixin2@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 130/384] crypto: sa2ul - Fix PM reference leak in sa_ul_probe()
Date:   Mon, 10 May 2021 12:18:39 +0200
Message-Id: <20210510102019.191374426@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shixin Liu <liushixin2@huawei.com>

[ Upstream commit 13343badae093977295341d5a050f51ef128821c ]

pm_runtime_get_sync will increment pm usage counter even it failed.
Forgetting to putting operation will result in reference leak here.
Fix it by replacing it with pm_runtime_resume_and_get to keep usage
counter balanced.

Signed-off-by: Shixin Liu <liushixin2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/sa2ul.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index f300b0a5958a..d7b1628fb484 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -2350,7 +2350,7 @@ static int sa_ul_probe(struct platform_device *pdev)
 	dev_set_drvdata(sa_k3_dev, dev_data);
 
 	pm_runtime_enable(dev);
-	ret = pm_runtime_get_sync(dev);
+	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "%s: failed to get sync: %d\n", __func__,
 			ret);
-- 
2.30.2



