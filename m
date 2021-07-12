Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFD003C5273
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346182AbhGLHqF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:46:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:51190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349642AbhGLHo0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:44:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1F42611CC;
        Mon, 12 Jul 2021 07:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075661;
        bh=mnRYRODX2g7er1tqw8vcCWPLTh7bVw7/p8chobbMU7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y7L77RilTo4HT7zzOqu3E4QD9aMxo/XB7/n6bovWKUxjIKOCgQEgf7gcRF3nDAP5I
         wbtUsrnr/CSolz5VUe/gRw4NWtBwkPQ42z4kZA/0MEy4g1P0QRMBMm4LnMAl+gEVBs
         4+8xBBD2MgpUR7WVUnimFmCKGqpcWql/nqvenYfQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 310/800] crypto: omap-sham - Fix PM reference leak in omap sham ops
Date:   Mon, 12 Jul 2021 08:05:33 +0200
Message-Id: <20210712060958.502806554@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit ca323b2c61ec321eb9f2179a405b9c34cdb4f553 ]

pm_runtime_get_sync will increment pm usage counter
even it failed. Forgetting to putting operation will
result in reference leak here. We fix it by replacing
it with pm_runtime_resume_and_get to keep usage counter
balanced.

Fixes: 604c31039dae4 ("crypto: omap-sham - Check for return value from pm_runtime_get_sync")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/omap-sham.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index ae0d320d3c60..dd53ad9987b0 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -372,7 +372,7 @@ static int omap_sham_hw_init(struct omap_sham_dev *dd)
 {
 	int err;
 
-	err = pm_runtime_get_sync(dd->dev);
+	err = pm_runtime_resume_and_get(dd->dev);
 	if (err < 0) {
 		dev_err(dd->dev, "failed to get sync: %d\n", err);
 		return err;
@@ -2244,7 +2244,7 @@ static int omap_sham_suspend(struct device *dev)
 
 static int omap_sham_resume(struct device *dev)
 {
-	int err = pm_runtime_get_sync(dev);
+	int err = pm_runtime_resume_and_get(dev);
 	if (err < 0) {
 		dev_err(dev, "failed to get sync: %d\n", err);
 		return err;
-- 
2.30.2



