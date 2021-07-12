Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC483C4D13
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242219AbhGLHLt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:11:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244033AbhGLHKU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:10:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE6AB610E5;
        Mon, 12 Jul 2021 07:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073562;
        bh=mnRYRODX2g7er1tqw8vcCWPLTh7bVw7/p8chobbMU7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ViS9IuHjobXkMXF+x05VEs7Aq1bWQ2G/TtuNZRfEPhNXeKR/NwWzTnWuUCsQS7tOp
         eGWc06ojVtH+w+lE6Kl6puP2cDJhY/1EPXjmAhAQSQ4EozUhVN+J+yT+rGx9WJSblH
         5oETLFyNQ0G9EBgO16ac2HrUA6JHO4bmg2sK1nsU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 284/700] crypto: omap-sham - Fix PM reference leak in omap sham ops
Date:   Mon, 12 Jul 2021 08:06:07 +0200
Message-Id: <20210712061006.441652922@linuxfoundation.org>
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



