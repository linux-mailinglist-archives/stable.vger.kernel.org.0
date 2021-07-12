Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23D7B3C4907
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238650AbhGLGlk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:41:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:33150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238453AbhGLGkN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:40:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90B6761106;
        Mon, 12 Jul 2021 06:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071842;
        bh=G2cBt0lFw3ggo19O0ZymoPiNsPUYW3oO44bMKFgrsY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O5G02SdLq4JkSO1CTqXK1Tj/DvS90aLZNI3eR3h5hfFNyT8K+u+Bdfm3ufSqA9N8Y
         IPTM+ea81/nBy2z2QLc+DD+/LbR9uXFxYFm/jPbxOdK48MaPKLmEAyadE2RYaq0It9
         7QNZxQgqxv+CqXwnvGE7Uj6R68WL94V/rpkFnO+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 241/593] crypto: omap-sham - Fix PM reference leak in omap sham ops
Date:   Mon, 12 Jul 2021 08:06:41 +0200
Message-Id: <20210712060909.414119090@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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
index a3b38d2c92e7..39d17ed1db2f 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -371,7 +371,7 @@ static int omap_sham_hw_init(struct omap_sham_dev *dd)
 {
 	int err;
 
-	err = pm_runtime_get_sync(dd->dev);
+	err = pm_runtime_resume_and_get(dd->dev);
 	if (err < 0) {
 		dev_err(dd->dev, "failed to get sync: %d\n", err);
 		return err;
@@ -2243,7 +2243,7 @@ static int omap_sham_suspend(struct device *dev)
 
 static int omap_sham_resume(struct device *dev)
 {
-	int err = pm_runtime_get_sync(dev);
+	int err = pm_runtime_resume_and_get(dev);
 	if (err < 0) {
 		dev_err(dev, "failed to get sync: %d\n", err);
 		return err;
-- 
2.30.2



